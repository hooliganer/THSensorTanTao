//
//  NSDate+DIYDate.m
//  Hoologaner
//
//  Created by terry on 2018/4/13.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "NSDate+DIYDate.h"

@interface NSDate ()

@end

@implementation NSDate (DIYDate)


/**
 当前时间字符串

 @return yyyyMMddHHmmss字符串
 */
+ (NSString *)currentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //YYYY-MM-dd HH:mm:ss
    [formatter setDateFormat:@"yyyyMMddHHmmss"];

    //现在时间,你可以输出来看下是什么格式
    NSDate * datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];

    return currentTimeString;
}

- (NSString *)times{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //YYYY-MM-dd HH:mm:ss
    [formatter setDateFormat:@"yyyyMMddHHmmss"];

    //现在时间,你可以输出来看下是什么格式
    NSString *currentTimeString = [formatter stringFromDate:self];

    return currentTimeString;
}



/**
 获取与当前日期相差天数的日期

 @param day 相差的天数
 @return 日期
 */
+ (NSDate *)dateWithDay:(int)day{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    interval = interval + day*3600*24;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSDate *)nowDateWithSecond:(int)sec{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    interval = interval + sec;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}


+ (int)currentYear{
    NSString * time = [NSDate currentTimes];
    NSString * year = [time substringWithRange:NSMakeRange(0, 4)];
    return [year intValue];
}

+ (int)currentMonth{
    NSString * time = [NSDate currentTimes];
    NSString * year = [time substringWithRange:NSMakeRange(4, 2)];
    return [year intValue];
}

+ (int)currentDay{
    NSString * time = [NSDate currentTimes];
    NSString * year = [time substringWithRange:NSMakeRange(6, 2)];
    return [year intValue];
}

+ (int)currentHour{
    NSString * time = [NSDate currentTimes];
    NSString * year = [time substringWithRange:NSMakeRange(8, 2)];
    return [year intValue];
}

+ (int)currentMinute{
    NSString * time = [NSDate currentTimes];
    NSString * year = [time substringWithRange:NSMakeRange(10, 2)];
    return [year intValue];
}

+ (int)currentSecond{
    NSString * time = [NSDate currentTimes];
    NSString * year = [time substringWithRange:NSMakeRange(12, 2)];
    return [year intValue];
}

- (int)nYear{
    NSString * time = [self times];
    NSString * year = [time substringWithRange:NSMakeRange(0, 4)];
    return [year intValue];
}

- (int)nMonth{
    NSString * time = [self times];
    NSString * year = [time substringWithRange:NSMakeRange(4, 2)];
    return [year intValue];
}

- (int)nDay{
    NSString * time = [self times];
    NSString * year = [time substringWithRange:NSMakeRange(6, 2)];
    return [year intValue];
}

- (int)nHour{
    NSString * time = [self times];
    NSString * year = [time substringWithRange:NSMakeRange(8, 2)];
    return [year intValue];
}

- (int)nMinute{
    NSString * time = [self times];
    NSString * year = [time substringWithRange:NSMakeRange(10, 2)];
    return [year intValue];
}

- (int)nSecond{
    NSString * time = [self times];
    NSString * year = [time substringWithRange:NSMakeRange(12, 2)];
    return [year intValue];
}

/*!
 * 以时区"zh-Hans"为准进行校正的当前日期
 */
+ (NSDate *)zoneDate{

    NSDate *date = [NSDate date];
    NSTimeZone *srcTimeZone = [NSTimeZone timeZoneWithName:@"zh-Hans"];
    NSTimeZone *dstTimeZone = [NSTimeZone systemTimeZone];
    NSInteger srcGMTOffset = [srcTimeZone secondsFromGMTForDate:date];
    NSInteger dstGMTOffset = [dstTimeZone secondsFromGMTForDate:date];

    NSTimeInterval interval = dstGMTOffset - srcGMTOffset;

    NSDate *dstDate = [[NSDate alloc]initWithTimeInterval:interval sinceDate:date];

    return dstDate;
}

/*!
 * 字符串转NSDate(会进行时区校正)
 */
+ (NSDate *)dateWith_yyyyMMddHHmmss:(NSString *)string{

    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];

    NSDate *sourceDate = [format dateFromString:string];

    NSTimeZone *srcTimeZone = [NSTimeZone timeZoneWithName:@"zh-Hans"];
    NSTimeZone *dstTimeZone = [NSTimeZone systemTimeZone];
    NSInteger srcGMTOffset = [srcTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger dstGMTOffset = [dstTimeZone secondsFromGMTForDate:sourceDate];

    NSTimeInterval interval = dstGMTOffset - srcGMTOffset;

    NSDate *dstDate = [[NSDate alloc]initWithTimeInterval:interval sinceDate:sourceDate];

    return dstDate;
}

- (NSDate *)fitZone{

    NSTimeZone *srcTimeZone = [NSTimeZone timeZoneWithName:@"zh-Hans"];
    NSTimeZone *dstTimeZone = [NSTimeZone systemTimeZone];
    NSInteger srcGMTOffset = [srcTimeZone secondsFromGMTForDate:self];
    NSInteger dstGMTOffset = [dstTimeZone secondsFromGMTForDate:self];

    NSTimeInterval interval = dstGMTOffset - srcGMTOffset;

    NSDate *dstDate = [[NSDate alloc]initWithTimeInterval:interval sinceDate:self];

    return dstDate;
}

- (NSDate *)deFitZone{

    NSTimeZone *srcTimeZone = [NSTimeZone timeZoneWithName:@"zh-Hans"];
    NSTimeZone *dstTimeZone = [NSTimeZone systemTimeZone];
    NSInteger srcGMTOffset = -[srcTimeZone secondsFromGMTForDate:self];
    NSInteger dstGMTOffset = -[dstTimeZone secondsFromGMTForDate:self];

    NSTimeInterval interval = dstGMTOffset - srcGMTOffset;

    NSDate *dstDate = [[NSDate alloc]initWithTimeInterval:interval sinceDate:self];

    return dstDate;
}

- (NSString *)string_yyyyMMddHHmmss{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString *string = [format stringFromDate:[self deFitZone]];
    return string;
}

- (int)year{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:[self deFitZone]];
    return (int)[comps year];
}

/*!
 * 相差多少年的年份
 */
- (int)yearWithNumber:(int)number{
    return ([self year] + number);
}

/*!
 * 相差多少月的月份
 */
- (int)monthWithNumber:(int)number{
    number = number%12;
    int month = [self month] + number;
    month = month%12;
    if (month < 1) {
        month += 12;
    }
    return month;
}

/*!
 * 相差多少天
 */
- (int)dayWithNumber:(int)number{
    NSTimeInterval day = 24 * 60 * 60 * number;
    NSDate *newDate = [self dateByAddingTimeInterval:day];
    return [newDate day];
}

/*!
 * 相差多少小时
 */
- (int)hourWithNumber:(int)number{
    NSTimeInterval hours = 60 * 60 * number;
    NSDate *newDate = [self dateByAddingTimeInterval:hours];
    return [newDate hour];
}

/*!
 * 相差多少分
 */
- (int)minuteWithNumber:(int)number{
    NSTimeInterval mins = 60 * number;
    NSDate *newDate = [self dateByAddingTimeInterval:mins];
    return [newDate minute];
}

/*!
 * 相差多少秒
 */
- (int)secondWithNumber:(int)number{
    NSTimeInterval secs = number;
    NSDate *newDate = [self dateByAddingTimeInterval:secs];
    return [newDate second];
}

- (int)month{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:[self deFitZone]];
    return (int)[comps month];
}

- (int)day{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:[self deFitZone]];
    return (int)[comps day];
}

- (int)hour{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour fromDate:[self deFitZone]];
    return (int)[comps hour];
}

- (int)minute{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitMinute fromDate:[self deFitZone]];
    return (int)[comps minute];
}

- (int)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitSecond fromDate:[self deFitZone]];
    
    return (int)[comps second];
}

- (int)weekday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[self deFitZone]];
    NSInteger weekday = [comps weekday] - 1;
    if (weekday == 0) {
        weekday = 7;
    }
    return (int)weekday;
}

/*!
 * 年的第几周
 */
- (int)numberWeekOfYear{

    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfYear fromDate:[self deFitZone]];
    return (int)[comps weekOfYear];
}

/*!
 * 月的第几周
 */
- (int)numberWeekOfMonth{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekdayOrdinal fromDate:[self deFitZone]];
//    NSLog(@"weekOfMonth:%d -- weekdayOrdinal:%d",[comps weekOfMonth],[comps weekdayOrdinal]);
    return (int)[comps weekOfYear];
}

/*!
 * 后一天
 */
- (NSDate *)nextDay{
    NSTimeInterval day = 24 * 60 * 60;
    return [self dateByAddingTimeInterval:day];
}

/*!
 * 前一天
 */
- (NSDate *)lastDay{
    NSTimeInterval day = 24 * 60 * 60;
    return [self dateByAddingTimeInterval:-day];
}

/*!
 * 相差几天的日期
 */
- (NSDate *)dateWithDays:(int)days{
    NSTimeInterval day = 24 * 60 * 60 * days;
    return [self dateByAddingTimeInterval:day];
}

/*!
 * 把日期转换成整点的日期
 */
- (NSDate *)intByHour{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * component = [calendar components:
                                    NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay|
                                    NSCalendarUnitHour|
                                    NSCalendarUnitMinute|
                                    NSCalendarUnitSecond
                                               fromDate:self];
    component.minute = 0;
    component.second = 0;
    return [calendar dateFromComponents:component];
}

/*!
 * 把日期转换成整天的日期（00点）
 */
- (NSDate *)intByDay{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * component = [calendar components:
                                    NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay|
                                    NSCalendarUnitHour|
                                    NSCalendarUnitMinute|
                                    NSCalendarUnitSecond
                                               fromDate:self];
    component.hour = 0;
    component.minute = 0;
    component.second = 0;
    return [calendar dateFromComponents:component];
}



@end
