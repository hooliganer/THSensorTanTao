//
//  FMDB_DeviceWarn.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/11.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "FMDB_DeviceWarn.h"

@interface FMDB_DeviceWarn ()

@property (nonatomic,assign,readwrite)int devID;

@end

@implementation FMDB_DeviceWarn


+ (FMDB_DeviceWarn *)sharedInstance{
    static FMDB_DeviceWarn *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDB_DeviceWarn alloc]initDatabase];
    });
    return manager;
}

- (instancetype)initDatabase{
    if (self = [super init]) {

        [self createTableInQueue];
    }
    return self;
}

- (void)createTableInQueue{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        //4.创表(此处必须用纯字符串形式)
        BOOL result = [db executeUpdate:
                       @"CREATE TABLE IF NOT EXISTS DeviceWarn_Table "
                       "(id integer PRIMARY KEY AUTOINCREMENT, "
                       "temperature double NOT NULL, "
                       "humidity integer NOT NULL, "
                       "dateLine double NOT NULL, "
                       "mac text NOT NULL);"];
        if (result)
        {
            //                        NSLog(@"创建表成功");
        }
        else
        {
            NSLog(@"create FMDB Table:DeviceInfo_Table fail");
        }
    }];
}

- (void)insert{

    if (self.mac.length == 0) {
        NSLog(@"can`t inser nil mac !");
        return ;
    }

    __weak typeof(self) weakself = self;
    //插入操作用 inTransaction:
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

//        "temperature double NOT NULL, "
//        "humidity double NOT NULL, "
//        "dateLine double NOT NULL, "
//        "mac text NOT NULL);"];

        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        [db executeUpdate:
         @"INSERT INTO "
         "DeviceWarn_Table (temperature, humidity, dateLine, mac) "
         "VALUES (?,?,?,?);"
         ,@(weakself.temperature),@(weakself.humidity),@(weakself.dateLine),weakself.mac];

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


- (void)selectAllByMac:(NSString *)mac Block:(void (^)(NSArray<FMDB_DeviceWarn *> *))blockAll{

    if (mac.length == 0) {
        NSLog(@"can`t select nil mac !");
        return ;
    }

    //"DeviceWarn_Table (temperature, humidity, dateLine, mac) "
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //查询整个表
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from DeviceWarn_Table "
                                  "where mac=?;"
                                  ,mac];

        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float temperature = [resultSet doubleForColumn:@"temperature"];
            int humidity = [resultSet intForColumn:@"humidity"];
            NSTimeInterval dateLine = [resultSet doubleForColumn:@"dateLine"];
            NSString *mac = [resultSet stringForColumn:@"mac"];

            FMDB_DeviceWarn *objc = [[FMDB_DeviceWarn alloc]init];
            objc.temperature = temperature;
            objc.humidity = humidity;
            objc.dateLine = dateLine;
            objc.devID = idNum;
            objc.mac = mac;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];

}

@end
