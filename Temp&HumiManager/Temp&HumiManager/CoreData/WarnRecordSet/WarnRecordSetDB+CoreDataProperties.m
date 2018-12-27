//
//  WarnRecordSetDB+CoreDataProperties.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnRecordSetDB+CoreDataProperties.h"

@implementation WarnRecordSetDB (CoreDataProperties)

+ (NSFetchRequest<WarnRecordSetDB *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WarnRecordSetDB"];
}

@dynamic settime;
@dynamic mac;
@dynamic ison;
@dynamic tempMax;
@dynamic tempMin;
@dynamic humiMax;
@dynamic humiMin;
@dynamic device;

@end
