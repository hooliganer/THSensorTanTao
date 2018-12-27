//
//  UILabel+DIYLabel.h
//  HomeKitSystem
//
//  Created by 谭滔 on 2017/12/11.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DIYLabel)


/**
 * 高度固定，字体自适应
 */
- (void)fitHeight:(CGFloat)height WithWeight:(CGFloat)weight;

/**
 宽度固定，高度自适应

 @param width 固定的宽度
 */
- (void)fitWidth:(CGFloat)width;

/**
 限制最大宽度，若超过此宽度，限制回此最大宽度，若小于此宽度，则为文字宽度

 @param width 最大宽度
 */
- (void)fitMaxWidth:(CGFloat)width;

- (instancetype)initWithText:(NSString *)text;

@end
