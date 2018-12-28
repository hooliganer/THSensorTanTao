//
//  MainListController+BG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController.h"

@interface MainListController (BG)

- (void)startBlueToothScan;

- (void)startTimer;

/**
 查询分组（网关）信息
 */
- (void)selectGroupData;

/**
 查询每组的子设备信息
 */
- (void)selectDevicesOfGroup;

///**
// 查询设备数据
// */
//- (void)selectDataOfDevice;

/**
 保存某个设备确认报警的信息

 @param mac MAC地址
 */
- (void)saveWarnConfirmWithMac:(NSString *)mac;

@end
