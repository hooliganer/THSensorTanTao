//
//  TestDB+CoreDataProperties.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import "TestDB+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TestDB (CoreDataProperties)

+ (NSFetchRequest<TestDB *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL sex;

@end

NS_ASSUME_NONNULL_END
