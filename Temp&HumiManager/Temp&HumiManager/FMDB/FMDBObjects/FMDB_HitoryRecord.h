//
//  FMDB_HitoryRecord.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SuperFMDBManager.h"

/*!
 * 历史数据的信息，带数据库存储操作
 */
@interface FMDB_HitoryRecord : SuperFMDBManager

@property (nonatomic,assign,readonly)int testID;
@property (nonatomic,assign)float temperature;///<温度
@property (nonatomic,assign)int humidity;///<湿度
@property (nonatomic,assign)NSTimeInterval dateInterval;///<时间点
@property (nonatomic,copy)NSString *mac;///<Mac地址

/*!
 * 带数据库的实例化
 */
- (instancetype)initDatabase;

+ (FMDB_HitoryRecord *)sharedInstance;

/*!
 * 添加一条数据
 */
- (void)insert;

/*!
 * 查询匹配时间的历史数据
 */
- (void)selectWithDateInterval:(NSTimeInterval)interval Mac:(NSString *)mac Block:(void(^)(NSArray <FMDB_HitoryRecord *> *hitories))blockAll;

/*!
 * 查询所有的历史数据
 */
- (void)selectAll:(void(^)(NSArray <FMDB_HitoryRecord *> *allHistories))blockAll;

/*!
 * 查询某个时间段的历史数据
 * @parama sInterval start time
 * @parama eInterval end time
 */
- (void)selectFromInterval:(NSTimeInterval)sInterval ToInterval:(NSTimeInterval)eInterval Mac:(NSString *)mac Block:(void(^)(NSArray <FMDB_HitoryRecord *> *hitories))blockAll;

/*!
 * 查对应Mac的所有历史数据
 */
- (void)selectAllByMac:(NSString *)mac Block:(void(^)(NSArray <FMDB_HitoryRecord *> *allHistories))blockAll;

@end
