//
//  FMDB_DeviceInfo.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "FMDB_DeviceInfo.h"

@interface FMDB_DeviceInfo ()

@property (nonatomic,assign,readwrite)int devID;
@property (nonatomic,copy,readwrite)NSString *dbName;///<数据库保存的名称,依据网络名称
@property (nonatomic,assign,readwrite)int devType;///<数据库保存的类型,依据网络motostep

@end

@implementation FMDB_DeviceInfo



+ (FMDB_DeviceInfo *)sharedInstance{
    static FMDB_DeviceInfo *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDB_DeviceInfo alloc]initDatabase];
    });
    return manager;
}

- (void)setShowName:(NSString *)showName{
    [super setShowName:showName];
    self.dbName = showName;
}

- (void)setMotostep:(int)motostep{
    [super setMotostep:motostep];
    self.devType = motostep;
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
                       @"CREATE TABLE IF NOT EXISTS DeviceInfo_Table "
                       "(id integer PRIMARY KEY AUTOINCREMENT, "
                       "lessTemper double NOT NULL, "
                       "overTemper double NOT NULL, "
                       "lessHumidi double NOT NULL, "
                       "overHumidi double NOT NULL, "
                       "isWarn integer NOT NULL, "
                       "mac text NOT NULL, "
                       "tempTime double NOT NULL, "
                       "humiTime double NOT NULL, "
                       "dbName text, "
                       "devType integer);"];
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

    LRWeakSelf(self);
    //插入操作用 inTransaction:
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        [db executeUpdate:
         @"INSERT INTO DeviceInfo_Table "
         "(lessTemper,overTemper,lessHumidi,overHumidi,"
         "isWarn,mac,tempTime,humiTime,dbName,devType) "
         "VALUES (?,?,?,?,?,?,?,?,?,?);"
         ,@(weakself.lessTemper),@(weakself.overTemper)
         ,@(weakself.lessHumidi),@(weakself.overHumidi)
         ,@(weakself.isWarn),weakself.mac
         ,@(weakself.tempTime),@(weakself.humiTime)
         ,weakself.dbName,@(weakself.devType)];

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
 * 根据Mac更新报警信息
 */
- (void)updateIsWarn{

    __weak typeof(self) weakself = self;
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        [db executeUpdate:
         @"update DeviceInfo_Table"
         " set isWarn = ?"
         " where mac = ?"
         ,@(weakself.isWarn),weakself.mac];
    }];

}

/*!
 * 根据Mac更新报警阈值信息
 */
- (void)updateWarnValue{

    __weak typeof(self) weakself = self;
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        [db executeUpdate:
         @"update DeviceInfo_Table"
         " set lessTemper = ?"
         ",overTemper = ?"
         ",lessHumidi = ?"
         ",overHumidi = ?"
         " where mac = ?"
         ,@(weakself.lessTemper)
         ,@(weakself.overTemper)
         ,@(weakself.lessHumidi)
         ,@(weakself.overHumidi)
         ,weakself.mac];
    }];

}

- (void)updateTempTime{
    LRWeakSelf(self);
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        [db executeUpdate:
         @"update DeviceInfo_Table"
         " set tempTime = ?"
         " where mac = ?"
         ,@(weakself.tempTime),weakself.mac];
    }];
}

- (void)updateHumiTime{
    LRWeakSelf(self);
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {

        [db executeUpdate:
         @"update DeviceInfo_Table"
         " set humiTime = ?"
         " where mac = ?"
         ,@(weakself.humiTime),weakself.mac];
    }];
}

- (void)selectAll:(void (^)(NSArray<FMDB_DeviceInfo *> *))blockAll{

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //查询整个表
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from DeviceInfo_Table;"];

        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float lstp = [resultSet doubleForColumn:@"lessTemper"];
            float ovtp = [resultSet doubleForColumn:@"overTemper"];
            float lshm = [resultSet doubleForColumn:@"lessHumidi"];
            float ovhm = [resultSet doubleForColumn:@"overHumidi"];
            bool warn = [resultSet boolForColumn:@"isWarn"];
            NSString *mac = [resultSet stringForColumn:@"mac"];
            NSTimeInterval timetp = [resultSet doubleForColumn:@"tempTime"];
            NSTimeInterval timehm = [resultSet doubleForColumn:@"humiTime"];
            NSString *name = [resultSet stringForColumn:@"dbName"];
            int type = [resultSet intForColumn:@"devType"];

            FMDB_DeviceInfo *objc = [[FMDB_DeviceInfo alloc]init];
            objc.lessTemper = lstp;
            objc.overTemper = ovtp;
            objc.lessHumidi = lshm;
            objc.overHumidi = ovhm;
            objc.devID = idNum;
            objc.isWarn = warn;
            objc.mac = mac;
            objc.tempTime = timetp;
            objc.humiTime = timehm;
            objc.dbName = name;
            objc.devType = type;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];

}

- (void)selectAllByMac:(NSString *)mac Block:(void (^)(NSArray<FMDB_DeviceInfo *> *))blockAll{

    if (mac.length == 0) {
        NSLog(@"fmdb selectAll can`t select nil mac !");
        if (blockAll) {
            blockAll(nil);
        }
        return ;
    }

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {

        //查询整个表
        FMResultSet *resultSet = [db executeQuery:
                                  @"select * from DeviceInfo_Table "
                                  "where mac=?;"
                                  ,mac];

        NSMutableArray *objects = [NSMutableArray array];
        //遍历结果集合
        while ([resultSet  next])
        {
            int idNum = [resultSet intForColumn:@"id"];
            float lstp = [resultSet doubleForColumn:@"lessTemper"];
            float ovtp = [resultSet doubleForColumn:@"overTemper"];
            float lshm = [resultSet doubleForColumn:@"lessHumidi"];
            float ovhm = [resultSet doubleForColumn:@"overHumidi"];
            bool warn = [resultSet boolForColumn:@"isWarn"];
            NSString *mac = [resultSet stringForColumn:@"mac"];
            NSTimeInterval timetp = [resultSet doubleForColumn:@"tempTime"];
            NSTimeInterval timehm = [resultSet doubleForColumn:@"humiTime"];
            NSString *name = [resultSet stringForColumn:@"dbName"];
            int type = [resultSet intForColumn:@"devType"];

            FMDB_DeviceInfo *objc = [[FMDB_DeviceInfo alloc]init];
            objc.lessTemper = lstp;
            objc.overTemper = ovtp;
            objc.lessHumidi = lshm;
            objc.overHumidi = ovhm;
            objc.devID = idNum;
            objc.isWarn = warn;
            objc.mac = mac;
            objc.tempTime = timetp;
            objc.humiTime = timehm;
            objc.dbName = name;
            objc.devType = type;

            [objects addObject:objc];
        }
        if (blockAll) {
            blockAll(objects);
        }

    }];
    
}


@end
