//
//  DetailTempView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/15.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailTempView.h"



@implementation DetailTempView


- (void)layoutSubviews{
    [super layoutSubviews];

    self.tempInfoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.3);
    self.tempInfoView.layer.cornerRadius = Fit_Y(8.0);

    self.lineView.frame = CGRectMake(0, _tempInfoView.frame.origin.y + _tempInfoView.frame.size.height, self.frame.size.width, self.frame.size.height*0.7);
}

- (DetailHistoryInfoView *)tempInfoView{
    if (_tempInfoView == nil) {
        _tempInfoView = [[DetailHistoryInfoView alloc]init];
        _tempInfoView.layer.masksToBounds = true;
        _tempInfoView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [self addSubview:_tempInfoView];
    }
    return _tempInfoView;
}

- (MyLineView *)lineView{
    if (_lineView == nil) {
        _lineView = [[MyLineView alloc]init];
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.yCount = 5;
        _lineView.xCount = 6;
        _lineView.lineColor = MainColor;
        _lineView.lineWidth = Fit_Y(2.0);
        _lineView.lineType = MyLineType_Curveline;
        _lineView.btmHeight = Fit_Y(20.0);
        _lineView.topHeight = Fit_Y(20.0);
        _lineView.leftWidth = Fit_X(50.0);
        _lineView.rightWidth = Fit_X(30.0);
        _lineView.xyFont = [UIFont fitSystemFontOfSize:14.0];
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
