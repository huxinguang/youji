//
//  MSJ_Macro.h
//  laiji
//
//  Created by xinguang hu on 2019/1/18.
//  Copyright © 2019 hxg. All rights reserved.
//

#ifndef MSJ_Macro_h
#define MSJ_Macro_h

//###########################👍 屏幕适配 👍###############################

#define kAppScreenWidth ([UIScreen mainScreen].bounds.size.width)//屏幕宽度
#define kAppScreenHeight ([UIScreen mainScreen].bounds.size.height)//屏幕高度
#define IS_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) //判断是否是ipad
#define IS_iPhoneX_Or_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断是否iPhone X/Xs
#define Is_iPhoneXr1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断iPHoneXr
#define Is_iPhoneXr2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断iPHoneXr
#define IS_iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断iPhoneXs Max
#define IS_X_Series (IS_iPhoneX_Or_Xs || Is_iPhoneXr1 || Is_iPhoneXr2 || IS_iPhoneXs_Max) //判断是否为带刘海的iPhone

#define kAppStatusBarHeight (IS_X_Series ? 44.f : 20.f) //状态栏高度
#define kAppNavigationBarHeight 44.f //导航栏高度（不包含状态栏）.
#define kAppTabbarHeight (IS_X_Series ? (49.f+34.f) : 49.f)// Tabbar 高度.
#define kAppTabbarSafeBottomMargin (IS_X_Series ? 34.f : 0.f)// Tabbar 底部安全高度.
#define kAppStatusBarAndNavigationBarHeight (IS_X_Series ? 88.f : 64.f)// 状态栏和导航栏总高度.

#define kSizeScale  (kAppScreenWidth>1024?1.3339:1)


//###########################👍 AppDelegate 👍#############################

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//###########################👍 KeyWindow 👍###############################

#define kAppKeyWindow [UIApplication sharedApplication].keyWindow

//##############################👍 图 片 👍################################

#define kImageWithFile(_pointer) [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AssetPicker" ofType:@"bundle"]] pathForResource:[NSString stringWithFormat:@"%@@%dx",_pointer,(int)[UIScreen mainScreen].nativeScale] ofType:@"png"]]

#define kImageNamed(name) [UIImage imageNamed:name]

//##########################👍 NSUserDefault 👍###########################

#define kUserDefaultGet(key)                [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define kUserDefaultSet(object, key)        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define kUserDefaultRemove(key)             [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define kUserDefaultSynchronize             [[NSUserDefaults standardUserDefaults] synchronize]

//########################### 👍 UIColor 👍 ###############################

#define kColorHex(hexString)     [UIColor colorWithHex:hexString]
#define kColorRGB(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kColorRGBA(r,g,b,a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kAppThemeColor kColorHex(@"E03D3A")

//############################ 👍 NSDate 👍 ###############################
#define kCurrentTimestampMillisecond  [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000]
#define kCurrentTimestampSecond       [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]

//############################ 👍 Alert 👍 ###############################


//############################ 👍 应用配置 👍 ###############################

#define kYbsMD5Secret                       @"951d4c42326611e8a17f6c92bf3bb67f"
#define kYbsUserInfoDicKey                  @"kYbsUserInfoDicKey"
#define kYbsDeviceTokenKey                  @"kYbsDeviceTokenKey"



#define kYbsNavigationBarColor                  @"#ffa733"
#define kYbsThemeColor                          @"#fdbb40"
#define kYbsNavigationTitleViewTitleFontSize    20
#define kYbsNavigationTitleViewMaxWidth         220.f
#define kYbsNavigationTitleViewHeight           44.f
#define kYbsNavigationTitleViewTitleColor       @"#FFFFFF"
#define kYbsSizeScale                           (kAppScreenWidth/375)
//#define kYbsFontCustom(fontSize)                [UIFont systemFontOfSize:fontSize*kYbsSizeScale]

#define kYbsFontCustom(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize*kYbsSizeScale]

#define kYbsFontCustomBold(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize*kYbsSizeScale]

#define kYbsRatio                               (kAppScreenWidth/375)

#define kYbsUUIDKeychainKey                     @"kYbsUUIDKeychainKey"
#define kYbsIsFirstLaunchKey                    @"kYbsIsFirstLaunchKey"
#define kYbsIsFirstLaunchValue                  @"kYbsIsFirstLaunchValue"

//############################ 👍 接口状态码 👍#############################

#define kYbsSuccess                             200
#define kYbsCodeKey                             @"code"
#define kYbsDataKey                             @"t"
#define kYbsMsgKey                              @"msg"
#define kYbsTokenExpired                        @"5555"
#define kYbsRequestFailed                       @"请求失败"

//############################## 👍 通知 👍 ###############################


//############################ 👍 第三方SDK 👍##############################

#define kUMAppkey                    @"5d36837b570df32628001112"
#define kWeChatAppId                 @"wx1c5aa1dcd873e4a6"
#define kWeChatAppSecret             @"19eecc6d8d5610f0ad783f615eb624a2"
#define kWeChatUniversalLink         @"https://www.balamoney.com/laiji/"

#define kQQAppId                     @"101847192"
#define kQQAppKey                    @"2575e783f8620baafeb93037c409abad"
#define kQQUniversalLink             @"https://www.balamoney.com/qq_conn/101847192"



#endif /* MSJ_Macro_h */
