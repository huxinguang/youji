//
//  LJDatePicker.h
//  laiji
//
//  Created by xinguang hu on 2019/7/23.
//  Copyright © 2019 hxg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseBlock)(NSString *);

@interface LJDatePicker : UIView

@property (nonatomic, copy  ) ChooseBlock chooseBlock;

- (instancetype)initWithBlock:(ChooseBlock)block;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
