//
//  MyCollectionHeaderView.m
//  TestAll
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyCollectionHeaderView.h"

#define HeaderDistance Fit_X(20.0)
#define HeaderBtmHeight Fit_Y(20.0)

@implementation MyCollectionHeaderView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(HeaderDistance, 0, self.frame.size.width - HeaderDistance*2.0, self.frame.size.height - HeaderBtmHeight) cornerRadius:Fit_Y(5.0)];
    [[UIColor whiteColor] setFill];
    [path fill];

}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.labTitle.center = CGPointMake(HeaderDistance + self.labTitle.bounds.size.width/2.0 + HeaderDistance, (self.frame.size.height - HeaderBtmHeight)/2.0);

    self.labRight.center = CGPointMake(self.frame.size.width - HeaderDistance - self.labRight.bounds.size.width/2.0 - HeaderDistance, (self.frame.size.height - HeaderBtmHeight)/2.0);
}



- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.font = [UIFont fitSystemFontOfSize:20.0];
        _labTitle.textColor = [UIColor grayColor];
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

- (UILabel *)labRight{
    if (_labRight == nil) {
        _labRight = [[UILabel alloc]init];
        _labRight.font = [UIFont fitSystemFontOfSize:20.0];
        _labRight.textColor = [UIColor grayColor];
        [self addSubview:_labRight];
    }
    return _labRight;
}

@end
