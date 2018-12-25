//
//  DeviceDB+CoreDataProperties.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import "DeviceDB+CoreDataProperties.h"

@implementation DeviceDB (CoreDataProperties)

+ (NSFetchRequest<DeviceDB *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DeviceDB"];
}

@dynamic isWarn;
@dynamic lessTemper;
@dynamic overTemper;
@dynamic lessHumidi;
@dynamic overHumidi;
@dynamic mac;
@dynamic tempTime;
@dynamic humiTime;
@dynamic dbName;
@dynamic devType;

@end
