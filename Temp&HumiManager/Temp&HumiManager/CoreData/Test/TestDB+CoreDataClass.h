//
//  TestDB+CoreDataClass.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestDB : NSManagedObject

+ (TestDB *)newTest;

@end

NS_ASSUME_NONNULL_END

#import "TestDB+CoreDataProperties.h"
