//
//  SettingController.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MySuperController.h"
#import "MyPeripheral.h"

@interface SettingController : MySuperController

@property (nonatomic,strong)NSMutableArray <MyPeripheral *>* peripherals;

@end
