//
//  UIFont+DIYFont.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (DIYFont)

+ (UIFont *)fitSystemFontOfSize:(CGFloat)size weight:(UIFontWeight)weight;

+ (UIFont *)fitSystemFontOfSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
