//
//  NSDate+DIYDate.h
//  Hoologaner
//
//  Created by terry on 2018/4/13.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DIYDate)

/*!
 * 以时区"zh-Hans"为准进行校正的当前日期
 */
+ (NSDate *)zoneDate;

+ (int)currentYear;

+ (int)currentMonth;

+ (int)currentDay;

+ (int)currentHour;

+ (int)currentMinute;

+ (int)currentSecond;

/**
 获取与当前日期相差天数的日期

 @param day 相差的天数
 @return 日期
 */
+ (NSDate *)dateWithDay:(int)day;

+ (NSDate *)nowDateWithSecond:(int)sec;

/*!
 * 字符串转NSDate(会进行时区校正)
 */
+ (NSDate *)dateWith_yyyyMMddHHmmss:(NSString *)string;

/*!
 * 时区校正
 */
- (NSDate *)fitZone;

/*!
 * 时区反校正
 */
- (NSDate *)deFitZone;

/*!
 * 后一天
 */
- (NSDate *)nextDay;

/*!
 * 前一天
 */
- (NSDate *)lastDay;

/*!
 * 相差几天的日期
 */
- (NSDate *)dateWithDays:(int)days;

/*!
 * 把日期转换成整点的日期
 */
- (NSDate *)intByHour;

/*!
 * 把日期转换成整天的日期（00点）
 */
- (NSDate *)intByDay;





/*!
 * 日期转字符串(会进行时区反校正)
 */
- (NSString *)string_yyyyMMddHHmmss;

/**
 当前时间字符串

 @return yyyyMMddHHmmss字符串
 */
+ (NSString *)currentTimes;

- (NSString *)times;

- (int)year;

- (int)month;

- (int)day;

- (int)hour;

- (int)minute;

- (int)second;

- (int)weekday;

- (int)nYear;

- (int)nMonth;

- (int)nDay;

- (int)nHour;

- (int)nMinute;

- (int)nSecond;

/*!
 * 年的第几周
 */
- (int)numberWeekOfYear;

/*!
 * 月的第几周
 */
- (int)numberWeekOfMonth;



/*!
 * 相差多少年的年份
 */
- (int)yearWithNumber:(int)number;

/*!
 * 相差多少月的月份
 */
- (int)monthWithNumber:(int)number;

/*!
 * 相差多少天
 */
- (int)dayWithNumber:(int)number;
/*!
 * 相差多少小时
 */
- (int)hourWithNumber:(int)number;

/*!
 * 相差多少分
 */
- (int)minuteWithNumber:(int)number;

/*!
 * 相差多少秒
 */
- (int)secondWithNumber:(int)number;





@end
