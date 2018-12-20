//
//  THBlueToothManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BlueToothManager.h"

@interface THBlueToothManager : BlueToothManager

+ (THBlueToothManager *)sharedInstance;

@property (nonatomic,copy)void(^updatePeripheral)(BlueToothManager *manager,BlueToothInfo *info);
@property (nonatomic,copy)void(^newPeripheral)(BlueToothManager *manager,BlueToothInfo *info);

@end
