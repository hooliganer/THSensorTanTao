//
//  SettingGroupChooseView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingGroupChooseView.h"

@implementation SettingGroupChooseView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGFloat lineWidth = Fit_X(2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineWidth/2.0, lineWidth/2.0, self.frame.size.width - lineWidth, self.frame.size.height - lineWidth) cornerRadius:Fit_Y(5.0)];
    path.lineWidth = lineWidth;
    [[UIColor lightGrayColor] setStroke];
    [path stroke];

    [path moveToPoint:CGPointMake(self.frame.size.width * 0.875, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.875, self.frame.size.height)];
    [path stroke];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.labText.center = CGPointMake(self.labText.bounds.size.width/2.0, self.frame.size.height/2.0);

    if (self.rightBtn) {
        CGFloat w = self.frame.size.width * 0.125;
        self.rightBtn.frame = CGRectMake(self.frame.size.width - w, 0, w, self.frame.size.height);
    }

}

- (UILabel *)labText{
    if (_labText == nil) {
        _labText = [[UILabel alloc]init];
        _labText.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_labText];
    }
    return _labText;
}

- (UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc]init];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

- (SettingGroupAlert *)alertTable{
    if (_alertTable == nil) {
        _alertTable = [[SettingGroupAlert alloc]initWithFrame:CGRectMake(0, 0, Fit_X(200.0), Fit_Y(300.0))];
        _alertTable.backgroundColor = [UIColor whiteColor];
    }
    return _alertTable;
}




@end
