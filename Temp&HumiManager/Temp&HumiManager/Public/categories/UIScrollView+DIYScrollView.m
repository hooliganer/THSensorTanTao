//
//  UIScrollView+DIYScrollView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "UIScrollView+DIYScrollView.h"

@implementation UIScrollView (DIYScrollView)

- (CGFloat)contentWidth{
    return self.contentSize.width;
}

- (void)setContentWidth:(CGFloat)contentWidth{
    self.contentSize = CGSizeMake(contentWidth, self.contentSize.height);
}

- (CGFloat)contentHeight{
    return self.contentSize.height;
}

- (void)setContentHeight:(CGFloat)contentHeight{
    self.contentSize = CGSizeMake(self.contentSize.width, contentHeight);
}

@end
