//
//  NavLeftButton.m
//  guitar
//
//  Created by xinguang hu on 2019/7/1.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "NavLeftButton.h"

@interface NavLeftButton ()

@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *titleString;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *titleColor;

@end

@implementation NavLeftButton

//- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.image_name = imageName;
//        [self setImage:kImageNamed(imageName) forState:UIControlStateNormal];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title font:(UIFont *)font color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageName = imageName;
        self.titleString = title;
        self.titleFont = font;
        if (imageName.length > 0) {
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
        }
        
        if (title.length > 0) {
            [self setTitle:title forState:UIControlStateNormal];
            self.titleLabel.font = font;
            [self setTitleColor:color forState:UIControlStateNormal];
        }
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (self.imageName.length > 0) {
        UIImage *image = [UIImage imageNamed:self.imageName];
        return CGRectMake(0, contentRect.size.height/2 - image.size.height/2, image.size.width, image.size.height);
    }else{
        return CGRectZero;
    }
    
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (self.titleString.length > 0) {
        CGSize titleSize = [self.titleString sizeWithAttributes:@{NSFontAttributeName:self.titleFont}];
        return CGRectMake(0, self.bounds.size.height/2 - titleSize.height/2, titleSize.width, titleSize.height);
    }else{
        return CGRectZero;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
