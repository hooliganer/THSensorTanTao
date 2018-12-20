//
//  TestDB+CoreDataProperties.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import "TestDB+CoreDataProperties.h"

@implementation TestDB (CoreDataProperties)

+ (NSFetchRequest<TestDB *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TestDB"];
}

@dynamic age;
@dynamic name;
@dynamic sex;

@end
