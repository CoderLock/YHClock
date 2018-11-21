//
//  NSDate+Extension.h
//  ClockView
//
//  Created by yuanheng on 2018/7/25.
//  Copyright © 2018年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 日期转为字符串
 
 @param date 转化的日期
 @param dateFormat 日期格式
 @return 日期字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/**
 服务器时间戳转为字符串
 
 @param serverTime 服务器时间戳（毫秒）
 @param dateFormat 日期格式
 @return 日期字符串
 */
+ (NSString *)stringFromServerTime:(double)serverTime dateFormat:(NSString *)dateFormat;

/**
 服务器时间转为字符串（刚刚、8分钟前、今天9:00、昨天9:00、2017-08-13 12:30）
 
 @param serverTime 服务器时间戳（毫秒）
 @param date 当前日期
 @return 日期转为字符串
 */
+ (NSString *)formatedStringFromServerTime:(double)serverTime toDate:(NSDate *)date;

/**
 时间字符串转为日期
 
 @param string 时间字符串
 @param dateFormat 日期格式
 @return 日期
 */
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

/**
 服务器时间戳转为日期
 
 @param serverTime 服务器时间戳（毫秒）
 @param dateFormat 日期格式
 @return 日期
 */
+ (NSDate *)dateFromServerTime:(double)serverTime dateFormat:(NSString *)dateFormat;

/**
 日期增加天数
 
 @param day 增加的天数
 @param date 目标日期
 @return 日期
 */
+ (NSDate *)dateByAddingDay:(NSInteger)day toDate:(NSDate *)date;

/**
 日期增加年数
 
 @param year 增加的年数
 @param date 目标日期
 @return 日期
 */
+ (NSDate *)dateByAddingYear:(NSInteger)year toDate:(NSDate *)date;

/**
 计算两个日期之间相差的天数
 
 @param fromDate 开始日期
 @param toDate   结束日期
 @return         相差的天数
 */
+ (NSInteger)computeDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 计算某个月的天数
 
 @param date 日期
 @return     天数
 */
+ (NSInteger)computeDaysOfDate:(NSDate *)date;

/**
 获取某个日期的年、月、日、周、小时、分钟。秒
 
 @param date 日期
 @return 日期信息
 */
+ (NSDateComponents *)componentsFromDate:(NSDate *)date;

/**
 比较连个日期是否同月
 
 @param startDate 开始日期
 @param endDate   结束日期
 @return 布尔值
 */
+ (BOOL)isSameMonthBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 判断是不是当前年
 
 @param serverTime 服务器时间戳（毫秒）
 @return 布尔值
 */
+ (BOOL)isThisYearWithServerTime:(double)serverTime;

@end
