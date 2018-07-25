//
//  YHDate.h
//  YHClock
//
//  Created by yuanheng on 2018/7/25.
//  Copyright © 2018年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHClock;

/**
 转动指针时的代理方法
 */
@protocol YHClockDelegate <NSObject>

@optional

- (void)clock:(YHClock *)clock hours:(NSInteger)hours minutes:(NSInteger)minutes;

@end

@interface YHClock : UIView

/** 设置时钟显示的时间, 默认为当前系统时间 */
@property (nonatomic, strong) NSDate *date;
/** 当前小时 */
@property (nonatomic, assign, readonly) NSInteger hours;
/** 当前分钟 */
@property (nonatomic, assign, readonly) NSInteger minutes;

@property (nonatomic, weak) id<YHClockDelegate> delegate;

@end
