//
//  Memo.h
//  laiji
//
//  Created by xinguang hu on 2019/7/23.
//  Copyright © 2019 hxg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Memo : NSObject

@property (nonatomic, assign) int mid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int create_time;

@end

NS_ASSUME_NONNULL_END
