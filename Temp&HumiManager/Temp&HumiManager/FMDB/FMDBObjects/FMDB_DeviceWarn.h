//
//  FMDB_DeviceWarn.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/11.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SuperFMDBManager.h"

/*!
 * 设备报警历史信息
 */
@interface FMDB_DeviceWarn : SuperFMDBManager

@property (nonatomic,assign,readonly)int devID;
@property (nonatomic,copy)NSString *mac;
@property (nonatomic,assign)float temperature;
@property (nonatomic,assign)int humidity;
@property (nonatomic,assign)NSTimeInterval dateLine;

/*!
 * 带数据库的实例化
 */
- (instancetype)initDatabase;

+ (FMDB_DeviceWarn *)sharedInstance;

/*!
 * 查对应Mac的所有报警信息
 */
- (void)selectAllByMac:(NSString *)mac Block:(void(^)(NSArray <FMDB_DeviceWarn *> *allWarnInfos))blockAll;

/*!
 * 添加一条数据
 */
- (void)insert;

@end
