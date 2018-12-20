//
//  DetailTypeChooseView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/15.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailTypeChooseView.h"
#import "UIButton_DIYObject.h"

@implementation DetailTypeChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    for (int i=0; i<3; i++) {
        UIButton_DIYObject *btn = [self viewWithTag:i+10];
        if (btn) {
            CGFloat height = self.frame.size.height;
            CGFloat distance = Fit_X(20.0);
            CGFloat x = 0;
            switch (i) {
                case 0:
                    x = self.frame.size.width/2.0 - height*1.5 - distance;
                    break;
                case 1:
                    x = self.frame.size.width/2.0 - height*0.5;
                    break;
                case 2:
                    x = self.frame.size.width/2.0 + height*0.5 + distance;
                    break;

                default:
                    break;
            }
            btn.frame = CGRectMake(x, 0, height, height);
        }
    }
}

- (void)createBtn{
    for (int i=0; i<3; i++) {
        UIButton_DIYObject *btn = [[UIButton_DIYObject alloc]init];
        btn.tag = i+10;
        switch (i) {
            case 0:
                [btn setBackgroundImage:[UIImage imageNamed:@"温度选中"] forState:UIControlStateNormal];
                break;
            case 1:
                [btn setBackgroundImage:[UIImage imageNamed:@"湿度未选中"] forState:UIControlStateNormal];
                break;
            case 2:
                [btn setBackgroundImage:[UIImage imageNamed:@"报警未选中"] forState:UIControlStateNormal];
                break;

            default:
                break;
        }
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)clickButton:(UIButton_DIYObject *)sender{

    UIButton_DIYObject *btn1 = [self viewWithTag:10];
    [btn1 setBackgroundImage:[UIImage imageNamed:btn1.tag==sender.tag?@"温度选中":@"温度未选中"] forState:UIControlStateNormal];
    UIButton_DIYObject *btn2 = [self viewWithTag:11];
    [btn2 setBackgroundImage:[UIImage imageNamed:btn2.tag==sender.tag?@"湿度选中":@"湿度未选中"] forState:UIControlStateNormal];
    UIButton_DIYObject *btn3 = [self viewWithTag:12];
    [btn3 setBackgroundImage:[UIImage imageNamed:btn3.tag==sender.tag?@"报警选中":@"报警未选中"] forState:UIControlStateNormal];

    self.type = (int)sender.tag - 10;

    if ([self.delegate respondsToSelector:@selector(typeChooseView:ChooseType:)]) {
        [self.delegate typeChooseView:self ChooseType:(int)sender.tag - 10];
    }
}

@end
