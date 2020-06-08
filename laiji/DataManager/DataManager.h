//
//  DataManager.h
//  laiji
//
//  Created by xinguang hu on 2019/7/12.
//  Copyright © 2019 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortNote.h"
#import "Memo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

//note
+ (NSMutableArray *)getShortNotes;

+ (int)getItemsCount:(int)snid;

+ (BOOL)deleteNoteItem:(int)itemId;

+ (BOOL)deleteShortNote:(int)snid;

+ (BOOL)addShortNote:(ShortNote *)note;

+ (BOOL)addNoteItems:(NSMutableArray<NoteItem *> *)items;

+ (BOOL)updateNoteItem:(NoteItem *)item;

+ (BOOL)updateShortNoteTitle:(ShortNote *)note;

+ (BOOL)updateItemsOfShortNote:(ShortNote *)note;

//memo
+ (NSMutableArray *)getMemos;

+ (BOOL)addMemo:(Memo *)memo;

+ (BOOL)deleteMemo:(int)mid;

+ (BOOL)updateMemo:(Memo *)memo;



@end

NS_ASSUME_NONNULL_END
