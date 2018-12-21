//
//  DetailChooseSegment.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/12.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailChooseSegment.h"


@interface DetailChooseSegment ()

@property (nonatomic,strong)UIButton_DIYObject *btn1;
@property (nonatomic,strong)UIButton_DIYObject *btn2;
@property (nonatomic,strong)UIButton_DIYObject *btn3;




@end

@implementation DetailChooseSegment

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:20/255.0 green:104/255.0 blue:127/255.0 alpha:1];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = Fit_X(1.f);
    CGFloat wTop = (self.frame.size.width - distance*4.f)/3.f;
    CGFloat hTop = self.frame.size.height/2.f;

    self.btn1.frame = CGRectMake(distance, 0, wTop, hTop);
    self.btn2.frame = CGRectMake(wTop+distance*2.f, 0, wTop, hTop);
    self.btn3.frame = CGRectMake(wTop*2.f + distance*3.f, 0, wTop, hTop);

    distance = Fit_X(20.0);
    UIImage *img = [UIImage imageNamed:@"to_left"];
    CGFloat hImg = self.frame.size.height/2.0;
    CGFloat wImg = (img.size.width/img.size.height)*hImg;
    self.btn4.frame = CGRectMake(distance, hTop, wImg, hImg);
    self.btn5.frame = CGRectMake(self.frame.size.width - distance - wImg, hTop, wImg, hImg);

    self.labCenter.center = CGPointMake(self.frame.size.width/2.0, (self.frame.size.height - hTop)/2.0 + hTop);
}

#pragma mark - SET 方法
- (void)setDate:(NSDate *)date{
    _date = date;
    switch (self.type) {
        case 1://day
        {
            NSDate * date1 = [date dateWithDays:-1];
            self.labCenter.text = [NSString stringWithFormat:@"%02d.%02d-%02d.%02d",[date1 nMonth],[date1 nDay],[date nMonth],[date nDay]];
        }
            break;
        case 2://week
        {
            NSDate * date1 = [date dateWithDays:-7];
            NSString * monStr = [NSString englishMonth:[date nMonth] IsAb:true];
            NSString * monStr1 = [NSString englishMonth:[date1 nMonth] IsAb:true];
            //刷新中间时间文本
            self.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d - %@ %02d %d",monStr,[date nDay],[date nYear],monStr1,[date1 nDay],[date1 nYear]];
        }
            break;
            
        default://hour
        {
            NSDate * date1 = [date dateWithSeconds:-3600];
            self.labCenter.text = [NSString stringWithFormat:@"%02d:00-%02d:00",[date1 nHour],[date nHour]];
        }
            break;
    }
    [self.labCenter sizeToFit];
}

- (void)setType:(int)type{
    _type = type;
    
    NSDate * date = self.date;
    switch (type) {
        case 1://day
        {
            NSDate * date1 = [date dateWithDays:-1];
            self.labCenter.text = [NSString stringWithFormat:@"%02d.%02d-%02d.%02d",[date1 nMonth],[date1 nDay],[date nMonth],[date nDay]];
        }
            break;
        case 2://week
        {
            NSDate * date1 = [date dateWithDays:-7];
            NSString * monStr = [NSString englishMonth:[date nMonth] IsAb:true];
            NSString * monStr1 = [NSString englishMonth:[date1 nMonth] IsAb:true];
            //刷新中间时间文本
            self.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d - %@ %02d %d",monStr,[date nDay],[date nYear],monStr1,[date1 nDay],[date1 nYear]];
        }
            break;
            
        default://hour
        {
            NSDate * date1 = [date dateWithSeconds:-3600];
            self.labCenter.text = [NSString stringWithFormat:@"%02d:00-%02d:00",[date1 nHour],[date nHour]];
        }
            break;
    }
    [self.labCenter sizeToFit];
}

#pragma mark - lazy load
- (UIButton_DIYObject *)btn1{
    if (_btn1 == nil) {
        _btn1 = [[UIButton_DIYObject alloc]init];
        _btn1.title = @"HOUR";
        _btn1.selected = TRUE;
        _btn1.tag = 10;
        _btn1.labTitle.textColor = [UIColor whiteColor];
        [_btn1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn1];
    }
    return _btn1;
}

- (UIButton_DIYObject *)btn2{
    if (_btn2 == nil) {
        _btn2 = [[UIButton_DIYObject alloc]init];
        _btn2.title = @"DAY";
        _btn2.backgroundColor = [UIColor colorWithRed:64/255.0 green:134/255.0 blue:153/255.0 alpha:1];
        _btn2.tag = 11;
        _btn2.labTitle.textColor = [UIColor whiteColor];
        [_btn2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn2];
    }
    return _btn2;
}

- (UIButton_DIYObject *)btn3{
    if (_btn3 == nil) {
        _btn3 = [[UIButton_DIYObject alloc]init];
        _btn3.title = @"WEEK";
        _btn3.backgroundColor = [UIColor colorWithRed:64/255.0 green:134/255.0 blue:153/255.0 alpha:1];
        _btn3.tag = 12;
        _btn3.labTitle.textColor = [UIColor whiteColor];
        [_btn3 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn3];
    }
    return _btn3;
}

- (UIButton_DIYObject *)btn4{
    if (_btn4 == nil) {
        _btn4 = [[UIButton_DIYObject alloc]init];
        _btn4.tag = 13;
        [_btn4 addTarget:self action:@selector(clickDirection:) forControlEvents:UIControlEventTouchUpInside];
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"to_left"] forState:UIControlStateNormal];
        [_btn4 setOriginalScale:0.8];
        [self addSubview:_btn4];
    }
    return _btn4;
}

- (UIButton_DIYObject *)btn5{
    if (_btn5 == nil) {
        _btn5 = [[UIButton_DIYObject alloc]init];
        _btn5.tag = 14;
        [_btn5 addTarget:self action:@selector(clickDirection:) forControlEvents:UIControlEventTouchUpInside];
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"to_right"] forState:UIControlStateNormal];
        [_btn5 setOriginalScale:0.8];
        [self addSubview:_btn5];
    }
    return _btn5;
}

- (UILabel *)labCenter{
    if (_labCenter == nil) {
        _labCenter = [[UILabel alloc]init];
        _labCenter.textColor = [UIColor whiteColor];
        _labCenter.font = [UIFont fitSystemFontOfSize:18.0];
        [self addSubview:_labCenter];
    }
    return _labCenter;
}

- (void)clickDirection:(UIButton_DIYObject *)sender{

    if ([self.delegate respondsToSelector:@selector(segmentView:chooseLR:)]) {
        [self.delegate segmentView:self chooseLR:sender.tag==13];
    }

}

- (void)clickButton:(UIButton_DIYObject *)sender{

    self.btn1.backgroundColor = (sender.tag==self.btn1.tag)?[UIColor clearColor]:[UIColor colorWithRed:64/255.0 green:134/255.0 blue:153/255.0 alpha:1];
    self.btn2.backgroundColor = (sender.tag==self.btn2.tag)?[UIColor clearColor]:[UIColor colorWithRed:64/255.0 green:134/255.0 blue:153/255.0 alpha:1];
    self.btn3.backgroundColor = (sender.tag==self.btn3.tag)?[UIColor clearColor]:[UIColor colorWithRed:64/255.0 green:134/255.0 blue:153/255.0 alpha:1];

    self.type = (int)sender.tag - 10;
    if ([self.delegate respondsToSelector:@selector(segmentView:chooseIndex:)]) {
        [self.delegate segmentView:self chooseIndex:sender.tag - 10];
    }

}

@end
