//
//  SettingGroupChooseView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingGroupAlert.h"

@interface SettingGroupChooseView : UIView

@property (nonatomic,strong)UILabel *labText;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UITableView *tableList;
@property (nonatomic,strong)SettingGroupAlert *alertTable;

@end
