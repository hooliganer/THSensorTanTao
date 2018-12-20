//
//  SettingController+UI.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingController.h"

@interface SettingController (UI)
<UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDataSource>

- (void)setupSubviews;

@end
