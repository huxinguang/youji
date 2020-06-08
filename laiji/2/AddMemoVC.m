//
//  AddMemoVC.m
//  laiji
//
//  Created by xinguang hu on 2019/7/23.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "AddMemoVC.h"

#import "LJDatePicker.h"
#import "UITextView+XGPlaceholder.h"
#import "DataManager.h"

@interface AddMemoVC ()

@property(nonatomic, strong) Memo *memo;
@property(nonatomic, strong) UITextField *titleTextField;
@property(nonatomic, strong) UITextField *themeTextField;
@property(nonatomic, strong) UIButton *timeBtn;
@property(nonatomic, strong) LJDatePicker *datePicker;
@property(nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, copy  ) AddMemoBlock block;


@end

@implementation AddMemoVC

- (instancetype)initWithAddBlock:(AddMemoBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

-(void)configLeftItem{
    NavLeftButton *btn = [[NavLeftButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:nil title:@"取消" font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)configRightItem{
    NavRightButton *btn = [[NavRightButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) imageName:nil title:@"保存" font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (LJDatePicker *)datePicker{
    if (!_datePicker) {
        __weak typeof (self) weakSelf = self;
        _datePicker = [[LJDatePicker alloc]initWithBlock:^(NSString *dateString) {
            
            [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@"日期：%@",dateString] forState:UIControlStateNormal];
        }];
    }
    return _datePicker;
}

- (UITextField *)titleTextField{
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc]init];
        _titleTextField.font = [UIFont boldSystemFontOfSize:21];
        _titleTextField.placeholder = @"点我加日记标题";
        _titleTextField.textAlignment = NSTextAlignmentCenter;
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return _titleTextField;
}

- (UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc]init];
        [_timeBtn setTitle:@"日期：2019-7-23" forState:UIControlStateNormal];
        [_timeBtn addTarget:self action:@selector(onTimeClick) forControlEvents:UIControlEventTouchUpInside];
        [_timeBtn setTitleColor:kColorHex(@"666666") forState:UIControlStateNormal];
        [_timeBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _timeBtn;
}

- (UITextField *)themeTextField{
    if (!_themeTextField) {
        _themeTextField = [[UITextField alloc]init];
        _themeTextField.placeholder = @"点我加标签";
        _themeTextField.textAlignment = NSTextAlignmentRight;
        _themeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _themeTextField.textColor = kColorHex(@"666666");
        [_themeTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _themeTextField;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.font = [UIFont systemFontOfSize:17];
        _contentTextView.xg_placeholder = @"点我输入日记内容";
        _contentTextView.xg_placeholderColor = kColorHex(@"666666");
    }
    return _contentTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建日记";
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.timeBtn];
    [self.view addSubview:self.themeTextField];
    [self.view addSubview:self.contentTextView];

    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.view).with.offset(20);
    }];

    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(self.titleTextField.mas_bottom).with.offset(10);
    }];
    
    [self.themeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBtn.mas_right).with.offset(10);
        make.right.equalTo(self.view).with.offset(-15);
        make.centerY.equalTo(self.timeBtn);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.timeBtn.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)saveAction{
    if (self.titleTextField.text.length <= 0) {
        [MBProgressHUD showTipInWindowWithMessage:@"请输入标题" hideDelay:1];
        return;
    }
    if (self.themeTextField.text.length <= 0) {
        [MBProgressHUD showTipInWindowWithMessage:@"请添加标签" hideDelay:1];
        return;
    }
    if (self.contentTextView.text.length <= 0) {
        [MBProgressHUD showTipInWindowWithMessage:@"请输入日记内容" hideDelay:1];
        return;
    }
    
    Memo *memo = [[Memo alloc]init];
    memo.title = self.titleTextField.text;
    memo.theme = self.themeTextField.text;
    memo.time = [self.timeBtn.titleLabel.text substringFromIndex:3];
    memo.content = self.contentTextView.text;
    memo.create_time = (int)[[NSDate date] timeIntervalSince1970];
    if (![DataManager addMemo:memo]) {
        [MBProgressHUD showTipInWindowWithMessage:@"保存日记失败" hideDelay:1.5];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block(memo);
        }
    }];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onTimeClick{
    [self.datePicker show];
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
