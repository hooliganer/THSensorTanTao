//
//  DetailInfoController+DetailInfoUI.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"

@interface DetailInfoController (DetailInfoUI)

- (void)refershHourTempLineView:(bool)isLeft;

- (void)refershDayTempLineView:(bool)isLeft;

- (void)refershWeekTempLineView:(bool)isLeft;

/*!
 * 刷新历史记录view(当前小时、温度类型)
 */
- (void)refershHourHumiLineView:(bool)isLeft;

/*!
 * 刷新历史记录view(当前天、湿度类型)
 */
- (void)refershDayHumiLineView:(bool)isLeft;

/*!
 * 刷新历史记录view(当前周、湿度类型)
 */
- (void)refershWeekHumiLineView:(bool)isLeft;




/*!
 * 根据设备的信息，初始化一些UI信息
 */
- (void)setDeviceInfo;

@end
