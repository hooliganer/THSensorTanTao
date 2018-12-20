//
//  MyIndicatorView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyIndicatorView.h"

@interface MyIndicatorView ()

@property (nonatomic,strong)UIActivityIndicatorView *indicator;
@property (nonatomic,strong)UIVisualEffectView *effectView;

@end

@implementation MyIndicatorView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGFloat distance = Fit_X(5.0);
    CGFloat w = self.labText.bounds.size.width + distance*2.0;
    w = w<Fit_X(100.0)?Fit_X(100.0):w;
    CGFloat h = self.labText.center.y + self.labText.bounds.size.height/2.0 + distance - self.indicator.center.y + 37 + distance;
//    h = h<Fit_X(100.0)?Fit_X(100.0):h;
    CGFloat x = self.frame.size.width/2.0 - w/2.0;
    CGFloat y = self.frame.size.height/2.0 - h/2.0;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:Fit_Y(10.0)];
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] setFill];
    [path fill];

    self.effectView.frame = CGRectMake(x, y, w, h);
    self.effectView.layer.cornerRadius = Fit_Y(10.0);

}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = Fit_X(5.0);

    self.indicator.transform = CGAffineTransformMakeScale(1, 1);
    UIView *indiView = [_indicator.subviews firstObject];
    CGSize indiSize = indiView.frame.size;

    self.labText.center = CGPointMake(self.indicator.center.x, self.indicator.center.y + indiSize.height/2.0 + _labText.bounds.size.height/2.0 + distance);
}

- (UIVisualEffectView *)effectView{
    if (_effectView == nil) {
        if (@available(iOS 10.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        }
        _effectView.layer.masksToBounds = true;
        [self insertSubview:_effectView atIndex:0];
    }
    return _effectView;
}

- (UIActivityIndicatorView *)indicator{
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc]init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicator.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        [self addSubview:_indicator];
    }
    return _indicator;
}

- (UILabel *)labText{
    if (_labText == nil) {
        _labText = [[UILabel alloc]init];
        _labText.textColor = [UIColor whiteColor];
        [self addSubview:_labText];
    }
    return _labText;
}

- (void)show{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self.indicator startAnimating];
}

- (void)showBlock:(void (^)(MyIndicatorView *))block{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self.indicator startAnimating];
    if (block) {
        block(self);
    }
}

- (void)dismiss{
    [self.indicator stopAnimating];
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    [self dismiss];
}

@end
