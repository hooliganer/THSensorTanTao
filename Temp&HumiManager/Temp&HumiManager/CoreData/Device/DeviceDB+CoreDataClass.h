//
//  DeviceDB+CoreDataClass.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDB : NSManagedObject

+ (DeviceDB *)newDevice;

- (void)insert;

+ (DeviceDB *)readBymac:(NSString *)mac;

+ (NSArray <DeviceDB *>*)readAll;

@end

NS_ASSUME_NONNULL_END

#import "DeviceDB+CoreDataProperties.h"
