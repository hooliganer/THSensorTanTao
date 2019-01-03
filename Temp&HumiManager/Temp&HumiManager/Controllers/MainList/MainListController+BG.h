//
//  MainListController+BG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController.h"

@interface MainListController (BG)

/**
 蓝牙扫描
 */
- (void)startBlueToothScan;

/**
 定时查报警判断、组信息
 */
- (void)startTimer;

/**
 查询分组（网关）信息
 */
- (void)selectGroupData;

/**
 查询每组的子设备信息
 */
- (void)selectDevicesOfGroup;

/**
 查本地数据库保存的设备信息
 */
- (void)selectLocalDevices;

/**
 保存某个设备确认报警的信息

 @param mac MAC地址
 */
- (void)saveWarnConfirmWithMac:(NSString *)mac;

@end
