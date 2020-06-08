//
//  LJDatePicker.m
//  laiji
//
//  Created by xinguang hu on 2019/7/23.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "LJDatePicker.h"

#define kDatePickerHeight 216
#define kDatePickerWhiteBgHeight (250 + kAppTabbarSafeBottomMargin)

@interface LJDatePicker ()

@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIDatePicker *picker;

@end

@implementation LJDatePicker

- (instancetype)initWithBlock:(ChooseBlock)block;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.chooseBlock = block;
        [self buildSubViews];
        [self addConstraints];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)buildSubViews{
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.cancelBtn];
    [self.whiteBgView addSubview:self.okBtn];
    [self.whiteBgView addSubview:self.picker];
    
}

- (void)addConstraints{
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(kDatePickerWhiteBgHeight);
        make.height.mas_equalTo(kDatePickerWhiteBgHeight);
    }];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(5);
        make.left.equalTo(self.whiteBgView).with.offset(10);
    }];
    
    [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(5);
        make.right.equalTo(self.whiteBgView).with.offset(-10);
    }];
    
    [self.picker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self.whiteBgView);
        make.bottom.equalTo(self.whiteBgView).with.offset(-kAppTabbarSafeBottomMargin);
        make.height.mas_equalTo(kDatePickerHeight);
    }];
}

- (UIView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [UIView new];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kYbsFontCustom(17);
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        _okBtn.titleLabel.font = kYbsFontCustom(17);
        [_okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
    
}

- (UIDatePicker *)picker{
    if (!_picker) {
        _picker = [[UIDatePicker alloc]init];
        _picker.datePickerMode = UIDatePickerModeDate;
        [_picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _picker;
}


#pragma mark - action

- (void)cancel{
    [self hide];
}

- (void)ok{
    if (self.chooseBlock) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:self.picker.date];
        self.chooseBlock(dateStr);
    }
    [self hide];
}

- (void)show{
    UIView *superView = [UIViewController currentViewController].navigationController.view;
    
    if (![superView.subviews containsObject:self]) {
        [superView addSubview:self];
        self.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight);
    }
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(kDatePickerWhiteBgHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(kDatePickerWhiteBgHeight);
            make.height.mas_equalTo(kDatePickerWhiteBgHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)pickerChanged:(UIDatePicker *)picker{
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
