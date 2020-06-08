//
//  RightViewController.m
//  laiji
//
//  Created by xinguang hu on 2019/7/10.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "RightViewController.h"
#import "HeaderCell.h"
#import "AboutUsViewController.h"
#import <MessageUI/MessageUI.h>
#import <SafariServices/SafariServices.h>

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>


@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *images;

@end

static NSString *headerCellID = @"HeaderCellID";
static NSString *itemCellID = @"ItemCellID";

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"推荐给好友",@"用户反馈",@"隐私协议",@"关于犹记"];
    self.images = @[@"bangzhu",@"fankui",@"pravicy",@"aboutus"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.separatorColor = kAppThemeColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HeaderCell class] forCellReuseIdentifier:headerCellID];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:itemCellID];
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellID];
        if (!cell) {
            cell = [[HeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = kImageNamed(self.images[indexPath.row]);
        cell.textLabel.text = self.titles[indexPath.row];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"分享到" preferredStyle:UIAlertControllerStyleActionSheet];
            
            if ([WXApi isWXAppInstalled]) {
                [alert addAction:[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.text = @"犹记app很不错哦，快去AppStore搜索下载吧";
                    req.bText = YES;
                    req.scene = 0;
                    [WXApi sendReq:req completion:nil];
                }]];
            }
            
            if ([QQApiInterface isQQInstalled]) {
                [alert addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"犹记app很不错哦，快去AppStore搜索下载吧"];
                    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
                    //将内容分享到qq
                    [QQApiInterface sendReq:req];
                    
                }]];
            }
            
            [alert addAction:[UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([MFMessageComposeViewController canSendText]) {
                    MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc]init];
                    sms.body = @"犹记app很不错哦，快去AppStore搜索下载吧";
                    sms.messageComposeDelegate = self;
                    sms.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:sms animated:true completion:nil];
                }else{
                    [MBProgressHUD showTipInViewWithMessage:@"您的设备没有安装SIM卡" hideDelay:1.5];
                }
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                    [mail setSubject:@"分享给你一款好用的app"];
                    NSString *messBody = @"犹记，很好的备忘app，小伙伴们快来一起体验吧~";
                    [mail setMessageBody:messBody isHTML:NO];
                    mail.mailComposeDelegate = self;
                    mail.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:mail animated:YES completion:nil];
                }else{
                    [MBProgressHUD showTipInViewWithMessage:@"您的设备还没有设置邮件哦" hideDelay:1.5];
                }
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            
            [self presentViewController:alert animated:true completion:nil];
            
        }else if (indexPath.row == 1){
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            if (mail) {
                [mail.navigationBar setTintColor:kAppThemeColor];
                [mail setSubject:@"犹记使用反馈"];
                NSString *messBody = [NSString stringWithFormat:@"针对犹记当前版本:%@,%@,OS %@\n我的反馈和建议：\n1、\n2、\n3、",[UIApplication sharedApplication].appVersion,[UIDevice currentDevice].model,[UIDevice currentDevice].systemVersion];
                [mail setMessageBody:messBody isHTML:NO];
                [mail setToRecipients:@[@"hxg0925@163.com"]];
                mail.mailComposeDelegate = self;
                [self presentViewController:mail animated:YES completion:nil];
            }
            
        }else if (indexPath.row == 2){
            if (@available(iOS 9.0, *)) {
                SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[[NSURL alloc] initWithString:@"https://raw.githubusercontent.com/huxinguang/pravicy/master/youji.md"]];
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
        }else if (indexPath.row == 3){
            AboutUsViewController *vc = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }else{
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor blueColor];
    return view;
}

#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSString *msg = @"";
    if (result == MFMailComposeResultCancelled){
        msg = @"已取消发送";
    } else if (result == MFMailComposeResultSent){
        msg = @"发送成功";
    } else{
        msg = @"发送失败";
    }
    [MBProgressHUD showTipInWindowWithMessage:msg hideDelay:1.5];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSString *msg = @"";
    if (result == MessageComposeResultCancelled) {
        msg = @"已取消发送";
    }else if (result == MessageComposeResultSent){
        msg = @"发送成功";
    }else{
        msg = @"发送失败";
    }
    [MBProgressHUD showTipInViewWithMessage:msg hideDelay:1.5];
    [controller dismissViewControllerAnimated:true completion:nil];
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
