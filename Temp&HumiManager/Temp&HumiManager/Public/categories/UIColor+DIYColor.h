//
//  UIColor+DIYColor.h
//  SweetHooligan
//
//  Created by 谭滔 on 2017/12/8.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DIYColor)

+ (UIColor *)mainGrayColor;

+ (UIColor *)randomColor;

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)tabBarColor;

+ (UIColor *)mainBGColor;

/**
 * 十六进制的颜色转换为UIColor(RGB)
 */
+ (UIColor *)colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha;


@end
