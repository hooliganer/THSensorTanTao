//
//  DetailWarnTopView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailWarnTopView.h"

@implementation DetailWarnTopView

- (instancetype)init{
    if (self = [super init]) {
        [self createLabels];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    UILabel *lab1 = [self viewWithTag:10];
    lab1.frame = CGRectMake(0, 0, self.frame.size.width/3.0, self.frame.size.height*0.4);

    UILabel *lab2 = [self viewWithTag:11];
    lab2.frame = CGRectMake(self.frame.size.width/3.0, 0, self.frame.size.width/3.0, self.frame.size.height*0.4);

    UILabel *lab3 = [self viewWithTag:12];
    lab3.frame = CGRectMake(self.frame.size.width*2.0/3.0, 0, self.frame.size.width/3.0, self.frame.size.height*0.4);

    UILabel *lab4 = [self viewWithTag:13];
    lab4.frame = CGRectMake(0, self.frame.size.height*0.4, self.frame.size.width/3.0, self.frame.size.height*0.4);

    UILabel *lab5 = [self viewWithTag:14];
    lab5.frame = CGRectMake(self.frame.size.width/3.0, self.frame.size.height*0.4, self.frame.size.width/3.0, self.frame.size.height*0.4);

    UILabel *lab6 = [self viewWithTag:15];
    lab6.frame = CGRectMake(self.frame.size.width*2.0/3.0, self.frame.size.height*0.4, self.frame.size.width/3.0, self.frame.size.height*0.4);

}


- (void)createLabels{

    for (int i=0; i<6; i++) {
        UILabel *lab = [[UILabel alloc]init];
        lab.tag = i+10;
        lab.textAlignment = NSTextAlignmentCenter;
        if (i==0 || i==1 || i==2) {
            if (@available(iOS 8.2, *)) {
                lab.font = [UIFont fitSystemFontOfSize:14.0 weight:UIFontWeightBold];
            } else {
                lab.font = [UIFont fitSystemFontOfSize:14.0];
            }
        } else{
            if (@available(iOS 8.2, *)) {
                lab.font = [UIFont fitSystemFontOfSize:22.0 weight:UIFontWeightLight];
            } else {
                lab.font = [UIFont fitSystemFontOfSize:22.0];
            }
        }

        switch (i) {
            case 0:
                lab.text = @"TOTAL";
                break;
            case 1:
                lab.text = @"TEMPARATURE";
                break;
            case 2:
                lab.text = @"HUMIDITY";
                break;
            case 3:
                lab.text = @"--";
                break;
            case 4:
                lab.text = @"--";
                break;
            case 5:
                lab.text = @"--";
                break;

            default:
                break;
        }
        [self addSubview:lab];
    }
}

@end
