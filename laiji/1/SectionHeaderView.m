//
//  SectionHeaderView.m
//  laiji
//
//  Created by xinguang hu on 2019/7/16.
//  Copyright © 2019 hxg. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kAppScreenWidth-20, 60)];
        label.font = [UIFont boldSystemFontOfSize:23];
        self.titleLabel = label;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
