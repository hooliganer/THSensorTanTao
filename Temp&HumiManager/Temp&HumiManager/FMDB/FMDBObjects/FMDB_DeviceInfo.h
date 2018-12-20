//
//  FMDB_DeviceInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DeviceInfo.h"

/*!
 * 设备本地信息
 */
@interface FMDB_DeviceInfo : DeviceInfo

@property (nonatomic,assign,readonly)int devID;
@property (nonatomic,assign)bool isWarn;///<是否开启报警⚠️
@property (nonatomic,assign)float lessTemper;///<温度🌡️下限阈值
@property (nonatomic,assign)float overTemper;///<温度🌡️上限阈值
@property (nonatomic,assign)float lessHumidi;///<湿度💧下限阈值
@property (nonatomic,assign)float overHumidi;///<湿度💧上限阈值

@property (nonatomic,assign)NSTimeInterval tempTime;///<确认温度报警的时间
@property (nonatomic,assign)NSTimeInterval humiTime;///<确认湿度报警的时间
@property (nonatomic,copy,readonly)NSString *dbName;///<数据库保存的名称,依据网络名称
@property (nonatomic,assign,readonly)int devType;///<数据库保存的类型,依据网络motostep


/*!
 * 带数据库的实例化
 */
- (instancetype)initDatabase;

+ (FMDB_DeviceInfo *)sharedInstance;

/*!
 * 添加一条数据
 */
- (void)insert;

/*!
 * 根据Mac更新是否报警信息
 */
- (void)updateIsWarn;

/*!
 * 根据Mac更新报警阈值信息
 */
- (void)updateWarnValue;

/*!
 * 根据Mac更新确认温度报警的时间
 */
- (void)updateTempTime;

/*!
 * 根据Mac更新确认湿度报警的时间
 */
- (void)updateHumiTime;



/*!
 * 查询所有的设备信息
 */
- (void)selectAll:(void(^)(NSArray <FMDB_DeviceInfo *> *allDevInfos))blockAll;

/*!
 * 查对应Mac的设备信息
 */
- (void)selectAllByMac:(NSString *)mac Block:(void(^)(NSArray <FMDB_DeviceInfo *> *allDevInfos))blockAll;

@end
