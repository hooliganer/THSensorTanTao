//
//  SuperFMDBManager.m
//  TestAll
//
//  Created by terry on 2018/5/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SuperFMDBManager.h"

@implementation SuperFMDBManager

/*!
 * 获得数据库文件的路径
 */
+ (NSString *)sqlitePath{

    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];

    //获取项目名称
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *executableFile = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey];

    NSString *fileName = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",executableFile]];
    return fileName;
}

- (FMDatabase *)database{
    if (_database == nil) {
        _database = [FMDatabase databaseWithPath:[SuperFMDBManager sqlitePath]];
    }
    return _database;
}

- (FMDatabaseQueue *)dbQueue{
    if (_dbQueue == nil) {
        _dbQueue = [FMDatabaseQueue
                    databaseQueueWithPath:[SuperFMDBManager sqlitePath]];
    }
    return _dbQueue;
}

- (void)queueDatabase:(void (^)(FMDatabase *, BOOL *))block{

    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        block(db,rollback);
    }];

//    __block BOOL wrong = true;
//    //2.把任务包装到事务里
//    [queue inTransaction:^(FMDatabase *db, BOOL *rollback)
//     {
////         wrong &=  [db executeUpdate:
////                    @"INSERT INTO myTable VALUES (?)"
////                    ,[NSNumber numberWithInt:1]];
////         wrong &= [db executeUpdate:
////                   @"INSERT INTO myTable VALUES (?)"
////                   ,[NSNumber numberWithInt:2]];
//
////         //如果有错误 返回
////         if (!wrong)
////         {
////             *rollback = YES;
////             wrongBlock(wrong);
////             return;
////         }
//     }];

}


@end
