//
//  DataManager.m
//  laiji
//
//  Created by xinguang hu on 2019/7/12.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "DataManager.h"
#import "FMDB.h"

@implementation DataManager

static FMDatabaseQueue *_queue;

+ (void)initialize{
    // 1.获得沙盒中的数据库文件名
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来
    NSString *path  = [documentFolderPath stringByAppendingPathComponent:@"laiji.sqlite"];
    NSLog(@"########%@",path);
    
    //2. 创建NSFileManager对象  NSFileManager包含了文件属性的方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //3. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:path];
    
    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist){
        //拷贝数据库
    //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
        NSString *backupDbPath = [[NSBundle mainBundle]pathForResource:@"laiji.sqlite" ofType:nil];
        
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        [fm copyItemAtPath:backupDbPath toPath:path error:nil];
    }
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
}


+ (NSMutableArray *)getShortNotes{
    __block ShortNote *snote;
    __block NSMutableArray *noteArray = nil;
    __block NoteItem *item;
    /*
     - (void)inDatabase:(void (^)(FMDatabase *db))block不可以嵌套使用。原理很简单。
     基于_queue为同步串行队列，如果嵌套使用则会引起死锁。
     */
    [_queue inDatabase:^(FMDatabase *db){
         noteArray = [NSMutableArray array];
         FMResultSet *rs = nil;
         rs = [db executeQuery:@"SELECT * FROM shortnote ORDER BY create_time DESC;"];
         while (rs.next){
             snote = [[ShortNote alloc]init];
             snote.snid = [rs intForColumn:@"id"];
             snote.title = [rs stringForColumn:@"title"];
             snote.create_time = [rs intForColumn:@"create_time"];
             [noteArray addObject:snote];
         }
     }];
    
    
    [_queue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = nil;
        for (int i=0; i<noteArray.count; i++) {
            ShortNote *sn = noteArray[i];
            NSMutableArray *noteItems = [NSMutableArray array];
            rs = [db executeQuery:@"SELECT * FROM noteitem WHERE snid = ? ORDER BY sequence",[NSNumber numberWithInt:sn.snid]];
            while (rs.next){
                item = [[NoteItem alloc]init];
                item.itemId = [rs intForColumn:@"id"];
                item.snid = [rs intForColumn:@"snid"];
                item.content = [rs stringForColumn:@"content"];
                item.sequence = [rs intForColumn:@"sequence"];
                [noteItems addObject:item];
            }
            sn.items = noteItems;
        }
        
    }];
    
    return noteArray;
    
}

+ (int)getItemsCount:(int)snid{
    __block int count = 0;
    [_queue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:@"SELECT count(*) FROM noteitem WHERE snid = ?;",[NSNumber numberWithInt:snid]];
        //You must always invoke -[FMResultSet next] before attempting to access the values returned in a query, even if you're only expecting one
        if ([rs next]) {
            count = [rs intForColumnIndex:0];
        }
    }];
    return count;
}

+ (BOOL)deleteNoteItem:(int)itemId{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db){
        success = [db executeUpdate:@"DELETE FROM noteitem WHERE id = ?",[NSNumber numberWithInt:itemId]];
    }];
    return success;
}

+ (BOOL)deleteShortNote:(int)snid{
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL ret1 = [db executeUpdate:@"DELETE FROM shortnote WHERE id = ?",[NSNumber numberWithInt:snid]];
        BOOL ret2 = [db executeUpdate:@"DELETE FROM noteitem WHERE snid = ?",[NSNumber numberWithInt:snid]];
        success = ret1 && ret2;
        if (!success) {
            *rollback = YES;
            return;
        }
    }];
    return success;
}

+ (BOOL)addShortNote:(ShortNote *)note{
    if ([self insertShortNote:note]) {
        int maxSnid = [self getCurrentMaxShortNoteID];
        __block BOOL success = YES;
        [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (int i=0; i<note.items.count; i++) {
                NoteItem *item = note.items[i];
                BOOL ret = [db executeUpdate:@"INSERT INTO noteitem (content, sequence, snid) VALUES (?,?,?)",item.content,[NSNumber numberWithInt:i],[NSNumber numberWithInt:maxSnid]];
                if (!ret) {
                    success = NO;
                    break;
                }
            }
            if (!success) {
                *rollback = YES;
                return;
            }
        }];
        
        if (!success) {
            [self deleteShortNote:maxSnid];
        }
        return success;
    
    }else{
        return NO;
    }
}

// private method
+ (BOOL)insertShortNote:(ShortNote *)note{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"INSERT INTO shortnote (title, create_time) VALUES (?,?)",note.title,[NSNumber numberWithInt:note.create_time]];
    }];
    return success;
}

+ (int)getCurrentMaxShortNoteID{
    __block int snid = 0;
    [_queue inDatabase:^(FMDatabase *db) {
        snid = (int)db.lastInsertRowId;
    }];
    return snid;
}

+ (BOOL)addNoteItems:(NSMutableArray<NoteItem *> *)items{
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i=0; i<items.count; i++) {
            NoteItem *item = items[i];
            BOOL ret = [db executeUpdate:@"INSERT INTO noteitem (content, sequence, snid) VALUES (?,?,?)",item.content,[NSNumber numberWithInt:item.sequence],[NSNumber numberWithInt:item.snid]];
            if (ret) {
                item.itemId = (int)db.lastInsertRowId;
            }else{
                success = NO;
                break;
            }
        }
        if (!success) {
            *rollback = YES;
            return;
        }
    }];
    
    return success;
    
}

+ (BOOL)updateNoteItem:(NoteItem *)item{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"UPDATE noteitem SET content = ?,sequence = ? WHERE id = ?;",item.content,[NSNumber numberWithInt:item.sequence],[NSNumber numberWithInt:item.itemId]];
    }];
    return success;
    
}

+ (BOOL)updateShortNoteTitle:(ShortNote *)note{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"UPDATE shortnote SET title = ? WHERE id = ?;",note.title,[NSNumber numberWithInt:note.snid]];
    }];
    return success;
}

+ (BOOL)updateItemsOfShortNote:(ShortNote *)note{
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i=0; i<note.items.count; i++) {
            NoteItem *item = note.items[i];
            BOOL ret = [db executeUpdate:@"UPDATE noteitem SET content = ?,sequence = ?,snid = ? WHERE id = ?;",item.content,[NSNumber numberWithInt:item.sequence],[NSNumber numberWithInt:item.snid],[NSNumber numberWithInt:item.itemId]];
            if (!ret) {
                success = NO;
                break;
            }
        }
        if (!success) {
            *rollback = YES;
            return;
        }
    }];
    
    return success;
}



//######################################

+ (NSMutableArray *)getMemos{
    
    __block Memo *memo;
    __block NSMutableArray *memoArray = nil;
    /*
     - (void)inDatabase:(void (^)(FMDatabase *db))block不可以嵌套使用。原理很简单。
     基于_queue为同步串行队列，如果嵌套使用则会引起死锁。
     */
    [_queue inDatabase:^(FMDatabase *db){
        memoArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"SELECT * FROM memo ORDER BY create_time DESC;"];
        while (rs.next){
            memo = [[Memo alloc]init];
            memo.mid = [rs intForColumn:@"id"];
            memo.title = [rs stringForColumn:@"title"];
            memo.theme = [rs stringForColumn:@"theme"];
            memo.time = [rs stringForColumn:@"time"];
            memo.content = [rs stringForColumn:@"content"];
            memo.create_time = [rs intForColumn:@"create_time"];
            [memoArray addObject:memo];
        }
    }];
    
    return memoArray;
}


+ (BOOL)addMemo:(Memo *)memo{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"INSERT INTO memo (title,theme,time ,content,create_time) VALUES (?,?,?,?,?)",memo.title,memo.theme,memo.time,memo.content,[NSNumber numberWithInt:memo.create_time]];
    }];
    return success;
}

+ (BOOL)deleteMemo:(int)mid{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db){
        success = [db executeUpdate:@"DELETE FROM memo WHERE id = ?",[NSNumber numberWithInt:mid]];
    }];
    return success;
}

+ (BOOL)updateMemo:(Memo *)memo{
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"UPDATE memo SET title = ?,theme = ?,time = ?,content = ? WHERE id = ?;",memo.title,memo.theme,memo.time,memo.content,[NSNumber numberWithInt:memo.mid]];
    }];
    return success;
}




@end
