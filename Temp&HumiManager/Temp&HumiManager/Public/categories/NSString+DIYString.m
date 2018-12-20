//
//  NSString+DIYString.m
//  Hoologaner
//
//  Created by terry on 2018/1/23.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "NSString+DIYString.h"

@implementation NSString (DIYString)


/**
 * 将十六进制数 的 字符串转int
 */
- (int)toDecimalByHex{
    const char * hexChar = [self cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x",&hexNumber);
    return hexNumber;
}


/**
 * 类方法计算size大小
 */
+ (CGSize)sizeWithString:(NSString *)str andFount:(UIFont *)font andMaxSize:(CGSize)size{

    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/*!
 * 将数字月份转英文
 */
+ (NSString *)englishMonth:(int)month IsAb:(bool)ab{

    switch (month) {
        case 1:
            return ab?@"Jan":@"January";
            break;
        case 2:
            return ab?@"Feb":@"February";
            break;
        case 3:
            return ab?@"Mar":@"March";
            break;
        case 4:
            return ab?@"Apr":@"April";
            break;
        case 5:
            return ab?@"May":@"May";
            break;
        case 6:
            return ab?@"June":@"June";
            break;
        case 7:
            return ab?@"July":@"July";
            break;
        case 8:
            return ab?@"Aug":@"Aguest";
            break;
        case 9:
            return ab?@"Sep":@"September";
            break;
        case 10:
            return ab?@"Oct":@"October";
            break;
        case 11:
            return ab?@"Nov":@"November";
            break;
        case 12:
            return ab?@"Dec":@"December";
            break;

        default:
            return @"";
            break;
    }
}

/*!
 * 判断指定区间的字符串是否和指定的字符串相同
 */
- (bool)isEqualToString:(NSString *)aString InRange:(NSRange)range{
    NSString *theStr = [self substringWithRange:range];
    return [aString isEqualToString:theStr];
}

/*!
 * 判断两个字符串是否相同（忽略大小写）
 */
- (bool)isSameToString:(NSString *)aStr{
    //NSOrderedDescending判断两对象值的大小(按字母顺序进行比较，astring02小于astring01为真)
    BOOL result = ([self caseInsensitiveCompare:aStr] == NSOrderedSame);
    return result;
}

/**
 * 对象方法计算size大小
 */
- (CGSize)sizeWithFount:(UIFont *)font andMaxSize:(CGSize)size{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 * 取一个字符串中，两个字符串之间的字符串
 */
- (NSString *)getStringBetweenFormerString:(NSString *)formString AndLaterString:(NSString *)laterString{

    NSRange range1 = [self rangeOfString:formString];
    NSUInteger i1 = range1.location+range1.length;
    NSRange range2 = [self rangeOfString:laterString];
    NSUInteger i2 = range2.location;
    NSUInteger length = i2-i1;
    NSString *str = [self substringWithRange:NSMakeRange(i1, length)];

    return str;
}

- (NSString *)getLaterStringOfAString:(NSString *)astring{
    NSRange range = [self rangeOfString:astring];
    if (range.location >= self.length) {
        return nil;
    }
    return [self substringFromIndex:range.location+range.length];
}

- (NSString *)getFormerStringOfAString:(NSString *)astring{
    NSRange range = [self rangeOfString:astring];
    if (range.location >= self.length) {
        return nil;
    }
    return [self substringToIndex:range.location];
}

/*!
 * 得到第几位的字符串
 */
- (NSString *)stringOfIndex:(NSInteger)index{
    return [self substringWithRange:NSMakeRange(index, 1)];
}

/**
 * 中文字符转码
 */
- (NSString *)getUTF8String{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


/*!
 * 生成一个指定长度的随机字符串
 */
+ (NSString *)randomStringWithLength:(int)length{
    NSArray <NSString *> *arrWords = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    NSString *string = @"";
    for (int i=0; i<length; i++) {
        int count = arc4random_uniform((int)arrWords.count);
        string = [string stringByAppendingString:[arrWords objectAtIndex:count]];
    }
    return string;
}

+ (NSString *)randomNumberStringWithLength:(int)length{
    NSArray <NSString *> *arrWords = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSString *string = @"";
    for (int i=0; i<length; i++) {
        int count = arc4random_uniform((int)arrWords.count);
        string = [string stringByAppendingString:[arrWords objectAtIndex:count]];
    }
    return string;
}


@end
