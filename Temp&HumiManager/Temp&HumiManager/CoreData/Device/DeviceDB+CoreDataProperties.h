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

@property (nullable, nonatomic, copy) NSString *dbName;
@property (nonatomic) int16_t devType;
@property (nonatomic) double humiTime;
@property (nonatomic) BOOL isWarn;
@property (nonatomic) float lessHumidi;
@property (nonatomic) float lessTemper;
@property (nullable, nonatomic, copy) NSString *mac;
@property (nonatomic) float overHumidi;
@property (nonatomic) float overTemper;
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
