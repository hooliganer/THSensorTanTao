//
//  DetailInfoController+BG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"
#import "DeviceInfo.h"

@interface DetailInfoController (BG)

/**
 查询当前的温湿度数据并刷新
 */
- (void)selectCurrentInternetTHData;

/**
 查询温度纪录并刷新（根据当前时间段）
 */
- (void)selectInternetTemparature;

/**
 查询湿度纪录并刷新（根据当前时间段）
 */
- (void)selectInternetHumidity;

/**
 查询报警记录并刷新（根据当前时间段）
 */
- (void)selectInternetWarnRecord;

/**
 查询选择时间段内的数据
 
 @param block 回调 - 温湿度数据等等
 */
- (void)selectInternetTHData:(void(^)(NSArray<DeviceInfo *> *datas))block;

/**
 查询网络信息(报警设置、数据等)
 */
- (void)selectInternetInfo;

/**
 修改网络名称
 */
- (void)setInternetDevName;

/**
 修改设备网络类型
 */
- (void)setInternetDevType;

- (void)setInternetWarnSet;

@end
