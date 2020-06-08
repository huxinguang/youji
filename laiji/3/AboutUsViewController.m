//
//  AboutUsViewController.m
//  laiji
//
//  Created by xinguang hu on 2019/7/16.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "AboutUsViewController.h"
#import <SafariServices/SafariServices.h>

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于犹记";
}

- (IBAction)onBlogClick:(id)sender {
    
    if (@available(iOS 9.0, *)) {
        SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[[NSURL alloc] initWithString:@"https://blog.csdn.net/huxinguang_ios"]];
        if (@available(iOS 10.0, *)) {
            sf.preferredBarTintColor = kAppThemeColor;
            sf.preferredControlTintColor = [UIColor whiteColor];
        }
        if (@available(iOS 11.0, *)) {
            sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
        }
        [self presentViewController:sf animated:YES completion:nil];
    }
    else {
        NSURL * urlstr = [NSURL URLWithString:@"https://blog.csdn.net/huxinguang_ios"];
        [[UIApplication sharedApplication] openURL:urlstr];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
