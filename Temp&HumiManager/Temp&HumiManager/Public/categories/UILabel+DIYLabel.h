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

- (void)fitWidth:(CGFloat)width;

- (instancetype)initWithText:(NSString *)text;

@end
