//
//  SettingController+SettingExtension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/24.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingController.h"
#import "SettingCardView.h"
#import "UITextField_DIYField.h"
#import "MyValueTextfield.h"
#import "SettingGroupChooseView.h"
#import "HTTP_GroupManager.h"
#import "MyScrollView.h"

@interface SettingController ()

@property (nonatomic,strong)UITableView * wifiTable;


@property (nonatomic,strong)SettingCardView *wifiView;
@property (nonatomic,strong)SettingCardView *unitView;

@property (nonatomic,strong)SettingGroupAlert *groupTable;
@property (nonatomic,strong)UITextField_DIYField *tfWifi;
@property (nonatomic,strong)UITextField_DIYField *tfPwd;
@property (nonatomic,strong)UIButton *btn_C;
@property (nonatomic,strong)UIButton *btn_F;

@property (nonatomic,strong)MyValueTextfield *tfSecond;
@property (nonatomic,strong)MyValueTextfield *tfMinute;

@property (nonatomic,strong)MyScrollView *mainScroll;

@end
