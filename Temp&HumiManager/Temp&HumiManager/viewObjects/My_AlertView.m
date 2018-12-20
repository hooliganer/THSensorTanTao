//
//  My_AlertView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/6/22.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "My_AlertView.h"

@implementation My_AlertView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.touchDismiss) {
        CGPoint p = [[touches anyObject] locationInView:self];
        if (!CGRectContainsPoint(self.centerView.frame, p)) {
            [self dismiss];
        }
    }
}



- (void)showBlock:(void (^)(My_AlertView *))block{

    if (self.centerView == nil) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    } else {

        [self addSubview:self.centerView];

        switch (self.animType) {
            case My_AlertAnimateType_Fade:
            {
                self.alpha = 0;
                self.centerView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
                [[[UIApplication sharedApplication] keyWindow] addSubview:self];
                [UIView animateWithDuration:0.35 animations:^{
                    self.alpha = 1;
                }];
            }
                break;
            case My_AlertAnimateType_FromRight:
            {
                self.centerView.center = CGPointMake(self.frame.size.width + self.centerView.frame.size.width/2.0, self.frame.size.height/2.0);
                [[[UIApplication sharedApplication] keyWindow] addSubview:self];
                [UIView animateWithDuration:0.35 animations:^{
                    self.centerView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
                }];
            }
                break;
            case My_AlertAnimateType_Larger:
            {
                CGSize finalSize = self.centerView.frame.size;
                self.centerView.frame = CGRectMake(self.frame.size.width/2.0, self.frame.size.height/2.0, 0, 0);
                [[[UIApplication sharedApplication] keyWindow] addSubview:self];
                [UIView animateWithDuration:0.15 animations:^{
                    self.centerView.frame = CGRectMake(self.frame.size.width/2.0 - finalSize.width/2.0, self.frame.size.height/2.0 - finalSize.height/2.0, finalSize.width, finalSize.height);
                }];
            }
                break;

            default:
                break;
        }
    }
}

- (void)dismiss{
    switch (self.animType) {
        case My_AlertAnimateType_Fade:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        case My_AlertAnimateType_FromRight:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.centerView.center = CGPointMake(self.frame.size.width + self.centerView.frame.size.width/2.0, self.frame.size.height/2.0);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        case My_AlertAnimateType_Larger:
        {
            [UIView animateWithDuration:0.15 animations:^{
                self.centerView.frame = CGRectMake(self.frame.size.width/2.0, self.frame.size.height/2.0, 0, 0);;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;

        default:
            [self removeFromSuperview];
            break;
    }
}

@end
