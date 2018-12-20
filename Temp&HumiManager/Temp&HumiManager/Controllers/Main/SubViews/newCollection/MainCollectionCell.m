//
//  MainCollectionCell.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainCollectionCell.h"

@interface MainCollectionCell ()

@property (nonatomic,strong)UIImageView *imvHead;
@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,strong)UIImageView *imvInternet;
@property (nonatomic,strong)UIImageView *imvBluetooth;
@property (nonatomic,strong)UIImageView *imvBattery;
@property (nonatomic,strong)UIImageView *imvTempar;
@property (nonatomic,strong)UIImageView *imvHumi;
@property (nonatomic,strong)UILabel *labPower;
@property (nonatomic,strong)UILabel *labTempar;
@property (nonatomic,strong)UILabel *labHumi;

@end

@implementation MainCollectionCell

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGFloat distance = Fit_Y(5.0);
    CGFloat width = self.frame.size.width * 0.2 - distance;
    CGFloat x = self.frame.size.width * 0.8 - distance*2.0;

    if (_tempWarning) {

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, _imvTempar.frame.origin.y - distance, width, _imvTempar.frame.size.height + distance*2.f) cornerRadius:Fit_Y(5.f)];
        [[UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1] setFill];
        [path fill];
        [path closePath];
    }

    if (_humiWarning) {

        CGFloat distance = Fit_Y(5.f);

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, _imvHumi.frame.origin.y - distance, width, _imvHumi.frame.size.height + distance*2.f) cornerRadius:Fit_Y(5.f)];
        [[UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1] setFill];
        [path fill];
        [path closePath];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = Fit_Y(10.f);
    CGFloat w1 = (self.frame.size.width - distance*4.f)*0.2;
    CGFloat w2 = (self.frame.size.width - distance*4.f)*0.6;

    if (self.imvHead.image) {
        CGFloat h = (self.imvHead.image.size.height/self.imvHead.image.size.width)*w1;
        self.imvHead.frame = CGRectMake(distance, distance, w1, h);
    }

    self.labTitle.frame = CGRectMake(distance*2.f + w1, distance, w2, _labTitle.bounds.size.height);

    if (_isWifi) {
        CGFloat h = Fit_Y(20.f);
        CGFloat w = (self.imvInternet.image.size.width/self.imvInternet.image.size.height)*h;
        self.imvInternet.frame = CGRectMake(_imvHead.frame.origin.x + _imvHead.frame.size.width +distance, self.frame.size.height - distance - h - Height_BtnLink, w, h);
    } else{
        self.imvInternet.frame = CGRectZero;
    }

    if (_isBle) {
        CGFloat h = Fit_Y(20.f);
        CGFloat w = (self.imvBluetooth.image.size.width/self.imvBluetooth.image.size.height)*h;

        self.imvBluetooth.frame = CGRectMake(_imvHead.frame.origin.x + _imvHead.frame.size.width + distance + _imvInternet.frame.size.width + distance, self.frame.size.height - distance - h - Height_BtnLink, w, h);
    } else{
        self.imvBluetooth.frame = CGRectZero;
    }

    CGFloat hBt = Fit_Y(20.f);
    CGFloat wBt = (self.imvBattery.image.size.width/self.imvBattery.image.size.height)*hBt;
    self.imvBattery.frame = CGRectMake(_imvHead.frame.origin.x + _imvHead.frame.size.width + _imvInternet.frame.size.width + _imvBluetooth.frame.size.width + distance*3.f, self.frame.size.height - distance - hBt - Height_BtnLink, wBt, hBt);

    self.labPower.center = CGPointMake(_imvBattery.frame.origin.x + _imvBattery.frame.size.width + distance + _labPower.bounds.size.width/2.f, _imvBattery.center.y);

    CGFloat htemp = Fit_Y(20.f);
    CGFloat wtemp = (self.imvTempar.image.size.width/self.imvTempar.image.size.height)*htemp;
    self.imvTempar.frame = CGRectMake(distance * 2.5 + w1 + w2, (self.frame.size.height - Height_BtnLink)/4.f - htemp/2.f, wtemp, htemp);

    CGFloat hhumi = Fit_Y(20.f);
    CGFloat whumi = (self.imvHumi.image.size.width/self.imvHumi.image.size.height)*hhumi;
    self.imvHumi.frame = CGRectMake(_imvTempar.frame.origin.x, (self.frame.size.height - Height_BtnLink)*0.75 - hhumi/2.f, whumi, hhumi);

    self.labTempar.center = CGPointMake(_imvTempar.frame.origin.x + _imvTempar.frame.size.width + distance/2.0 + _labTempar.bounds.size.width/2.f, _imvTempar.center.y);

    self.labHumi.center = CGPointMake(_imvHumi.frame.origin.x + _imvHumi.frame.size.width + distance/2.0 + _labHumi.bounds.size.width/2.f, _imvHumi.center.y);

    if (self.isLink) {
        self.btnLink.frame = CGRectMake(0, self.frame.size.height - Height_BtnLink, self.frame.size.width, Height_BtnLink);
    } else {
        self.btnLink.frame = CGRectZero;
    }
}

#pragma mark - lazy load
- (UIButton_DIYObject *)btnLink{
    if (_btnLink == nil) {
        _btnLink = [UIButton_DIYObject buttonWithType:UIButtonTypeCustom];
        _btnLink.title = @"Link";
        _btnLink.labTitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_btnLink];
    }
    return _btnLink;
}

- (UIImageView *)imvHead{
    if (_imvHead == nil) {
        _imvHead = [[UIImageView alloc]init];
        [self.contentView addSubview:_imvHead];
    }
    return _imvHead;
}

- (UIImageView *)imvInternet{
    if (_imvInternet == nil) {
        _imvInternet = [[UIImageView alloc]init];
        _imvInternet.image = [UIImage imageNamed:@"ic_wifi"];
        [self.contentView addSubview:_imvInternet];
    }
    return _imvInternet;
}

- (UIImageView *)imvBluetooth{
    if (_imvBluetooth == nil) {
        _imvBluetooth = [[UIImageView alloc]init];
        _imvBluetooth.image = [UIImage imageNamed:@"ic_bluettoth"];
        [self.contentView addSubview:_imvBluetooth];
    }
    return _imvBluetooth;
}

- (UIImageView *)imvBattery{
    if (_imvBattery == nil) {
        _imvBattery = [[UIImageView alloc]init];
        _imvBattery.image = [UIImage imageNamed:@"ic_battery"];
        [self.contentView addSubview:_imvBattery];
    }
    return _imvBattery;
}

- (UIImageView *)imvTempar{
    if (_imvTempar == nil) {
        _imvTempar = [[UIImageView alloc]init];
        _imvTempar.image = [UIImage imageNamed:@"tempar"];
        [self.contentView addSubview:_imvTempar];
    }
    return _imvTempar;
}

- (UIImageView *)imvHumi{
    if (_imvHumi == nil) {
        _imvHumi = [[UIImageView alloc]init];
        _imvHumi.image = [UIImage imageNamed:@"humidity"];
        [self.contentView addSubview:_imvHumi];
    }
    return _imvHumi;
}

- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.font = [UIFont fitSystemFontOfSize:25.f];
        _labTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_labTitle];
    }
    return _labTitle;
}

- (UILabel *)labPower{
    if (_labPower == nil) {
        _labPower = [[UILabel alloc]init];
        _labPower.font = [UIFont fitSystemFontOfSize:10.f];
        _labPower.textColor = [UIColor blackColor];
        [self.contentView addSubview:_labPower];
    }
    return _labPower;
}

- (UILabel *)labTempar{
    if (_labTempar == nil) {
        _labTempar = [[UILabel alloc]init];
        _labTempar.font = [UIFont fitSystemFontOfSize:16];
        _labTempar.textColor = [UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1];
        [self.contentView addSubview:_labTempar];
    }
    return _labTempar;
}

- (UILabel *)labHumi{
    if (_labHumi == nil) {
        _labHumi = [[UILabel alloc]init];
        _labHumi.font = [UIFont fitSystemFontOfSize:16];
        _labHumi.textColor = [UIColor colorWithRed:0/255.0 green:19/255.0 blue:127/255.0 alpha:1];
        [self.contentView addSubview:_labHumi];
    }
    return _labHumi;
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
//            NSLog(@"unkown CellImvType : %d",type);
            self.imvHead.image = [UIImage imageNamed:@"ic_room_car"];
            break;
    }
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.labTitle.text = title;
    [self.labTitle sizeToFit];
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

- (void)setIsLink:(bool)isLink{
    _isLink = isLink;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setPower:(NSString *)power{
    _power = power;
    self.labPower.text = power;
    [self.labPower sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTemparature:(NSString *)temparature{
    _temparature = temparature;
    self.labTempar.text = temparature;
    [self.labTempar sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setHumidity:(NSString *)humidity{
    _humidity = humidity;
    self.labHumi.text = humidity;
    [self.labHumi sizeToFit];
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
