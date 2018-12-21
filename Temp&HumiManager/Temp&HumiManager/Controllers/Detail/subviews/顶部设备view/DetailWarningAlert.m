//
//  DetailWarningAlert.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/25.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailWarningAlert.h"

@interface DetailWarningAlert ()

@end

@implementation DetailWarningAlert

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:6/255.0 green:42/255.0 blue:51/255.0 alpha:1];
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 8;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = self.frame.size.height/5.0;

    CGFloat hWarn = self.frame.size.height*0.6;
    CGFloat wWarn = (self.imvWarn.image.size.width/self.imvWarn.image.size.height)*hWarn;
    self.imvWarn.frame = CGRectMake(distance, self.frame.size.height/2.0 - hWarn/2.0, wWarn, hWarn);

    self.labTitle.frame = CGRectMake(_imvWarn.frame.origin.x + _imvWarn.frame.size.width + distance, 0, Fit_X(75), self.frame.size.height);

    CGFloat hHumi = self.frame.size.height*0.5;
    CGFloat wHumi = (self.imvHumi.image.size.width/self.imvHumi.image.size.height)*hHumi;
    self.imvHumi.frame = CGRectMake(_labTitle.frame.origin.x + _labTitle.frame.size.width + distance*8.0, self.frame.size.height/2.0 - hHumi/2.0, wHumi, hHumi);

    self.labHumi.x = _imvHumi.rightX + distance;
    self.labHumi.cy = self.height/2.0;

    CGFloat hTemp = self.frame.size.height*0.5;
    CGFloat wTemp = (self.imvTemp.image.size.width/self.imvTemp.image.size.height)*hTemp;
    self.imvTemp.frame = CGRectMake(_labHumi.frame.origin.x + _labHumi.frame.size.width + distance, self.frame.size.height/2.0 - hHumi/2.0, wTemp, hTemp);

    self.labTemp.x = self.imvTemp.rightX + distance;
    self.labTemp.cy = self.height/2.0;
}

- (UIImageView *)imvWarn{
    if (_imvWarn == nil) {
        _imvWarn = [[UIImageView alloc]init];
        _imvWarn.image = [UIImage imageNamed:@"warning"];
        [self addSubview:_imvWarn];
    }
    return _imvWarn;
}

- (UIImageView *)imvHumi{
    if (_imvHumi == nil) {
        _imvHumi = [[UIImageView alloc]init];
        _imvHumi.image = [UIImage imageNamed:@"humi_white"];
        [self addSubview:_imvHumi];
    }
    return _imvHumi;
}

- (UIImageView *)imvTemp{
    if (_imvTemp == nil) {
        _imvTemp = [[UIImageView alloc]init];
        _imvTemp.image = [UIImage imageNamed:@"tempar_white"];
        [self addSubview:_imvTemp];
    }
    return _imvTemp;
}

- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.textColor = [UIColor colorWithRed:254/255.0 green:228/255.0 blue:17/255.0 alpha:1];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.font = [UIFont fitSystemFontOfSize:26];
        _labTitle.text = @"Alerts";
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

- (UILabel *)labTemp{
    if (_labTemp == nil) {
        _labTemp = [[UILabel alloc]init];
        _labTemp.textColor = [UIColor whiteColor];
        _labTemp.font = [UIFont fitSystemFontOfSize:20];
        _labTemp.text = @"--F";
        [_labTemp sizeToFit];
        [self addSubview:_labTemp];
    }
    return _labTemp;
}

- (UILabel *)labHumi{
    if (_labHumi == nil) {
        _labHumi = [[UILabel alloc]init];
        _labHumi.textColor = [UIColor whiteColor];
        _labHumi.font = [UIFont fitSystemFontOfSize:20];
        _labHumi.text = @"--%";
        [_labHumi sizeToFit];
        [self addSubview:_labHumi];
    }
    return _labHumi;
}


@end
