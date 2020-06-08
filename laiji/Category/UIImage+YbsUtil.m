//
//  UIImage+YbsUtil.m
//  laiji
//
//  Created by xinguang hu on 2019/3/21.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "UIImage+YbsUtil.h"

@implementation UIImage (YbsUtil)

+ (UIImage *)createImageWithSize:(CGSize)size color:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 开启位图上下文
    UIGraphicsBeginImageContext(size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}



@end
