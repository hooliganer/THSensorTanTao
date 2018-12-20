//
//  TH_LableImvView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/24.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "TH_LableImvView.h"

@implementation TH_LableImvView

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat disX = self.frame.size.width * 0.05;
    CGFloat h_imv = self.frame.size.height*0.65;

    CGFloat w_imv = 0;
    if (self.imv1.image) {
        w_imv = (self.imv1.image.size.width/self.imv1.image.size.height) * h_imv;
    }
    self.imv1.frame = CGRectMake(0, self.frame.size.height/2.0 - h_imv/2.0, w_imv, h_imv);

    self.lab1.center = CGPointMake(self.imv1.frame.origin.x + self.imv1.frame.size.width + disX + self.lab1.bounds.size.width/2.0, self.frame.size.height/2.0);

    if (self.imv2.image) {
        h_imv *= 0.7;
        w_imv = (self.imv2.image.size.width/self.imv2.image.size.height) * h_imv;
    }
    self.imv2.frame = CGRectMake(self.frame.size.width*0.7, self.frame.size.height/2.0 - h_imv/2.0, w_imv, h_imv);

    self.lab2.center = CGPointMake(self.frame.size.width - self.lab2.bounds.size.width/2.0, self.frame.size.height/2.0);

}

- (UIImageView *)imv1{
    if (_imv1 == nil) {
        _imv1 = [[UIImageView alloc]init];
        [self addSubview:_imv1];
    }
    return _imv1;
}

- (UIImageView *)imv2{
    if (_imv2 == nil) {
        _imv2 = [[UIImageView alloc]init];
        [self addSubview:_imv2];
    }
    return _imv2;
}

- (UILabel *)lab1{
    if (_lab1 == nil) {
        _lab1 = [[UILabel alloc]init];
        _lab1.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_lab1];
    }
    return _lab1;
}

- (UILabel *)lab2{
    if (_lab2 == nil) {
        _lab2 = [[UILabel alloc]init];
        _lab1.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_lab2];
    }
    return _lab2;
}


@end
