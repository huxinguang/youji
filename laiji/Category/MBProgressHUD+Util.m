//
//  MBProgressHUD+Util.m
//  laiji
//
//  Created by xinguang hu on 2019/4/15.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "MBProgressHUD+Util.h"

@implementation MBProgressHUD (Util)

+ (MBProgressHUD *)createHUD:(NSString *)message isWindow:(BOOL)isWindow{
    UIView *hudSuperView = isWindow ? [UIApplication sharedApplication].keyWindow : [UIViewController currentViewController].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:hudSuperView animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.margin = 15.0;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

// ####################### Text #########################

+ (void)showTipInViewWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showTipMessage:message isWindow:NO hideDelay:hideDelay];
}

+ (void)showTipInWindowWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showTipMessage:message isWindow:YES hideDelay:hideDelay];
}

+ (void)showTipMessage:(NSString *)message isWindow:(BOOL)isWindow hideDelay:(NSTimeInterval)hideDelay{
    MBProgressHUD *hud = [self createHUD:message isWindow:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:hideDelay];
}

// ####################### Activity #######################

+ (void)showLoadingInView{
    [self showActivityInViewWithMessage:@"加载中..."];
}
+ (void)showLoadingInWindow{
    [self showActivityInWindowWithMessage:@"加载中..."];
}

+ (void)showActivityInViewWithMessage:(NSString *)message{
    [self showActivityWithMessage:message isWindow:NO];
}

+ (void)showActivityInWindowWithMessage:(NSString *)message{
    [self showActivityWithMessage:message isWindow:YES];
}

+ (void)showActivityWithMessage:(NSString *)message isWindow:(BOOL)isWindow{
    MBProgressHUD *hud = [self createHUD:message isWindow:isWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
}

// ####################### Image #######################

+ (void)showSuccessInViewWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    
    [self showImageInViewWithImage:@"MBHUD_Success" message:message hideDelay:hideDelay];
}

+ (void)showErrorInViewWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    
    [self showImageInViewWithImage:@"MBHUD_Error" message:message hideDelay:hideDelay];
}

+ (void)showInfoInViewWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImageInViewWithImage:@"MBHUD_Info" message:message hideDelay:hideDelay];
}

+ (void)showWarningInViewWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    
    [self showImageInViewWithImage:@"MBHUD_Warn" message:message hideDelay:hideDelay];
}

+ (void)showSuccessInWindowWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImageInWindowWithImage:@"MBHUD_Success" message:message hideDelay:hideDelay];
}

+ (void)showErrorInWindowWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImageInWindowWithImage:@"MBHUD_Error" message:message hideDelay:hideDelay];
}

+ (void)showInfoInWindowWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImageInWindowWithImage:@"MBHUD_Info" message:message hideDelay:hideDelay];
}

+ (void)showWarningInWindowWithMessage:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImageInWindowWithImage:@"MBHUD_Warn" message:message hideDelay:hideDelay];
}

+ (void)showImageInViewWithImage:(NSString *)imageName message:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImage:imageName message:message isWindow:NO hideDelay:hideDelay];
}

+ (void)showImageInWindowWithImage:(NSString *)imageName message:(NSString *)message hideDelay:(NSTimeInterval)hideDelay{
    [self showImage:imageName message:message isWindow:YES hideDelay:hideDelay];
}

+ (void)showImage:(NSString *)imageName message: (NSString *)message isWindow:(BOOL)isWindow hideDelay:(NSTimeInterval)hideDelay{
    MBProgressHUD *hud = [self createHUD:message isWindow:isWindow];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [hud hideAnimated:YES afterDelay:hideDelay];
}

// ####################### hide #######################

+ (void)hideHUD{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
    [self hideHUDForView:[UIViewController currentViewController].view animated:YES];
}




@end
