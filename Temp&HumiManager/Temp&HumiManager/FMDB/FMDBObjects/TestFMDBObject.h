//
//  TestFMDBObject.h
//  TestAll
//
//  Created by terry on 2018/5/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SuperFMDBManager.h"

@interface TestFMDBObject : SuperFMDBManager

@property (nonatomic,strong)NSDate *testDate;
@property (nonatomic,assign,readonly)int testID;
@property (nonatomic,copy)NSString *testName;
@property (nonatomic,assign)float height;
@property (nonatomic,assign)bool sex;

- (instancetype)initDatabase;

- (void)insert;

- (void)deletes;

- (void)update;

- (void)updateName;

+ (void)selectAll:(void(^)(NSArray <TestFMDBObject *> *allTests))blockAll;

+ (void)selectWithHeight:(float)height Block:(void(^)(NSArray <TestFMDBObject *> *allTests))blockAll;

@end
