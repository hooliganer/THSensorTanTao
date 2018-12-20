//
//  TH_NormalView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/6/22.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "TH_NormalView.h"

@implementation TH_NormalView

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, Fit_Y(50.0))];
//    [MainColor setFill];
//    [path fill];
//
//}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.labTitle.frame = CGRectMake(0, 0, self.frame.size.width, Fit_Y(50.0));
}

- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.textColor = [UIColor whiteColor];
        _labTitle.backgroundColor = MainColor;
        if (@available(iOS 8.2, *)) {
            _labTitle.font = [UIFont fitSystemFontOfSize:20.0 weight:UIFontWeightBold];
        } else {
            _labTitle.font = [UIFont fitSystemFontOfSize:20.0];
        }
        _labTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

@end
