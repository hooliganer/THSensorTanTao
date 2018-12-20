//
//  DetailInfoController+DetailInfoBG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"

@interface DetailInfoController (DetailInfoBG)

/*!
 * 设置本地信息
 */
- (void)setLocalInfo;

/*!
 * 蓝牙请求实时数据
 */
- (void)selecetBLEDevData;

/*!
 * 关注当前设备至服务器
 */
- (void)linkDev;

/*!
 * 开启所有定时器
 */
- (void)startTimer;

/*!
 * 设置设备名称（网络）
 */
- (void)setDevName;

/*!
 * 设置设备类型（网络）
 */
- (void)setDevType;

/*!
 * 设置设备是否开启报警（本地fmdb）
 */
- (void)setDevIsAlert;

/*!
 * 设置设备报警阈值（本地）
 */
- (void)setDevLimitValue;

/*!
 * 监听蓝牙返回数据
 */
- (void)notifyValueForCharacteristic;

/*!
 * 蓝牙请求历史数据
 * @parama isStart 开始/结束
 */
- (void)selecetHistoryDataIsStart:(bool)isStart;

/*!
 * 读本地所有历史数据
 */
- (void)readLocalHistory;

/*!
 * 刷新报警，根据本地报警限制条件进行判断
 * @parama temp 温度
 * @parama humi 湿度
 */
- (void)refershWarningWithTemp:(float)temp Humi:(float)humi UnitTemp:(NSString *)unitTP UnitHumi:(NSString *)unitHM;


/*!
 * 刷新中部文字信息区域（历史记录上边）
 */
- (void)refershHistoryUI;

/*!
 * 刷新报警类型视图
 */
- (void)refershWarnUI;

/*！
 * 获取当前温度单位
 */
- (NSString *)currentTemperUnit;

@end
