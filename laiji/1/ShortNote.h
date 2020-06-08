//
//  ShortNote.h
//  laiji
//
//  Created by xinguang hu on 2019/7/12.
//  Copyright © 2019 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteItem.h"

@interface ShortNote : NSObject

@property (nonatomic, assign) int snid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int create_time;
@property (nonatomic, strong) NSMutableArray<NoteItem *> *items;

@end

