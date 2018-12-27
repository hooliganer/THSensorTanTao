//
//  WarnHistoryRecordDB+CoreDataProperties.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnHistoryRecordDB+CoreDataProperties.h"

@implementation WarnHistoryRecordDB (CoreDataProperties)

+ (NSFetchRequest<WarnHistoryRecordDB *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WarnHistoryRecordDB"];
}

@dynamic time;
@dynamic temparature;
@dynamic humidity;
@dynamic mac;
@dynamic sdata;
@dynamic power;

@end
