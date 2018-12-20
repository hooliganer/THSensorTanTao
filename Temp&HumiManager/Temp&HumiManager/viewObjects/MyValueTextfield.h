//
//  MyValueTextfield.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyValueTextfield : UIView

@property (nonatomic,strong)UIColor *tintsColor;
@property (nonatomic,strong,readonly)UITextField *textField;
@property (nonatomic,strong,readonly)UILabel *labValue;
@property (nonatomic,assign)bool oppisite;

@end
