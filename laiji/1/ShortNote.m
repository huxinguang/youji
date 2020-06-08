//
//  ShortNote.m
//  laiji
//
//  Created by xinguang hu on 2019/7/12.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "ShortNote.h"

@implementation ShortNote

- (NSMutableArray<NoteItem *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
