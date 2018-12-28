//
//  WarnRecordSetDB+CoreDataClass.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DeviceDB;

NS_ASSUME_NONNULL_BEGIN

@interface WarnRecordSetDB : NSManagedObject

+ (WarnRecordSetDB *)newWarnSetRecord;

+ (WarnRecordSetDB *)readByTime:(NSTimeInterval)time;
+ (NSArray <WarnRecordSetDB *>*)readAllOrderByMac:(NSString *)mac;

+ (void)deleteAll;

+ (NSArray <WarnRecordSetDB *>*)readAll;

- (void)save;

@end

NS_ASSUME_NONNULL_END

#import "WarnRecordSetDB+CoreDataProperties.h"
