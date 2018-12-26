//
//  DetailCellView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailCellView.h"

@interface DetailCellView ()

@property (nonatomic,strong)UILabel *labAlert;
@property (nonatomic,strong)UILabel *labWarnTemp;
@property (nonatomic,strong)UILabel *labWarnHumi;


@end

@implementation DetailCellView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 8;
        self.imvHead.image = [UIImage imageNamed:@"warning"];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.imvHead.height = (self.height - 30)*0.7;
    self.imvHead.width = (self.imvHead.image.size.width/self.imvHead.image.size.height)*self.imvHead.height;
    self.imvHead.origin = CGPointMake(10, 10);

    self.imvWarning.origin = CGPointMake(10, self.imvHead.y + self.imvHead.height + 10);
    self.imvWarning.height = (self.height - 30)*0.3;
    self.imvWarning.width = (self.imvWarning.image.size.width/self.imvWarning.image.size.height)*self.imvWarning.height;

    self.labTitle.frame = CGRectMake(self.imvHead.rightX + 10, 10, 150, (self.imvHead.height - 10)/2.0);

    if (self.isWifi) {
        CGFloat h = (self.imvHead.height - 10)/2.0;
        CGFloat w = (self.imvInternet.image.size.width/self.imvInternet.image.size.height)*h;
        self.imvInternet.frame = CGRectMake(self.imvHead.rightX + 10, self.labTitle.bottomY + 10, w, h);
    } else{
        self.imvInternet.frame = CGRectMake(self.imvHead.rightX + 10, self.labTitle.bottomY + 10, 0, 0);
    }

    if (self.isBle) {
        CGFloat h = (self.imvHead.height - 10)/2.0;
        CGFloat w = (self.imvBluetooth.image.size.width/self.imvBluetooth.image.size.height)*h;
        CGFloat x = self.isWifi ? (self.imvInternet.rightX + 10) : (self.imvHead.rightX + 10);
        self.imvBluetooth.frame = CGRectMake(x, self.labTitle.bottomY + 10, w, h);
    } else{
        CGFloat x = self.isWifi ? (self.imvInternet.rightX + 10) : (self.imvHead.rightX + 10);
        self.imvBluetooth.frame = CGRectMake(x, self.labTitle.bottomY + 10, 0, 0);
    }

    CGFloat h_Bt = (self.imvHead.height - 10)/2.0;
    CGFloat w_Bt = (self.imvBattery.image.size.width/self.imvBattery.image.size.height)*h_Bt;
    self.imvBattery.frame = CGRectMake(self.imvBluetooth.rightX + 10, self.labTitle.bottomY + 10, w_Bt, h_Bt);
    
    self.labPower.x = self.imvBattery.rightX + 10;
    self.labPower.cy = self.imvBattery.cy;

    self.labTempar.center = CGPointMake(self.width - 10 - self.labTempar.width/2.0, self.labTitle.center.y);

    CGFloat htemp = (self.imvHead.height - 10)/2.0;
    CGFloat wtemp = (self.imvTempar.image.size.width/self.imvTempar.image.size.height)*htemp;
    self.imvTempar.frame = CGRectMake(self.labPower.rightX + 80, 10, wtemp, htemp);

    self.labHumi.center = CGPointMake(self.labTempar.cx, self.imvInternet.cy);
    
    CGFloat hhumi = (self.imvHead.height - 10)/2.0;
    CGFloat whumi = (self.imvHumi.image.size.width/self.imvHumi.image.size.height)*hhumi;
    self.imvHumi.frame = CGRectMake(self.imvTempar.x, self.imvTempar.bottomY + 10, whumi, hhumi);

    self.labAlert.x = self.imvWarning.rightX + 10;
    self.labAlert.y = self.imvWarning.y;

    CGFloat hB = self.labAlert.height;
    CGFloat wB = (self.imvTemparB.image.size.width/self.imvTemparB.image.size.height)*hB;
    self.imvTemparB.frame = CGRectMake(self.labAlert.rightX + 10, self.labAlert.y, wB, hB);

    self.labWarnTemp.center = CGPointMake(self.imvTemparB.rightX + 10 + self.labWarnTemp.width/2.0, self.imvTemparB.center.y);

    CGFloat hH = self.labAlert.height;
    CGFloat wH = (self.imvHumiB.image.size.width/self.imvHumiB.image.size.height)*hH;
    self.imvHumiB.frame = CGRectMake(self.labWarnTemp.x + 10, self.labAlert.y, wH, hH);

    self.labWarnHumi.center = CGPointMake(self.imvHumiB.rightX + 10 + self.labWarnHumi.width/2.0, self.imvTemparB.center.y);

//    return ;

//    CGFloat distance = Fit_Y(10.f);
//    CGFloat w1 = (self.frame.size.width - distance*4.f)*0.17;
//    CGFloat w2 = (self.frame.size.width - distance*4.f)*0.6;

//    if (self.imvHead.image) {
//        CGFloat h = (self.imvHead.image.size.height/self.imvHead.image.size.width)*w1;
//
//    }
//
//    self.labTitle.frame = CGRectMake(distance*2.f + w1, distance, w2, _labTitle.bounds.size.height);
//
//    if (_isWifi) {
//        CGFloat h = Fit_Y(20.f);
//        CGFloat w = (self.imvInternet.image.size.width/self.imvInternet.image.size.height)*h;
//        self.imvInternet.frame = CGRectMake(_imvHead.frame.origin.x + _imvHead.frame.size.width +distance, _imvHead.frame.origin.y + _imvHead.frame.size.height - h, w, h);
//    } else{
//        self.imvInternet.frame = CGRectZero;
//    }
//
//    if (_isBle) {
//        CGFloat h = Fit_Y(20.f);
//        CGFloat w = (self.imvBluetooth.image.size.width/self.imvBluetooth.image.size.height)*h;
//
//        self.imvBluetooth.frame = CGRectMake(_imvHead.frame.origin.x + _imvHead.frame.size.width + distance + _imvInternet.frame.size.width + distance, _imvHead.frame.origin.y + _imvHead.frame.size.height - h, w, h);
//    } else{
//        self.imvBluetooth.frame = CGRectZero;
//    }
//
//    CGFloat hBt = Fit_Y(20.f);
//    CGFloat wBt = (self.imvBattery.image.size.width/self.imvBattery.image.size.height)*hBt;
//    self.imvBattery.frame = CGRectMake(_imvHead.frame.origin.x + _imvHead.frame.size.width + _imvInternet.frame.size.width + _imvBluetooth.frame.size.width + distance*3.f, _imvHead.frame.origin.y + _imvHead.frame.size.height - hBt, wBt, hBt);

//    self.labPower.center = CGPointMake(_imvBattery.frame.origin.x + _imvBattery.frame.size.width + distance + _labPower.bounds.size.width/2.f, _imvBattery.center.y);

//    CGFloat htemp = Fit_Y(20.f);
//    CGFloat wtemp = (self.imvTempar.image.size.width/self.imvTempar.image.size.height)*htemp;
//    self.imvTempar.frame = CGRectMake(distance * 3.f + w1 + w2, _imvHead.frame.origin.y, wtemp, htemp);

//    CGFloat hhumi = Fit_Y(20.f);
//    CGFloat whumi = (self.imvHumi.image.size.width/self.imvHumi.image.size.height)*hhumi;
//    self.imvHumi.frame = CGRectMake(distance * 3.f + w1 + w2, _imvHead.frame.origin.y + _imvHead.frame.size.height - hhumi, whumi, hhumi);

//    self.labTempar.center = CGPointMake(_imvTempar.frame.origin.x + _imvTempar.frame.size.width + distance + _labTempar.bounds.size.width/2.f, _imvTempar.center.y);
//
//    self.labHumi.center = CGPointMake(_imvHumi.frame.origin.x + _imvHumi.frame.size.width + distance + _labHumi.bounds.size.width/2.f, _imvHumi.center.y);

//    CGFloat hWarn = self.frame.size.height - _imvHead.frame.origin.y - _imvHead.frame.size.height - distance;
//    CGFloat wWarn = (self.imvWarning.image.size.width/self.imvWarning.image.size.height) * hWarn;
//    self.imvWarning.frame = CGRectMake(distance, _imvHead.frame.origin.y + _imvHead.frame.size.height + distance/2.f, wWarn, hWarn);

//    self.labAlert.center = CGPointMake(_imvWarning.frame.origin.x + _imvWarning.frame.size.width + distance + _labAlert.bounds.size.width/2.f, _imvWarning.center.y);

//    CGFloat hB = Fit_Y(15.f);
//    CGFloat wB = (self.imvTemparB.image.size.width/self.imvTemparB.image.size.height)*hB;
//    self.imvTemparB.frame = CGRectMake(_labAlert.center.x + _labAlert.bounds.size.width/2.f + distance, _imvWarning.center.y - hB/2.f, wB, hB);
//
//    self.labWarnTemp.center = CGPointMake(_imvTemparB.frame.origin.x + _imvTemparB.frame.size.width + distance + _labWarnTemp.bounds.size.width/2.f, _imvTemparB.center.y);

//    CGFloat wB1 = (self.imvHumiB.image.size.width/self.imvHumiB.image.size.height)*hB;
//    self.imvHumiB.frame = CGRectMake(_labWarnTemp.center.x + _labWarnTemp.bounds.size.width/2.f + distance, _imvTemparB.frame.origin.y, wB1, hB);

//    self.labWarnHumi.center = CGPointMake(_imvHumiB.frame.origin.x + _imvHumiB.frame.size.width + distance + _labWarnHumi.bounds.size.width/2.f, _imvHumiB.center.y);


}


#pragma mark - lazy load
- (UIImageView *)imvHead{
    if (_imvHead == nil) {
        _imvHead = [[UIImageView alloc]init];
        [self addSubview:_imvHead];
    }
    return _imvHead;
}

- (UIImageView *)imvInternet{
    if (_imvInternet == nil) {
        _imvInternet = [[UIImageView alloc]init];
        _imvInternet.image = [UIImage imageNamed:@"ic_wifi"];
        [self addSubview:_imvInternet];
    }
    return _imvInternet;
}

- (UIImageView *)imvBluetooth{
    if (_imvBluetooth == nil) {
        _imvBluetooth = [[UIImageView alloc]init];
        _imvBluetooth.image = [UIImage imageNamed:@"ic_bluettoth"];
        [self addSubview:_imvBluetooth];
    }
    return _imvBluetooth;
}

- (UIImageView *)imvBattery{
    if (_imvBattery == nil) {
        _imvBattery = [[UIImageView alloc]init];
        _imvBattery.image = [UIImage imageNamed:@"ic_battery"];
        [self addSubview:_imvBattery];
    }
    return _imvBattery;
}

- (UIImageView *)imvTempar{
    if (_imvTempar == nil) {
        _imvTempar = [[UIImageView alloc]init];
        _imvTempar.image = [UIImage imageNamed:@"tempar"];
        [self addSubview:_imvTempar];
    }
    return _imvTempar;
}

- (UIImageView *)imvHumi{
    if (_imvHumi == nil) {
        _imvHumi = [[UIImageView alloc]init];
        _imvHumi.image = [UIImage imageNamed:@"humidity"];
        [self addSubview:_imvHumi];
    }
    return _imvHumi;
}

- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.font = [UIFont fitSystemFontOfSize:25.f];
        _labTitle.textColor = [UIColor blackColor];
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

- (UILabel *)labPower{
    if (_labPower == nil) {
        _labPower = [[UILabel alloc]init];
        _labPower.font = [UIFont fitSystemFontOfSize:10.f];
        _labPower.textColor = [UIColor blackColor];
        [self addSubview:_labPower];
    }
    return _labPower;
}

- (UILabel *)labTempar{
    if (_labTempar == nil) {
        _labTempar = [[UILabel alloc]init];
        _labTempar.font = [UIFont fitSystemFontOfSize:18.0];
        _labTempar.textColor = [UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1];
        [self addSubview:_labTempar];
    }
    return _labTempar;
}

- (UILabel *)labHumi{
    if (_labHumi == nil) {
        _labHumi = [[UILabel alloc]init];
        _labHumi.font = [UIFont fitSystemFontOfSize:18.0];
        _labHumi.textColor = [UIColor colorWithRed:0/255.0 green:19/255.0 blue:127/255.0 alpha:1];
        [self addSubview:_labHumi];
    }
    return _labHumi;
}


- (UIImageView *)imvTemparB{
    if (_imvTemparB == nil) {
        _imvTemparB = [[UIImageView alloc]init];
        _imvTemparB.image = [UIImage imageNamed:@"tempar_black"];
        [self addSubview:_imvTemparB];
    }
    return _imvTemparB;
}

- (UIImageView *)imvHumiB{
    if (_imvHumiB == nil) {
        _imvHumiB = [[UIImageView alloc]init];
        _imvHumiB.image = [UIImage imageNamed:@"humi_black"];
        [self addSubview:_imvHumiB];
    }
    return _imvHumiB;
}

- (UIImageView *)imvWarning{
    if (_imvWarning == nil) {
        _imvWarning = [[UIImageView alloc]init];
        _imvWarning.image = [UIImage imageNamed:@"warning"];
        [self addSubview:_imvWarning];
    }
    return _imvWarning;
}


- (UILabel *)labAlert{
    if (_labAlert == nil) {
        _labAlert = [[UILabel alloc]init];
        _labAlert.font = [UIFont fitSystemFontOfSize:20.f];
        _labAlert.textColor = [UIColor blackColor];
        _labAlert.text = @"Alert";
        [_labAlert sizeToFit];
        [self addSubview:_labAlert];
    }
    return _labAlert;
}

- (UILabel *)labWarnTemp{
    if (_labWarnTemp == nil) {
        _labWarnTemp = [[UILabel alloc]init];
        _labWarnTemp.font = [UIFont fitSystemFontOfSize:25.f];
        _labWarnTemp.textColor = [UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1];
        [self addSubview:_labWarnTemp];
    }
    return _labWarnTemp;
}

- (UILabel *)labWarnHumi{
    if (_labWarnHumi == nil) {
        _labWarnHumi = [[UILabel alloc]init];
        _labWarnHumi.font = [UIFont fitSystemFontOfSize:25.f];
        _labWarnHumi.textColor = [UIColor colorWithRed:0/255.0 green:19/255.0 blue:127/255.0 alpha:1];
        [self addSubview:_labWarnHumi];
    }
    return _labWarnHumi;
}



#pragma mark - set method
- (void)setType:(CellImvType)type{
    _type = type;
    switch (type) {
        case CellImvType_WC:
            self.imvHead.image = [UIImage imageNamed:@"ic_room_wc"];
            break;
        case CellImvType_Car:
            self.imvHead.image = [UIImage imageNamed:@"ic_room_car"];
            break;
        case CellImvType_Bar:
            self.imvHead.image = [UIImage imageNamed:@"ic_room_bar"];
            break;
        case CellImvType_Baby:
            self.imvHead.image = [UIImage imageNamed:@"ic_room_baby"];
            break;

        default:
            self.imvHead.image = [UIImage imageNamed:@"ic_room_car"];
            break;
    }

}


- (void)setIsBle:(bool)isBle{
    _isBle = isBle;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIsWifi:(bool)isWifi{
    _isWifi = isWifi;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



- (void)setTempWarning:(bool)tempWarning{
    _tempWarning = tempWarning;

    self.labTempar.textColor = tempWarning?[UIColor whiteColor]:[UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1];
    self.imvTempar.image = tempWarning?[UIImage imageNamed:@"tempar_white"]:[UIImage imageNamed:@"tempar"];
    [self setNeedsDisplay];
}

- (void)setHumiWarning:(bool)humiWarning{
    _humiWarning = humiWarning;
    self.labHumi.textColor = humiWarning?[UIColor whiteColor]:[UIColor colorWithRed:0/255.0 green:19/255.0 blue:127/255.0 alpha:1];
    self.imvHumi.image = humiWarning?[UIImage imageNamed:@"humi_white"]:[UIImage imageNamed:@"humidity"];
    [self setNeedsDisplay];
}



@end
