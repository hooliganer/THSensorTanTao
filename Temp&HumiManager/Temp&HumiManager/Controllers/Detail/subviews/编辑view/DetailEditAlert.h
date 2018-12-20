//
//  DetailEditAlert.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/19.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton_DIYObject.h"
#import "Temp_HumiManager-Swift.h"
#import "MySwitch.h"

@interface DetailEditAlert : UIView

@property (nonatomic,strong)UIButton_DIYObject *btnSave;
@property (nonatomic,strong)UIButton_DIYObject *btnCancel;
@property (nonatomic,strong)UITextField *tfName;
@property (nonatomic,strong)DetailLimitView *limitTemp;
@property (nonatomic,strong)DetailLimitView *limitHumi;
@property (nonatomic,strong)MySwitch *switcher;

@property (nonatomic,assign)int type;
@property (nonatomic,assign)bool alertWarning;

- (void)show;
- (void)dismiss;

@end
