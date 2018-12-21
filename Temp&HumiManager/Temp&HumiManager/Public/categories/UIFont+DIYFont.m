//
//  UIFont+DIYFont.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "UIFont+DIYFont.h"

@implementation UIFont (DIYFont)

+ (UIFont *)fitSystemFontOfSize:(CGFloat)size weight:(UIFontWeight)weight{
    if (MainScreenWidth == 375) {
        size *= 0.8;
    }
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:weight];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)fitSystemFontOfSize:(CGFloat)size{
    if (MainScreenWidth == 375) {
        size *= 0.8;
    }
    return [UIFont systemFontOfSize:size];
}





@end
