//
//  HeaderCell.m
//  laiji
//
//  Created by xinguang hu on 2019/7/16.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "HeaderCell.h"
#import "TZImagePickerController.h"

@interface HeaderCell ()<TZImagePickerControllerDelegate>

@end

@implementation HeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatarBtn];
        [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(30);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [self.contentView addSubview:self.signLabel];
        [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.centerY.equalTo(self.contentView.mas_bottom).with.offset(-30);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.signLabel);
            make.left.equalTo(self.signLabel.mas_right);
            make.right.equalTo(self.contentView).with.offset(-20);
        }];
    }
    return self;
}


- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarBtn.frame = CGRectMake(kAppScreenWidth/2 -50, 200/2 - 50, 100, 100);
        UIImage *image = nil;
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imagePath = [docPath stringByAppendingPathComponent:@"avatar.jpg"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:imagePath]) {
            image = [[UIImage alloc]initWithContentsOfFile:imagePath];
        }else{
            image = kImageNamed(@"avatar_default");
        }
        [_avatarBtn setImage:image forState:UIControlStateNormal];
        _avatarBtn.layer.cornerRadius = 50;
        _avatarBtn.layer.masksToBounds = YES;
        [_avatarBtn addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarBtn;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc]init];
        _signLabel.frame = CGRectMake(20, 200 - 40, 70, 20);
        _signLabel.text = @"个性签名：";
        _signLabel.textColor = kAppThemeColor;
        _signLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _signLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @"点击设置您的个性签名";
        _contentLabel.textColor = kColorHex(@"666666");
        _contentLabel.font = [UIFont boldSystemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        _contentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signClick)];
        [_contentLabel addGestureRecognizer:tap];
    }
    return _contentLabel;
}

- (void)avatarClick{
    __weak typeof (self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowCrop = YES;
    imagePickerVc.naviBgColor = kAppThemeColor;
    imagePickerVc.navigationBar.translucent = NO;
    CGFloat rWidth = kAppScreenWidth - 10*2;
    imagePickerVc.cropRect = CGRectMake(10, kAppScreenHeight/2 - rWidth/2, rWidth, rWidth);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *image = photos[0];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imagePath = [docPath stringByAppendingPathComponent:@"avatar.jpg"];
        NSLog(@"###%@",imagePath);
        if ([[NSFileManager defaultManager]fileExistsAtPath:imagePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
            if (!error) {
                [UIImageJPEGRepresentation(image, 0.3) writeToFile:imagePath atomically:YES];
            }else{
                [MBProgressHUD showTipInWindowWithMessage:@"修改头像失败" hideDelay:1.5];
            }
        }else{
            [UIImageJPEGRepresentation(image, 0.3) writeToFile:imagePath atomically:YES];
        }
        
        [weakSelf.avatarBtn setImage:image forState:UIControlStateNormal];
    }];
    [[UIViewController currentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)signClick{
    
    __weak typeof (self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑签名" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        NSString *content = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (content.length > 0) {
            kUserDefaultSet(content, @"signature");
            kUserDefaultSynchronize;
            weakSelf.contentLabel.text = content;
        }else{
            [MBProgressHUD showTipInWindowWithMessage:@"内容不能为空" hideDelay:1.5];
        }
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = kUserDefaultGet(@"signature");
    }];
    
    [[UIViewController currentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
