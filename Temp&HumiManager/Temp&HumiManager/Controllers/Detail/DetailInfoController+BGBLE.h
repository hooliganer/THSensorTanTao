//
//  DetailInfoController+BGBLE.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//

#import "DetailInfoController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailInfoController (BGBLE)

/**
 开始查询蓝牙数据
 */
- (void)startBLE;

/**
 从数据库读本地信息
 */
- (void)readLocalInfo;

/**
 保存本地设备的信息
 */
- (void)saveLocalInfo;

/**
 读本地温度记录
 */
- (void)readLocalTemparatureRecord;

/**
 读本地湿度记录
 */
- (void)readLocalHumidityRecord;


@end

NS_ASSUME_NONNULL_END
