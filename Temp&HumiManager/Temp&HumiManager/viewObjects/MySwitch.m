//
//  MySwitch.m
//  TestSwift
//
//  Created by terry on 2018/3/20.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MySwitch.h"

@interface MySwitch ()

@end

@implementation MySwitch

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.offColor;
        self.layer.masksToBounds = true;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = self.offColor;
        self.layer.masksToBounds = true;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.layer.cornerRadius = self.frame.size.height/2.0;

    CGFloat hThumb = self.frame.size.height*0.8;
    if (self.thumb.image) {

    } else{
        self.thumb.frame = CGRectMake((self.frame.size.height - hThumb)/2.0, (self.frame.size.height - hThumb)/2.0, hThumb, hThumb);
        self.thumb.layer.cornerRadius = _thumb.frame.size.height/2.0;

        CGFloat distance = (self.frame.size.height - self.thumb.frame.size.height)/2.0;
        self.thumb.center = CGPointMake(_isOn?(self.frame.size.width - _thumb.frame.size.width/2.0 - distance):(_thumb.frame.size.width/2.0 + distance), _thumb.center.y);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.alpha = 0.7;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];

    self.alpha = 1;

    self.isOn = !_isOn;
}


- (UIImageView *)thumb{
    if (_thumb == nil) {
        _thumb = [[UIImageView alloc]init];
        _thumb.layer.masksToBounds = true;
        [self addSubview:_thumb];
    }
    return _thumb;
}

- (UIColor *)onColor{
    if (_onColor == nil) {
        _onColor = [UIColor greenColor];
    }
    return _onColor;
}

- (UIColor *)offColor{
    if (_offColor == nil) {
        _offColor = [UIColor lightGrayColor];
    }
    return _offColor;
}



- (void)setIsOn:(bool)isOn{
    if (_isOn == isOn) {
        return ;
    }
    _isOn = isOn;

    CGFloat distance = (self.frame.size.height - self.thumb.frame.size.height)/2.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.thumb.center = CGPointMake(isOn?(self.frame.size.width - self.thumb.frame.size.width/2.0 - distance):(self.thumb.frame.size.width/2.0 + distance), self.thumb.center.y);
        self.backgroundColor = isOn?self.onColor:self.offColor;

    }];
}
@end
