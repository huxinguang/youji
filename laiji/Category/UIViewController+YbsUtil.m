//
//  UIViewController+YbsUtil.m
//  laiji
//
//  Created by xinguang hu on 2019/1/18.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "UIViewController+YbsUtil.h"
#import <objc/runtime.h>

@implementation UIViewController (YbsUtil)


+ (UIViewController*)findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

+ (UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
    
}

- (UIViewController *) getViewControllerThatPushMe{
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *vc = nil;
    if (vcs.count > 1) {
        NSInteger pushMeVcIndex = [vcs indexOfObject:self] - 1;
        vc = vcs[pushMeVcIndex];
    }
    return vc;
}

//设置状态栏透明

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated{
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    if (hidden) {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                statusBar.alpha = 0.0f;
            }];
        }else{
            statusBar.alpha = 0.0f;
        }
        
    }else{
        if (animated) {
            [UIView animateWithDuration:1 animations:^{
                statusBar.alpha = 1.0f;
            }];
        }else{
            statusBar.alpha = 1.0f;
        }
    }
}


//分类添加属性

- (void)setAppearedNeedRefresh:(BOOL)appearedNeedRefresh{
    objc_setAssociatedObject(self, @selector(appearedNeedRefresh), [NSNumber numberWithBool:appearedNeedRefresh], OBJC_ASSOCIATION_ASSIGN);
    
}

- (BOOL)appearedNeedRefresh{
    return [objc_getAssociatedObject(self, @selector(appearedNeedRefresh)) boolValue];
}


- (void)setOperateIndexPath:(NSIndexPath *)operateIndexPath{
    objc_setAssociatedObject(self, @selector(operateIndexPath), operateIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)operateIndexPath{
    return objc_getAssociatedObject(self, @selector(operateIndexPath));
}





@end
