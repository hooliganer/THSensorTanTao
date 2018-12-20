//
//  DeviceDBManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DBManager.h"
#import "DeviceDB+CoreDataClass.h"

@interface DeviceDBManager : DBManager

/**
 查询所有

 @return 所有Devicedb数据
 */
+ (NSArray <DeviceDB *>*)readAll;

@end
