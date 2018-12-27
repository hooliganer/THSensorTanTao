//
//  DeviceDB+CoreDataProperties.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "DeviceDB+CoreDataProperties.h"

@implementation DeviceDB (CoreDataProperties)

+ (NSFetchRequest<DeviceDB *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"DeviceDB"];
}

@dynamic dbName;
@dynamic devType;
@dynamic humiTime;
@dynamic isWarn;
@dynamic lessHumidi;
@dynamic lessTemper;
@dynamic mac;
@dynamic overHumidi;
@dynamic overTemper;
@dynamic tempTime;
@dynamic warnSetRecords;

@end
