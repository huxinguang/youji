//
//  AddMemoVC.h
//  laiji
//
//  Created by xinguang hu on 2019/7/23.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "BaseViewController.h"
#import "Memo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddMemoBlock)(Memo *);

@interface AddMemoVC : BaseViewController

- (instancetype)initWithAddBlock:(AddMemoBlock)block;

@end

NS_ASSUME_NONNULL_END
