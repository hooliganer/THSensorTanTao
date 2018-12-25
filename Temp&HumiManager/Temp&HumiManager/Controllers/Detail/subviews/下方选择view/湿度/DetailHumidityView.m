//
//  DetailHumidityView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailHumidityView.h"

@implementation DetailHumidityView

- (void)layoutSubviews{
    [super layoutSubviews];

    self.humiInfoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.3);
    self.humiInfoView.layer.cornerRadius = Fit_Y(8.0);

//    self.lineView.frame = CGRectMake(0, _humiInfoView.frame.origin.y + _humiInfoView.frame.size.height, self.frame.size.width, self.frame.size.height*0.7);
    self.liner.frame = CGRectMake(0, _humiInfoView.frame.origin.y + _humiInfoView.frame.size.height + 5, self.frame.size.width, self.frame.size.height*0.7 - 10);
}


- (DetailHistoryInfoView *)humiInfoView{
    if (_humiInfoView == nil) {
        _humiInfoView = [[DetailHistoryInfoView alloc]init];
        _humiInfoView.layer.masksToBounds = true;
        _humiInfoView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [self addSubview:_humiInfoView];
    }
    return _humiInfoView;
}

//- (MyLineView *)lineView{
//    if (_lineView == nil) {
//        _lineView = [[MyLineView alloc]init];
//        _lineView.backgroundColor = [UIColor clearColor];
//        _lineView.yCount = 5;
//        _lineView.xCount = 6;
//        _lineView.lineColor = [UIColor redColor];
//        _lineView.lineWidth = Fit_Y(2.0);
//        _lineView.lineType = MyLineType_BeeCircleLine;
//        _lineView.btmHeight = Fit_Y(20.0);
//        _lineView.xyFont = [UIFont fitSystemFontOfSize:14.0];
//        [self addSubview:_lineView];
//        _lineView.topHeight = Fit_Y(20.0);
//        _lineView.leftWidth = Fit_X(50.0);
//        _lineView.rightWidth = Fit_X(30.0);
////        _lineView.values = @[@(2.0),@(10.25),@(1),@(7)];
////        _lineView.xValues = @[@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00"];
////        _lineView.xPers = @[@(0),@(0.2),@(0.7),@(1)];
//    }
//    return _lineView;
//}


- (THLineView *)liner{
    if (_liner == nil) {
        _liner = [[THLineView alloc]init];
        _liner.bgLineColor = [UIColor lightGrayColor];
        _liner.bgLineWidth = 1;
        _liner.lineWidth = 2;
        _liner.lineColor = [UIColor blueColor];
        _liner.type = THLineType_Beeline;
        [self addSubview:_liner];
    }
    return _liner;
}

@end
