//
//  NSString+DIYString.h
//  Hoologaner
//
//  Created by terry on 2018/1/23.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DIYString)

/**
 * 将十六进制数 的 字符串转int
 */
- (int)toDecimalByHex;

/*!
 * 判断两个字符串是否相同（忽略大小写）
 */
- (bool)isSameToString:(NSString *)aStr;

/**
 * 类方法计算size大小
 */
+ (CGSize)sizeWithString:(NSString *)str andFount:(UIFont *)font andMaxSize:(CGSize)size;

/*!
 * 将数字月份转英文
 * @parama ab 是否缩写
 */
+ (NSString *)englishMonth:(int)month IsAb:(bool)ab;


/**
 * 对象方法计算size大小
 */
- (CGSize)sizeWithFount:(UIFont *)font andMaxSize:(CGSize)size;

/*!
 * 取一个字符串中，两个字符串之间的字符串
 */
- (NSString *)getStringBetweenFormerString:(NSString *)formString AndLaterString:(NSString *)laterString;

/*!
 * 得到指定字符串之前的字符串
 */
- (NSString *)getFormerStringOfAString:(NSString *)astring;

/*!
 * 得到指定字符串之后的字符串
 */
- (NSString *)getLaterStringOfAString:(NSString *)astring;

/*!
 * 得到第几位的字符串
 */
- (NSString *)stringOfIndex:(NSInteger)index;

/**
 * 中文字符转码
 */
- (NSString *)getUTF8String;

/*!
 * 判断指定区间的字符串是否和指定的字符串相同
 */
- (bool)isEqualToString:(NSString *)aString InRange:(NSRange)range;

/*!
 * 生成一个指定长度的随机字符串（字母）
 */
+ (NSString *)randomStringWithLength:(int)length;

/*!
 * 生成一个指定长度的随机字符串（数字）
 */
+ (NSString *)randomNumberStringWithLength:(int)length;

@end
