//
//  MainTableViewHeader.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainTableViewHeader.h"

@interface MainTableViewHeader ()

@property (nonatomic,strong)UIView * contenView;

@end

@implementation MainTableViewHeader

- (instancetype)init{
    if (self = [super init]) {

        self.contenView = [[UIView alloc]init];
        [self addSubview:self.contenView];
        self.contenView.backgroundColor = [UIColor whiteColor];
        self.contenView.layer.masksToBounds = true;

        self.labTitle = [[UILabel alloc]init];
        [self addSubview:self.labTitle];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.contenView.frame = CGRectMake(self.frame.size.width/20.0, 0, self.frame.size.width*18.0/20.0, self.frame.size.height);
    self.contenView.layer.cornerRadius = Fit_Y(8.0);

    CGFloat w =  self.frame.size.width*0.5;
    self.labTitle.frame = CGRectMake(self.frame.size.width/2.0 - w/2.0, 0, w, self.frame.size.height);
}

@end
