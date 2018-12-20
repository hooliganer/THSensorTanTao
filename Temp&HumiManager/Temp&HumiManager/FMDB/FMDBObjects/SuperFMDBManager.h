//
//  SuperFMDBManager.h
//  TestAll
//
//  Created by terry on 2018/5/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface SuperFMDBManager : NSObject

@property (nonatomic,strong)FMDatabase *database;
@property (nonatomic,strong)FMDatabaseQueue *dbQueue;

/*!
 * 获得数据库文件的路径
 */
+ (NSString *)sqlitePath;

- (void)queueDatabase:(void(^)(FMDatabase *db, BOOL *rollback))block;

@end
