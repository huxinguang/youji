//
//  AddShortNoteVC.h
//  laiji
//
//  Created by xinguang hu on 2019/7/10.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "BaseViewController.h"

@class ShortNote;

typedef void(^AddNoteBlock)(ShortNote *);

@interface AddShortNoteVC : BaseViewController

- (instancetype)initWithAddBlock:(AddNoteBlock)block;

@end
