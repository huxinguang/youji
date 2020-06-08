//
//  NoteItem.h
//  laiji
//
//  Created by xinguang hu on 2019/7/12.
//  Copyright © 2019 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteItem : NSObject

@property (nonatomic, assign) int snid;
@property (nonatomic, assign) int itemId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int sequence;

@end

