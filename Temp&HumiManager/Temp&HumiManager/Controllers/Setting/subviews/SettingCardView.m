//
//  SettingCardView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingCardView.h"

@interface SettingCardView ()

@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,assign,readwrite)CGFloat topHeight;

@end

@implementation SettingCardView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.labTitle.center = CGPointMake(self.frame.size.width/2.f, Fit_Y(50.f)/2.f);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    self.layer.masksToBounds = true;
    self.layer.cornerRadius = Fit_Y(5.0);

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.topHeight)];
    [[UIColor colorWithRed:7/255.0 green:42/255.0 blue:51/255.0 alpha:1] setFill];
    [path1 fill];

}

- (void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];


}



- (CGFloat)topHeight{
    if (_topHeight == 0) {
        _topHeight = Fit_Y(50.0);
    }
    return _topHeight;
}

- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.textColor = [UIColor whiteColor];
        _labTitle.font = [UIFont fitSystemFontOfSize:20.f];
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.labTitle.text = title;
    [self.labTitle sizeToFit];
}

@end
