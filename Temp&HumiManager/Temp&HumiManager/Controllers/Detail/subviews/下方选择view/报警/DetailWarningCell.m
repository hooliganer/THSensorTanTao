//
//  DetailWarningCell.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 terry. All rights reserved.
//

#import "DetailWarningCell.h"

@interface DetailWarningCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labNumberW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labNumberH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvTPW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvTPH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvHMH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvHMW;

@end

@implementation DetailWarningCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.labNumber.layer.masksToBounds = true;
    self.labNumber.backgroundColor = [UIColor colorWithRed:248/255.0 green:228/255.0 blue:55/255.0 alpha:1];
    self.labNumber.textAlignment = NSTextAlignmentCenter;
    self.labNumber.font = [UIFont systemFontOfSize:16];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.labNumberW.constant = self.height * 0.7;
    self.labNumberH.constant = self.height * 0.7;
    self.labNumber.layer.cornerRadius = self.labNumber.height * 0.5;
    
    self.imvTPH.constant = self.height * 0.5;
    self.imvTPW.constant = (self.imvTemp.image.size.width/self.imvTemp.image.size.height)*self.self.imvTPH.constant;
    
    self.imvHMH.constant = self.height * 0.5;
    self.imvHMW.constant = (self.imvHumi.image.size.width/self.imvHumi.image.size.height)*self.self.imvHMH.constant;
}



@end
