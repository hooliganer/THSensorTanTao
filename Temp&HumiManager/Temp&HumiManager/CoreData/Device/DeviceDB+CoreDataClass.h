//
//  DeviceDB+CoreDataClass.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WarnRecordSetDB;

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDB : NSManagedObject

+ (DeviceDB *)newDevice;

+ (DeviceDB *)readBymac:(NSString *)mac;

+ (void)deleteAll;

+ (NSArray <DeviceDB *>*)readAll;

+ (void)deleteByMac:(NSString *)mac;

/**
 此方法并不是指保存一条数据，而是指保存当前操作的DeviceDB对象的状态
 */
- (void)save;



@end

NS_ASSUME_NONNULL_END

#import "DeviceDB+CoreDataProperties.h"
