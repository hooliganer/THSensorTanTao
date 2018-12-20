//
//  UIButton+DIYButton.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/15.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "UIButton+DIYButton.h"


@implementation UIButton (DIYButton)


- (void)setOriginalScale:(CGFloat)scale{
    if (scale > 0) {
        for (UIView *sview in self.subviews) {
            if (sview.tag == 0 && [sview isKindOfClass:[UIImageView class]]) {
                CGFloat newW = sview.frame.size.width * scale;
                CGFloat newH = sview.frame.size.height * scale;
                CGFloat newX = self.frame.size.width/2.0 - newW/2.0;
                CGFloat newY = self.frame.size.height/2.0 - newH/2.0;
                sview.frame = CGRectMake(newX, newY, newW, newH);
            }
        }
    }
}

@end
