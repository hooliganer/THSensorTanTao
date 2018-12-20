//
//  SettingController+SettingBG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/24.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingController.h"

@interface SettingController (SettingBG)

/*!
 * 根据一些本地信息设置UI状态
 */
- (void)setLocalInfo;

/*!
 * 查询关注的组
 */
- (void)selectGroups;

/*!
 * 设置点击分组列表的回调（）
 */
- (void)didSelectGroup;

/*!
 * 已经搜索到蓝牙信息的通知
 */
- (void)didSearchBleWithNotification:(NSNotification *)notification;

- (void)executeSetWifi;

- (void)executeSetWifiWithDevice:(MyPeripheral *)info;

@end
