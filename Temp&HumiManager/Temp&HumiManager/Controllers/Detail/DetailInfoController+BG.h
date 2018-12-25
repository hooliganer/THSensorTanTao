//
//  DetailInfoController+BG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"

@interface DetailInfoController (BG)

/**
 查询温度并刷新（根据）
 */
- (void)selectInternetTemparature;

/**
 查询湿度并刷新（根据）
 */
- (void)selectInternetHumidity;

/**
 查询报警记录并刷新
 */
- (void)selectInternetWarnRecord;

/**
 查询网络信息
 */
- (void)selectInternetInfo;

@end
