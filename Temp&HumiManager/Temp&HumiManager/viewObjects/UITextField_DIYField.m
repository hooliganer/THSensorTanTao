//
//  UITextField_DIYField.m
//  Hoologaner
//
//  Created by terry on 2018/3/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "UITextField_DIYField.h"


@implementation UITextField_DIYField


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    switch (self.style) {
        case TextFieldStyle_BottomLine:
            [self drawBtmLineStyle];
            break;
        case TextFieldStyle_BorderLine:
            [self drawBorderLineStyle];
            break;

        default:
            break;
    }
}

#pragma mark - lazy load
- (UIColor *)tintsColor{
    if (_tintsColor == nil) {
        _tintsColor = [UIColor redColor];
    }
    return _tintsColor;
}

#pragma mark - set method

#pragma mark - inside method

/*=== Style ===*/
- (void)drawBtmLineStyle{

    CGFloat LineWidth = Fit_Y(2.f);

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = LineWidth;
    [self.tintsColor set];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - LineWidth/2.f)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - LineWidth/2.f)];
    [path stroke];
    [path closePath];
}

- (void)drawBorderLineStyle{

    CGFloat LineWidth = Fit_Y(2.f);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(LineWidth/2.f, LineWidth/2.f, self.frame.size.width - LineWidth, self.frame.size.height - LineWidth) cornerRadius:Fit_Y(5.f)];
    path.lineWidth = LineWidth;
    [self.tintsColor set];
    [path stroke];
    [path closePath];
}



@end
