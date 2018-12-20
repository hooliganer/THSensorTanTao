//
//  FMDB_HitoryRecord.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "FMDB_HitoryRecord.h"

@interface FMDB_HitoryRecord ()

@property (nonatomic,assign,readwrite)int testID;

@end

@implementation FMDB_HitoryRecord

+ (FMDB_HitoryRecord *)sharedInstance{
    static FMDB_HitoryRecord *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDB_HitoryRecord alloc]initDatabase];
    });
    return manager;
}

- (instancetype)initDatabase{
    if (self = [super init]) {
//        [self createTable];
        [self createTableInQueue];
    }
    return self;
}


- (void)createTableInQueue{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        //4.创表(此处必须用纯字符串形式)
        BOOL result = [db executeUpdate:
                       @"CREATE TABLE IF NOT EXISTS history_table "
                       "(id integer PRIMARY KEY AUTOINCREMENT, "
                       "temperature double NOT NULL, "
                       "humidity integer NOT NULL, "
                       "dateInterval double NOT NULL, "
                       "mac text NOT NULL);"];
        if (result)
        {
            //            NSLog(@"创建表成功");
        }
        else
        {
            NSLog(@"create FMDB Table:history_table fail");
        }
    }];
}

- (void)createTable{

    //2.获得数据库
    //    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([self.database open])
    {
        //4.创表(此处必须用纯字符串形式)
        BOOL result = [self.database executeUpdate:
                       @"CREATE TABLE IF NOT EXISTS history_table "
                       "(id integer PRIMARY KEY AUTOINCREMENT, "
                       "temperature double NOT NULL, "
                       "humidity integer NOT NULL, "
                       "dateInterval double NOT NULL, "
                       "mac text NOT NULL);"];
        if (result)
        {
            //            NSLog(@"创建表成功");
        }
        else
        {
            NSLog(@"create FMDB Table:history_table fail");
        }
        [self.database close];
    }
    else
    {
        NSLog(@"open fail");
    }
}


- (void)insert{

    if (self.mac.length == 0) {
        NSLog(@"can`t inser nil mac !");
        return ;
    }

    __weak typeof(self) weakself = self;
    //插入操作用 inTransaction:
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        [db executeUpdate:
         @"INSERT INTO "
         "history_table (temperature, humidity, dateInterval, mac) "
         "VALUES (?,?,?,?);"
         ,@(weakself.temperature),@(weakself.humidity),@(weakself.dateInterval),weakself.mac];

    }];


    //    //2.executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
    //    [self.database executeUpdateWithFormat:
    //     @"insert into test_table "
    //     "(name,date,sex,height) "
    //     "values (%@,%@,%d,%f);"
    //     ,self.testName,self.testDate,self.sex,self.height];


    //    //3.参数是数组的使用方式
    //    [self.database
    //     executeUpdate:
    //     @"INSERT INTO "
    //     "test_table(name,date,sex,height) "
    //     "VALUES  (?,?,?,?);"
    //     withArgumentsInArray:@[self.testName,
    //                            self.testDate,
    //                            @(self.sex),
    //                            @(self.height)]];

}

/*!
 * 根据ID删除对应的记录
 */
- (void)deletes{

    __weak typeof(self) weakself = self;
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
        [db executeUpdate:@"delete from history_table where id = ?;",(weakself.testID)];

    }];

    //    //2.不确定的参数用%@，%d等来占位
    //    [self.database executeUpdateWithFormat:@"delete from test_table where name = %@;",self.testName];
}

- (void)update{

//    __weak typeof(self) weakself = self;
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        //        [db executeUpdate:
        //         @"update test_table "
        //         "set name = ? "
        //         "where id = ?"
        //         ,weakself.testName,weakself.testID];
        //
        //        [db executeUpdate:
        //         @"update test_table "
        //         "set date = ? "
        //         "where id = ?"
        //         ,weakself.testDate,weakself.testID];
        //
        //        [db executeUpdate:
        //         @"update test_table "
        //         "set sex = ? "
        //         "where id = ?"
        //         ,weakself.sex,weakself.testID];
        //
        //        [db executeUpdate:
        //         @"update test_table "
        //         "set height = ? "
        //         "where id = ?"
        //         ,weakself.height,weakself.testID];

    }];

}


- (void)selectWithDateInterval:(NSTimeInterval)interval Mac:(NSString *)mac Block:(void (^)(NSArray<FMDB_HitoryRecord *> *))blockAll{

    if (mac.length == 0) {
        NSLog(@"can`t be nil mac");
        return ;
    }

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //根据条件查询
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from history_table "
                                  "where dateInterval=? "
                                  "and mac=?;"
                                  ,@(interval),mac];
        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float temp = [resultSet doubleForColumn:@"temperature"];
            int humi = [resultSet intForColumn:@"humidity"];
            NSTimeInterval interval = [resultSet doubleForColumn:@"dateInterval"];

            FMDB_HitoryRecord *objc = [[FMDB_HitoryRecord alloc]init];
            objc.temperature = temp;
            objc.humidity = humi;
            objc.dateInterval = interval;
            objc.testID = idNum;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];

}

- (void)selectAll:(void(^)(NSArray <FMDB_HitoryRecord *>*))blockAll{

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //查询整个表
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from history_table;"];

        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float temp = [resultSet doubleForColumn:@"temperature"];
            int humi = [resultSet intForColumn:@"humidity"];
            NSTimeInterval interval = [resultSet doubleForColumn:@"dateInterval"];

            FMDB_HitoryRecord *objc = [[FMDB_HitoryRecord alloc]init];
            objc.temperature = temp;
            objc.humidity = humi;
            objc.dateInterval = interval;
            objc.testID = idNum;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];

}

- (void)selectAllByMac:(NSString *)mac Block:(void (^)(NSArray<FMDB_HitoryRecord *> *))blockAll{

    if (mac.length == 0) {
        NSLog(@"can`t select nil mac !");
        return ;
    }

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //查询整个表
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from history_table "
                                  "where mac=?;"
                                  ,mac];

        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float temp = [resultSet doubleForColumn:@"temperature"];
            int humi = [resultSet intForColumn:@"humidity"];
            NSTimeInterval interval = [resultSet doubleForColumn:@"dateInterval"];

            FMDB_HitoryRecord *objc = [[FMDB_HitoryRecord alloc]init];
            objc.temperature = temp;
            objc.humidity = humi;
            objc.dateInterval = interval;
            objc.testID = idNum;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];

}

- (void)selectFromInterval:(NSTimeInterval)sInterval ToInterval:(NSTimeInterval)eInterval Mac:(NSString *)mac Block:(void (^)(NSArray<FMDB_HitoryRecord *> *))blockAll{

    if (mac.length == 0) {
        NSLog(@"can`t be nil mac");
        return ;
    }

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //根据条件查询
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from history_table "
                                  "where mac=? "
                                  "and dateInterval>=? "
                                  "and dateInterval<=?;"
                                  ,mac,@(sInterval),@(eInterval)];
        
        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float temp = [resultSet doubleForColumn:@"temperature"];
            int humi = [resultSet intForColumn:@"humidity"];
            NSTimeInterval interval = [resultSet doubleForColumn:@"dateInterval"];

            FMDB_HitoryRecord *objc = [[FMDB_HitoryRecord alloc]init];
            objc.temperature = temp;
            objc.humidity = humi;
            objc.dateInterval = interval;
            objc.testID = idNum;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];
    
}


@end
