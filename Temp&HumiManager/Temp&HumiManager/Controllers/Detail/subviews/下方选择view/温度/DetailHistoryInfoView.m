//
//  DetailHistoryInfoView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/15.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailHistoryInfoView.h"

@implementation DetailHistoryInfoView

- (instancetype)init{
    if (self = [super init]) {
        [self createLabel];
    }
    return self;
}



- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGFloat lineWidth = Fit_Y(1.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:lineWidth];
    [[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1] setStroke];
    [path moveToPoint:CGPointMake(0, self.frame.size.height/2.0 - lineWidth/2.0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2.0 - lineWidth/2.0)];
    [path stroke];
    [path closePath];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    UILabel *lab1 = [self viewWithTag:10];
    lab1.frame = CGRectMake(0, 0, self.frame.size.width/2.0, self.frame.size.height*0.25);

    UILabel *lab2 = [self viewWithTag:11];
    lab2.frame = CGRectMake(self.frame.size.width*0.5, 0, self.frame.size.width/2.0, self.frame.size.height*0.25);

    UILabel *lab3 = [self viewWithTag:12];
    lab3.frame = CGRectMake(0, self.frame.size.height*0.25, self.frame.size.width/2.0, self.frame.size.height*0.25);

    UILabel *lab4 = [self viewWithTag:13];
    lab4.frame = CGRectMake(self.frame.size.width*0.5, self.frame.size.height*0.25, self.frame.size.width/2.0, self.frame.size.height*0.25);

    UILabel *lab5 = [self viewWithTag:14];
    lab5.frame = CGRectMake(0, self.frame.size.height*0.5, self.frame.size.width/3.0, self.frame.size.height*0.25);

    UILabel *lab6 = [self viewWithTag:15];
    lab6.frame = CGRectMake(self.frame.size.width/3.0, self.frame.size.height*0.5, self.frame.size.width/3.0, self.frame.size.height*0.25);
    
    UILabel *lab7 = [self viewWithTag:16];
    lab7.frame = CGRectMake(self.frame.size.width*2.0/3.0, self.frame.size.height*0.5, self.frame.size.width/3.0, self.frame.size.height*0.25);

    UILabel *lab8 = [self viewWithTag:17];
    lab8.frame = CGRectMake(0, self.frame.size.height*0.75, self.frame.size.width/3.0, self.frame.size.height*0.25);

    UILabel *lab9 = [self viewWithTag:18];
    lab9.frame = CGRectMake(self.frame.size.width/3.0, self.frame.size.height*0.75, self.frame.size.width/3.0, self.frame.size.height*0.25);

    UILabel *lab10 = [self viewWithTag:19];
    lab10.frame = CGRectMake(self.frame.size.width*2.0/3.0, self.frame.size.height*0.75, self.frame.size.width/3.0, self.frame.size.height*0.25);

}




#pragma mark - inside method
- (void)createLabel{

    for (NSInteger tag = 0; tag<10; tag++) {

        UILabel *lab = [[UILabel alloc]init];
        lab.tag = tag+10;
        lab.textAlignment = NSTextAlignmentCenter;

        if (tag == 0 || tag == 4|| tag == 5|| tag == 6)
        {
            if (@available(iOS 8.2, *)) {
                lab.font = [UIFont fitSystemFontOfSize:20.0 weight:UIFontWeightBold];
            } else {
                lab.font = [UIFont fitSystemFontOfSize:20.0];
            }
        }
        else
        {
            if (@available(iOS 8.2, *)) {
                lab.font = [UIFont fitSystemFontOfSize:22.0 weight:UIFontWeightLight];
            } else {
                lab.font = [UIFont fitSystemFontOfSize:22.0];
            }
        }

        switch (tag) {
            case 0:
                lab.text = @"LAST CHECK IN";
                break;
            case 1:
                lab.text = @"--/--/----";
                break;
            case 2:
                lab.text = @"--%%";
                break;
            case 3:
                lab.text = @"--:--:--";
                break;
            case 4:
                lab.text = @"HIGH";
                break;
            case 5:
                lab.text = @"LOW";
                break;
            case 6:
                lab.text = @"AVG";
                break;
            case 7:
                lab.text = @"--%%";
                break;
            case 8:
                lab.text = @"--%%";
                break;
            case 9:
                lab.text = @"--%%";
                break;

            default:
                break;
        }

        [self addSubview:lab];
    }
}



@end
