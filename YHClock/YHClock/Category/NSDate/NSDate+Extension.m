//
//  NSDate+Extension.m
//  YHClock
//
//  Created by yuanheng on 2018/7/25.
//  Copyright © 2018年 ryan. All rights reserved.
//

#import "NSDate+Extension.h"

static NSString * const kDefaultDateFormatter = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (Extension)

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromServerTime:(double)serverTime dateFormat:(NSString *)dateFormat {
    NSString *date = [self stringFromServerTime:serverTime dateFormat:dateFormat];
    return [self dateFromString:date dateFormat:dateFormat];
}

+ (NSString *)formatedStringFromServerTime:(double)serverTime toDate:(NSDate *)date
{
    if (!date) { date = [NSDate date]; }
    NSDate *fromDate = [self dateFromServerTime:serverTime dateFormat:kDefaultDateFormatter];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *fromComponents = [calendar components:unitFlag fromDate:fromDate];
    NSDateComponents *toComponents = [calendar components:unitFlag fromDate:date];
    
    NSString *yearString = [self stringFromServerTime:serverTime dateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *thisYearString = [self stringFromServerTime:serverTime dateFormat:@"MM-dd HH:mm"];
    NSString *yesterdayString = [self stringFromServerTime:serverTime dateFormat:@"昨天 HH:mm"];
    NSString *todayString = [self stringFromServerTime:serverTime dateFormat:@"今天 HH:mm"];
    NSString *justNowString = @"刚刚";
    
    if (toComponents.year - fromComponents.year > 0) {
        return yearString;
    }
    if (toComponents.month - fromComponents.month > 0) {
        return thisYearString;
    }
    if (toComponents.day - fromComponents.day > 1) {
        return thisYearString;
    }
    if (toComponents.day - fromComponents.day == 1) {
        return yesterdayString;
    }
    
    NSTimeInterval fromTimeInterval = [fromDate timeIntervalSince1970];
    NSTimeInterval toTimeInterval = [date timeIntervalSince1970];
    
    if (toTimeInterval - fromTimeInterval > 60*60) {
        return todayString;
    }
    if (toTimeInterval - fromTimeInterval > 60) {
        NSInteger minute = (NSInteger)(toTimeInterval - fromTimeInterval)/60;
        NSString *minuteString = [NSString stringWithFormat:@"%ld分钟前", minute];
        return minuteString;
    }
    
    return justNowString;
}

+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter dateFromString:string];
}

+ (NSString *)stringFromServerTime:(double)serverTime dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:serverTime/1000.0];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    if (dateFormat) {
        [formatter setDateFormat:dateFormat];
    } else {
        [formatter setDateFormat:kDefaultDateFormatter];
    }
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

+ (NSDate *)dateByAddingDay:(NSInteger)day toDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    NSDate *resultDdate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return resultDdate;
}

+ (NSDate *)dateByAddingYear:(NSInteger)year toDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    NSDate *resultDdate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return resultDdate;
}

+ (NSInteger)computeDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateComponents *fromCom = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:fromDate];
    NSDateComponents *toCom = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:toDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDateComponents:fromCom toDateComponents:toCom options:NSCalendarWrapComponents];
    return components.day;
}

+ (NSInteger)computeDaysOfDate:(NSDate *)date {
    NSCalendarUnit unitFlags = NSCalendarUnitDay;
    NSInteger days = [[NSCalendar currentCalendar] component:unitFlags fromDate:date];
    return days;
}

+ (NSDateComponents *)componentsFromDate:(NSDate *)date
{
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return components;
}

+ (BOOL)isSameMonthBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSDateComponents *components1 = [self componentsFromDate:startDate];
    NSDateComponents *components2 = [self componentsFromDate:endDate];
    if (components1.year == components2.year && components1.month == components2.month)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isThisYearWithServerTime:(double)serverTime {
    NSDate *date = [NSDate date];
    NSString *thisYear = [self stringFromDate:date dateFormat:@"yyyy"];
    NSString *comparYear = [self stringFromServerTime:serverTime dateFormat:@"yyyy"];
    return [thisYear isEqualToString:comparYear];
}

@end
