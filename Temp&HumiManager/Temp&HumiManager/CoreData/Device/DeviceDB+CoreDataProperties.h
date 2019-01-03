//
//  DeviceDB+CoreDataProperties.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "DeviceDB+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeviceDB (CoreDataProperties)

+ (NSFetchRequest<DeviceDB *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *dbName;///<设备名称
@property (nonatomic) int16_t devType;///<设备类型
@property (nonatomic) double humiTime;
@property (nonatomic) BOOL isWarn;///<报警是否开启
@property (nonatomic) float lessHumidi;///<湿度报警最小值
@property (nonatomic) float lessTemper;///<温度报警最小值
@property (nullable, nonatomic, copy) NSString *mac;///<Mac地址
@property (nonatomic) float overHumidi;///<湿度报警最大值
@property (nonatomic) float overTemper;///<温度报警最大值
@property (nonatomic) double tempTime;
@property (nullable, nonatomic, retain) NSOrderedSet<WarnRecordSetDB *> *warnSetRecords;

@end

@interface DeviceDB (CoreDataGeneratedAccessors)

- (void)insertObject:(WarnRecordSetDB *)value inWarnSetRecordsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWarnSetRecordsAtIndex:(NSUInteger)idx;
- (void)insertWarnSetRecords:(NSArray<WarnRecordSetDB *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWarnSetRecordsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWarnSetRecordsAtIndex:(NSUInteger)idx withObject:(WarnRecordSetDB *)value;
- (void)replaceWarnSetRecordsAtIndexes:(NSIndexSet *)indexes withWarnSetRecords:(NSArray<WarnRecordSetDB *> *)values;
- (void)addWarnSetRecordsObject:(WarnRecordSetDB *)value;
- (void)removeWarnSetRecordsObject:(WarnRecordSetDB *)value;
- (void)addWarnSetRecords:(NSOrderedSet<WarnRecordSetDB *> *)values;
- (void)removeWarnSetRecords:(NSOrderedSet<WarnRecordSetDB *> *)values;

@end

NS_ASSUME_NONNULL_END
