//
//  MainTableViewCell.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell ()

@property (nonatomic,strong)UIImageView * imvLogo;
@property (nonatomic,strong)UIImageView * imvTemp;
@property (nonatomic,strong)UIImageView * imvHumi;
@property (nonatomic,strong)UIImageView * imvPower;
@property (nonatomic,strong)UIImageView * imvBle;
@property (nonatomic,strong)UIImageView * imvWifi;

@property (nonatomic,strong)UIView * bgView;

@property (nonatomic,strong)UIView * tpWarnView;
@property (nonatomic,strong)UIView * hmWarnView;

@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{

    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    self.bgView.layer.masksToBounds = true;

    self.btnLink = [[UIButton alloc]init];
    self.btnLink.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.btnLink];
    self.btnLink.backgroundColor = [UIColor blackColor];
    [self.btnLink setTitle:@"Link" forState:UIControlStateNormal];
    [self.btnLink setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.imvLogo = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imvLogo];

    self.imvBle = [[UIImageView alloc]init];
    self.imvBle.image = [UIImage imageNamed:@"ic_bluettoth"];
    [self.contentView addSubview:self.imvBle];

    self.imvWifi = [[UIImageView alloc]init];
    self.imvWifi.image = [UIImage imageNamed:@"ic_wifi"];
    [self.contentView addSubview:self.imvWifi];

    self.imvPower = [[UIImageView alloc]init];
    self.imvPower.image = [UIImage imageNamed:@"ic_battery"];
    [self.contentView addSubview:self.imvPower];

    self.imvTemp = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imvTemp];
    self.imvTemp.image = [UIImage imageNamed:@"tempar"];

    self.imvHumi = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imvHumi];
    self.imvHumi.image = [UIImage imageNamed:@"humidity"];

    self.labTitle = [[UILabel alloc]init];
    [self.contentView addSubview:self.labTitle];
    if (@available(iOS 8.2, *)) {
        self.labTitle.font = [UIFont fitSystemFontOfSize:20.0 weight:UIFontWeightMedium];
    } else {
        self.labTitle.font = [UIFont fitSystemFontOfSize:20.0];
    }

    self.labPower = [[UILabel alloc]init];
    [self.contentView addSubview:self.labPower];
    if (@available(iOS 8.2, *)) {
        self.labPower.font = [UIFont fitSystemFontOfSize:16.0 weight:UIFontWeightMedium];
    } else {
        self.labPower.font = [UIFont fitSystemFontOfSize:16.0];
    }

    self.labTemp = [[UILabel alloc]init];
    [self.contentView addSubview:self.labTemp];
    if (@available(iOS 8.2, *)) {
        self.labTemp.font = [UIFont fitSystemFontOfSize:16.0 weight:UIFontWeightMedium];
    } else {
        self.labTemp.font = [UIFont fitSystemFontOfSize:16.0];
    }

    self.labHumi = [[UILabel alloc]init];
    [self.contentView addSubview:self.labHumi];
    if (@available(iOS 8.2, *)) {
        self.labHumi.font = [UIFont fitSystemFontOfSize:16.0 weight:UIFontWeightMedium];
    } else {
        self.labHumi.font = [UIFont fitSystemFontOfSize:16.0];
    }

    self.tpWarnView = [[UIView alloc]init];
    self.tpWarnView.layer.masksToBounds = true;
    self.tpWarnView.layer.cornerRadius = Fit_Y(8.0);
    self.tpWarnView.backgroundColor = [UIColor redColor];
    [self.contentView insertSubview:self.tpWarnView belowSubview:self.imvTemp];

    self.hmWarnView = [[UIView alloc]init];
    self.hmWarnView.layer.masksToBounds = true;
    self.hmWarnView.layer.cornerRadius = Fit_Y(8.0);
    self.hmWarnView.backgroundColor = [UIColor redColor];
    [self.contentView insertSubview:self.hmWarnView belowSubview:self.imvHumi];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat hl = self.showLink?Fit_Y(25.0):0;
    CGFloat x0 = self.frame.size.width*1.0/20.0;
    CGFloat y0 = Fit_Y(10.0);
    CGFloat w0 = self.frame.size.width - x0*2.0;
    CGFloat h0 = self.frame.size.height - y0*2.0 - hl;

    self.bgView.frame = CGRectMake(x0, y0, w0, h0);

    UIBezierPath * maskPath;
    if (self.showLink) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(Fit_Y(8.0), Fit_Y(8.0))];
        self.btnLink.frame = CGRectMake(x0, y0+h0, w0, Fit_Y(25.0));
        UIBezierPath * mask1 = [UIBezierPath bezierPathWithRoundedRect:self.btnLink.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(Fit_Y(8.0), Fit_Y(8.0))];;
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.btnLink.bounds;
        maskLayer.path = mask1.CGPath;
        self.btnLink.layer.mask = maskLayer;

    } else {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(Fit_Y(8.0), Fit_Y(8.0))];
        self.btnLink.frame = CGRectZero;
    }
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;

    CGFloat disx = x0/2.0;
    CGFloat disy = y0;
    CGFloat w1 = (w0 - disx*6.0)*0.3;
    CGFloat w2 = (w0 - disx*6.0)*0.5;
//    CGFloat w3 = (w0 - disx*6.0)*0.2;

    CGFloat h1 = h0 - y0*2.0;

    if (self.logo) {
        CGFloat hh = (self.logo.size.height/self.logo.size.width)*w1;
        self.imvLogo.image = self.logo;
        self.imvLogo.frame = CGRectMake(disx+x0, y0 + h0/2.0 - hh/2.0, w1, hh);
    }else {
        self.imvLogo.frame = CGRectZero;
    }

    self.labTitle.frame = CGRectMake(x0+disx*2.0 + w1, y0+disy, w2, h1/2.0);

    if (self.isble) {
        UIImage * img3 = self.imvBle.image;
        CGFloat h3 = h1*0.5*0.5;
        CGFloat w3 = (img3.size.width/img3.size.height)*h3;
        CGFloat y3 = y0+h0*0.75-h3/2.0;
        self.imvBle.frame = CGRectMake(x0+disx*2.0 + w1, y3, w3, h3);
    } else{
        self.imvBle.frame = CGRectZero;
    }

    if (self.iswifi) {
        UIImage * img4 = self.imvWifi.image;
        CGFloat h4 = h1*0.5*0.5;
        CGFloat w4 = (img4.size.width/img4.size.height)*h4;
        CGFloat y4 = y0+h0*0.75-h4/2.0;
        self.imvWifi.frame = CGRectMake(x0+disx*2.5 + w1 + self.imvBle.frame.size.width, y4, w4, h4);
    } else{
        self.imvWifi.frame = CGRectZero;
    }

    UIImage * img5 = self.imvPower.image;
    CGFloat x5 = x0+w1+disx*3.0+self.imvBle.frame.size.width+self.imvWifi.frame.size.width;
    CGFloat h5 = h1*0.5*0.5;
    CGFloat w5 = (img5.size.width/img5.size.height)*h5;
    CGFloat y5 = y0+h0*0.75-h5/2.0;
    self.imvPower.frame = CGRectMake(x5, y5, w5, h5);

    CGFloat w6 = w2 - self.imvBle.frame.size.width - self.imvWifi.frame.size.width - w5 - disx*1.5;
    CGFloat h6 = h5;
    CGFloat x6 = self.imvPower.frame.origin.x + self.imvPower.frame.size.width+disx/2.0;
    CGFloat y6 = y0+h0*0.75-h6/2.0;
    self.labPower.frame = CGRectMake(x6, y6, w6, h6);

    UIImage * img7 = self.imvTemp.image;
    CGFloat h7 = h1/2.0*0.6;
    CGFloat w7 = (img7.size.width/img7.size.height)*h7;
    CGFloat x7 = x0+disx*2.0 + w1 + w2 + disx;
    CGFloat y7 = y0 + disy + h1*0.25 - h7/2.0;
    self.imvTemp.frame = CGRectMake(x7, y7, w7, h7);

    CGFloat x8 = x7 + w7 + disx;
    CGFloat w8 = self.frame.size.width - x7 - w7 - x0 - disx*2.0;
    CGFloat h8 = h1/2.0;
    CGFloat y8 = y0 + disy;
    self.labTemp.frame = CGRectMake(x8, y8, w8, h8);

    UIImage * img9 = self.imvHumi.image;
    CGFloat h9 = h1/2.0*0.6;
    CGFloat w9 = (img9.size.width/img9.size.height)*h9;
    CGFloat x9 = x0+disx*2.0 + w1 + w2 + disx;
    CGFloat y9 = y0 + disy + h1*0.75 - h7/2.0;
    self.imvHumi.frame = CGRectMake(x9, y9, w9, h9);

    CGFloat w10 = w8;
    CGFloat x10 = x8;
    CGFloat h10 = h1/2.0;
    CGFloat y10 = y0 + disy + h10;
    self.labHumi.frame = CGRectMake(x10, y10, w10, h10);

    if (self.tempWarning) {
        self.tpWarnView.frame = CGRectMake(self.imvTemp.frame.origin.x - Fit_X(5.0), self.imvTemp.frame.origin.y - Fit_Y(5.0), self.labTemp.frame.size.width + self.labTemp.frame.origin.x - self.imvTemp.frame.origin.x + Fit_X(10.0), self.labTemp.frame.size.height + self.labTemp.frame.origin.y - self.imvTemp.frame.origin.y);
        self.imvTemp.image = [UIImage imageNamed:@"tempar_white"];
        self.labTemp.textColor = [UIColor whiteColor];
    } else {
        self.tpWarnView.frame = CGRectZero;
        self.imvTemp.image = [UIImage imageNamed:@"tempar"];
        self.labTemp.textColor = [UIColor colorWithRed:234/255.0 green:0 blue:64/255.0 alpha:1];
    }

    if (self.humiWarning) {
        self.hmWarnView.frame = CGRectMake(self.imvHumi.frame.origin.x - Fit_X(5.0), self.imvHumi.frame.origin.y - Fit_Y(5.0), self.labHumi.frame.size.width + self.labHumi.frame.origin.x - self.imvHumi.frame.origin.x + Fit_X(10.0), self.labHumi.frame.size.height + self.labHumi.frame.origin.y - self.imvHumi.frame.origin.y);
        self.imvHumi.image = [UIImage imageNamed:@"humi_white"];
        self.labHumi.textColor = [UIColor whiteColor];
    } else {
        self.hmWarnView.frame = CGRectZero;
        self.imvHumi.image = [UIImage imageNamed:@"humidity"];
        self.labHumi.textColor = [UIColor colorWithRed:0/255.0 green:19/255.0 blue:127/255.0 alpha:1];
    }
}

@end
