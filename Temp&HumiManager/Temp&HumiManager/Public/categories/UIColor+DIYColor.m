//
//  UIColor+DIYColor.m
//  SweetHooligan
//
//  Created by 谭滔 on 2017/12/8.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "UIColor+DIYColor.h"

@implementation UIColor (DIYColor)

+ (UIColor *)mainGrayColor{
    return [self colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
}

+ (UIColor *)randomColor{
    CGFloat r = (arc4random()%100)/100.f;
    CGFloat g = (arc4random()%100)/100.f;
    CGFloat b = (arc4random()%100)/100.f;
    
    return [self colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha{
    
    CGFloat r = (arc4random()%100)/100.f;
    CGFloat g = (arc4random()%100)/100.f;
    CGFloat b = (arc4random()%100)/100.f;

    return [self colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)tabBarColor{
    return [self colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
}

+ (UIColor *)mainBGColor{
    return [self colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
        
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
        
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}



@end
