//
//  DetailWarningAlert.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/25.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWarningAlert : UIButton

@property (nonatomic,strong)UIImageView *imvWarn;
@property (nonatomic,strong)UIImageView *imvTemp;
@property (nonatomic,strong)UIImageView *imvHumi;
@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,strong)UILabel *labTemp;
@property (nonatomic,strong)UILabel *labHumi;

@end
