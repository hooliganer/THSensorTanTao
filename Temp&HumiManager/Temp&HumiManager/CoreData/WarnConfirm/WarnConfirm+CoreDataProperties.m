//
//  WarnConfirm+CoreDataProperties.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/28.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnConfirm+CoreDataProperties.h"

@implementation WarnConfirm (CoreDataProperties)

+ (NSFetchRequest<WarnConfirm *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WarnConfirm"];
}

@dynamic mac;
@dynamic time;

@end
