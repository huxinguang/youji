//
//  AppDelegate.m
//  laiji
//
//  Created by xinguang hu on 2019/4/16.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "AppDelegate.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "NSString+Ybs.h"
#import "BaseNavigationController.h"
#import "UIImage+YbsUtil.h"
#import "LeftViewController.h"
#import "CenterViewController.h"
#import "RightViewController.h"

#import <UMPush/UMessage.h>

#import "AFNetworking.h"
#import "MBProgressHUD+Util.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>


@interface AppDelegate ()<WXApiDelegate,TencentSessionDelegate>

@property(nonatomic,assign) BOOL launchNetworkNotReachable;
@property(nonatomic, strong) TencentOAuth *qqOAuth;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpLaijiKeyboard];
    [UMConfigure initWithAppkey:kUMAppkey channel:@"App Store"];
    [WXApi registerApp:kWeChatAppId universalLink:kWeChatUniversalLink];
    self.qqOAuth = [[TencentOAuth alloc]initWithAppId:kQQAppId andUniversalLink:kQQUniversalLink andDelegate:self];
    [self configUPush:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self receivePush:userInfo];
    }
    
    [self startLaiji];
    
    return YES;
}

- (void)monitorNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: //未知网络
                NSLog(@"未知网络");
                [MBProgressHUD showTipInWindowWithMessage:@"网络连接异常" hideDelay:1.5];
                break;
            case AFNetworkReachabilityStatusNotReachable://无网络
                [MBProgressHUD showTipInWindowWithMessage:@"无网络连接" hideDelay:1.5];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://蜂窝
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://WIFI
                NSLog(@"WIFI");
                
                break;
        }
    }];
    [manager startMonitoring];
    
}


- (void)startLaiji{
    
    UITabBarController *tabVC = [[UITabBarController alloc]init];
    tabVC.tabBar.backgroundImage = [UIImage createImageWithSize:CGSizeMake(kAppScreenWidth, kAppTabbarHeight) color:[UIColor whiteColor]];
    tabVC.tabBar.barTintColor = [UIColor whiteColor];
    tabVC.tabBar.translucent = NO;
    
    LeftViewController *lvc = [[LeftViewController alloc]init];
    CenterViewController *cvc = [[CenterViewController alloc]init];
    RightViewController *rvc = [[RightViewController alloc]init];
    NSArray *vcs = @[lvc,cvc,rvc];
    NSArray *titles = @[@"便签",@"日记",@"我"];
    NSArray *images_nor = @[@"tab_1_nor",@"tab_2_nor",@"tab_3_nor"];
    NSArray *images_sel = @[@"tab_1_sel",@"tab_2_sel",@"tab_3_sel"];
    
    for (int i=0; i<vcs.count; i++) {
        UIViewController *vc = vcs[i];
        vc.title = titles[i];
        UIImage *image_nor = [[UIImage imageNamed:images_nor[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image_sel = [[UIImage imageNamed:images_sel[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:titles[i] image:image_nor selectedImage:image_sel];
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorHex(@"#cdcdcd"),NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:kAppThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
        
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
        nav.tabBarItem = item;
        [tabVC addChildViewController:nav];
        
    }
    
    self.window.rootViewController = tabVC;

}

- (void)setUpLaijiKeyboard{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

/*
 收到通知时，在不同的状态在点击通知栏的通知时所调用的方法不同。未启动时，点击通知的回调方法是：
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 
 而对应的通知内容则为
 
 NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
 
 当pushNotificationKey为nil时，说明用户是直接点击APP进入的，如果点击的是通知栏，那么即为对应的通知内容。
 */

- (void)configUPush:(NSDictionary *)launchOptions{
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    
}


//iOS 9.0 later
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([WXApi handleOpenURL:url delegate:self]) {
        return YES;
    }
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return  [TencentOAuth HandleOpenURL:url];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb] || userActivity.webpageURL == nil) {
        return NO;
    }
    
    if ([userActivity.webpageURL.absoluteString hasPrefix:[NSString stringWithFormat:@"%@%@",kWeChatUniversalLink,kWeChatAppId]]) {
        return [WXApi handleOpenUniversalLink:userActivity delegate:self];
    }else if ([userActivity.webpageURL.absoluteString hasPrefix:kQQUniversalLink]){
        if ([TencentOAuth CanHandleUniversalLink:userActivity.webpageURL]) {
            return [TencentOAuth HandleUniversalLink:userActivity.webpageURL];
        }
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [UMessage registerDeviceToken:deviceToken];
    NSString *token = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![deviceToken isKindOfClass:[NSData class]]) {
            //记录获取token失败的描述
            return;
        }
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        NSLog(@"########%@", token);
    }else{
        token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                             stringByReplacingOccurrencesOfString: @">" withString: @""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
        NSLog(@"########%@",token);
    }
    
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        [self receivePush:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //        [self showPushInfo:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self receivePush:userInfo];
        
        //        [self showPushInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

#endif

- (void)receivePush:(NSDictionary *)userInfo{

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req{
    
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isMemberOfClass:[SendAuthResp class]]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kWxAuthRespNotification" object:nil userInfo:@{@"resp":resp}];
    }
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

- (void)tencentDidNotNetWork{
    
}






@end
