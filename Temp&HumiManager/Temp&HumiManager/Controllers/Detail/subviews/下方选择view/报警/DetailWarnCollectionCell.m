//
//  DetailWarnCollectionCell.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/19.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailWarnCollectionCell.h"

@implementation DetailWarnCollectionCell

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = self.frame.size.height/4.0;
    CGFloat hHead = self.frame.size.height/2.0;
    self.headLab.frame = CGRectMake(distance, self.frame.size.height/2.0 - hHead/2.0, hHead, hHead);
    self.headLab.layer.cornerRadius = hHead/2.0;

    CGFloat hTp = hHead;
    CGFloat wTp = (self.imvTemp.image.size.width/self.imvTemp.image.size.height)*hTp;
    self.imvTemp.frame = CGRectMake(_headLab.frame.origin.x + _headLab.frame.size.width + distance/2.0, self.frame.size.height/2.0 - hTp/2.0, wTp, hTp);

    self.tempLab.center = CGPointMake(_imvTemp.frame.origin.x + _imvTemp.frame.size.width + distance/2.0 + _tempLab.bounds.size.width/2.0, self.frame.size.height/2.0);

    CGFloat hHm = hTp;
    CGFloat wHm = (self.imvHumi.image.size.width/self.imvHumi.image.size.height)*hHm;
    self.imvHumi.frame = CGRectMake(_tempLab.frame.origin.x + _tempLab.frame.size.width + distance/2.0, self.frame.size.height/2.0 - hTp/2.0, wHm, hHm);

    self.humiLab.center = CGPointMake(_imvHumi.frame.origin.x + _imvHumi.frame.size.width + distance/2.0 + _humiLab.bounds.size.width/2.0, self.frame.size.height/2.0);

    self.dateLab.center = CGPointMake(self.frame.size.width - distance - _dateLab.bounds.size.width/2.0, self.frame.size.height/2.0);
}

- (UILabel *)headLab{
    if (_headLab == nil) {
        _headLab = [[UILabel alloc]init];
        _headLab.layer.masksToBounds = true;
        _headLab.backgroundColor = [UIColor colorWithRed:248/255.0 green:228/255.0 blue:55/255.0 alpha:1];
        _headLab.textAlignment = NSTextAlignmentCenter;
        _headLab.font = [UIFont fitSystemFontOfSize:16.0];
        [self.contentView addSubview:_headLab];
    }
    return _headLab;
}

- (UIImageView *)imvTemp{
    if (_imvTemp == nil) {
        _imvTemp = [[UIImageView alloc]init];
        _imvTemp.image = [UIImage imageNamed:@"tempar_black"];
        [self.contentView addSubview:_imvTemp];
    }
    return _imvTemp;
}

- (UIImageView *)imvHumi{
    if (_imvHumi == nil) {
        _imvHumi = [[UIImageView alloc]init];
        _imvHumi.image = [UIImage imageNamed:@"humi_black"];
        [self.contentView addSubview:_imvHumi];
    }
    return _imvHumi;
}

- (UILabel *)tempLab{
    if (_tempLab == nil) {
        _tempLab = [[UILabel alloc]init];
        _tempLab.font = [UIFont fitSystemFontOfSize:16.0];
        [self.contentView addSubview:_tempLab];
    }
    return _tempLab;
}

- (UILabel *)humiLab{
    if (_humiLab == nil) {
        _humiLab = [[UILabel alloc]init];
        _humiLab.font = [UIFont fitSystemFontOfSize:16.0];
        [self.contentView addSubview:_humiLab];
    }
    return _humiLab;
}

- (UILabel *)dateLab{
    if (_dateLab == nil) {
        _dateLab = [[UILabel alloc]init];
        _dateLab.font = [UIFont fitSystemFontOfSize:16.0];
        [self.contentView addSubview:_dateLab];
    }
    return _dateLab;
}


@end
