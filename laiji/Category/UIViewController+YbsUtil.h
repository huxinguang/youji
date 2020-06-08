//
//  UIViewController+YbsUtil.h
//  laiji
//
//  Created by xinguang hu on 2019/1/18.
//  Copyright © 2019 hxg. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YbsUtil)

@property (nonatomic, assign) BOOL appearedNeedRefresh;
@property (nonatomic, strong) NSIndexPath *operateIndexPath;


+ (UIViewController*) currentViewController;

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (UIViewController *) getViewControllerThatPushMe;

@end

NS_ASSUME_NONNULL_END
