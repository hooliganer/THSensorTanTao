//
//  UIImage+DIYImage.h
//  Hoologaner
//
//  Created by terry on 2018/1/22.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DIYImage)

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
