//
//  My_AlertView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/6/22.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "My_AlertView.h"

@implementation My_AlertView

+ (void)showLoading:(void (^)(My_AlertView *))block{
    My_AlertView * alert = [[My_AlertView alloc]init];
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]init];
    indicator.size = CGSizeMake(100, 100);
    indicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    indicator.layer.masksToBounds = true;
    indicator.layer.cornerRadius = 8;
    [indicator startAnimating];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    alert.centerView = indicator;
    [alert showBlock:block];
}

+ (void)showLoadingWithText:(NSString *)text Block:(void (^)(My_AlertView *, UILabel *))block{
    
    My_AlertView * alert = [[My_AlertView alloc]init];
    
    UILabel * lab = [[UILabel alloc]init];
//    lab.backgroundColor = [UIColor redColor];
    lab.text = text;
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab fitMaxWidth:150];
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]init];
    indicator.size = CGSizeMake(50, 50);
    [indicator startAnimating];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    CGFloat w = lab.width < 90 ? 100 : lab.width + 10;
    UIView * view = [[UIView alloc]init];
    view.size = CGSizeMake(w, lab.height + indicator.height + 20);
    indicator.y = 10;
    indicator.cx = view.width/2.0;
    lab.y = indicator.bottomY + 5;
    lab.cx = view.width/2.0;
    [view addSubview:lab];
    [view addSubview:indicator];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    view.layer.masksToBounds = true;
    view.layer.cornerRadius = 8;
    
    alert.centerView = view;
    [alert showBlock:^(My_AlertView *alertView) {
        if (block) {
            block(alertView,lab);
        }
    }];
}

+ (void)showInfo:(NSString *)info Block:(void (^)(My_AlertView *))block{
    My_AlertView * alert = [[My_AlertView alloc]init];
    alert.animType = My_AlertAnimateType_Fade;
    AlertInfoer * infoview = [AlertInfoer instanceWithFrame:CGRectMake(0, 0, alert.width * 0.65, 0)];
    infoview.infoLab.text = info;
    infoview.btn.tag = 1001;
    [infoview.btn addTarget:alert action:@selector(clickAlertButton:) forControlEvents:UIControlEventTouchUpInside];
    infoview.tag = 10001;
    
    alert.centerView = infoview;
    [alert showBlock:block];
}

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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.centerView.center = CGPointMake(self.width/2.0, self.height/2.0);
    
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
                [[[UIApplication sharedApplication] keyWindow] addSubview:self];
                break;
        }
    }
    if (block) {
        block(self);
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


- (void)clickAlertButton:(UIButton *)sender{
    switch (sender.tag) {
        case 1001:
            [self dismiss];
            break;
            
        default:
            break;
    }
}

@end
