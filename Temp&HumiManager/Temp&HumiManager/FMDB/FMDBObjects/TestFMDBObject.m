//
//  TestFMDBObject.m
//  TestAll
//
//  Created by terry on 2018/5/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "TestFMDBObject.h"

@interface TestFMDBObject ()

@property (nonatomic,assign,readwrite)int testID;

@end

@implementation TestFMDBObject

- (instancetype)initDatabase{
    if (self = [super init]) {
        [self createTable];
    }
    return self;
}

- (void)createTable{

    //2.获得数据库
//    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([self.database open])
    {
        //4.创表(此处必须用纯字符串形式)
        BOOL result = [self.database executeUpdate:
                       @"CREATE TABLE IF NOT EXISTS test_table "
                       "(id integer PRIMARY KEY AUTOINCREMENT, "
                       "name text NOT NULL, "
                       "date date NOT NULL, "
                       "sex integer NOT NULL, "
                       "height double NOT NULL);"];
        if (result)
        {
//            NSLog(@"创建表成功");
        }
        else
        {
            NSLog(@"create FMDB Table:test_table fail");
        }
    }
    else
    {
        NSLog(@"open fail");
    }
}

- (void)insert{

//    __weak typeof(self) weakself = self;
//    [[TestFMDBObject sharedInstance]  queueDatabase:^(FMDatabase *db, BOOL *rollback) {
//
//        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
//        [db executeUpdate:
//         @"INSERT INTO "
//         "test_table (name, date, sex, height) "
//         "VALUES (?,?,?,?);"
//         ,weakself.testName,weakself.testDate,@(weakself.sex),@(weakself.height)];
//
//    }];


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

- (void)deletes{

//    __weak typeof(self) weakself = self;
//    [[FMDB_HitoryRecord sharedInstance]  queueDatabase:^(FMDatabase *db, BOOL *rollback) {
//
//        //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
//        [db executeUpdate:@"delete from test_table where id = ?;",(weakself.testID)];
//
//    }];


//
//    //2.不确定的参数用%@，%d等来占位
//    [self.database executeUpdateWithFormat:@"delete from test_table where name = %@;",self.testName];
}

- (void)update{

//    __weak typeof(self) weakself = self;
//    [[FMDB_HitoryRecord sharedInstance] queueDatabase:^(FMDatabase *db, BOOL *rollback) {
//
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
//
//    }];


}

- (void)updateName{

//    __weak typeof(self) weakself = self;
//    [TestFMDBObject queueDatabase:^(FMDatabase *db, BOOL *rollback) {
//
//        [db executeUpdate:
//         @"update test_table "
//         "set name = ? "
//         "where id = ?"
//         ,weakself.testName,weakself.testName];
//
//    }];

}

+ (void)selectWithHeight:(float)height Block:(void(^)(NSArray <TestFMDBObject *>*))blockAll{

//    [TestFMDBObject queueDatabase:^(FMDatabase *db, BOOL *rollback) {
//
//        //根据条件查询
//        FMResultSet *resultSet = [db executeQuery:
//                                  @"select * from test_table "
//                                  "where height=?;",@(height)];
//        NSMutableArray *objects = [NSMutableArray array];
//        //遍历结果集合
//        while ([resultSet  next])
//        {
//            int idNum = [resultSet intForColumn:@"id"];
//            NSString *name = [resultSet objectForColumn:@"name"];
//            NSDate *date = [resultSet dateForColumn:@"date"];
//            bool sex = [resultSet boolForColumn:@"sex"];
//            float height = [resultSet doubleForColumn:@"height"];
//            [resultSet dateForColumn:@""];
//            TestFMDBObject *objc = [[TestFMDBObject alloc]init];
//            objc.testName = name;
//            objc.testID = idNum;
//            objc.testDate = date;
//            objc.sex = sex;
//            objc.height = height;
//            [objects addObject:objc];
//        }
//        if (blockAll) {
//            blockAll(objects);
//        }
//    }];
}

+ (void)selectAll:(void(^)(NSArray <TestFMDBObject *>*))blockAll{

//    [TestFMDBObject queueDatabase:^(FMDatabase *db, BOOL *rollback) {
//
//        //查询整个表
//        FMResultSet *resultSet = [db executeQuery:@"select * from test_table;"];
//
//        //    //根据条件查询
//        //    FMResultSet *resultSet = [self.database executeQuery:@"select * from test_table where id<?;",@(self.testID)];
//
//
//        NSMutableArray *objects = [NSMutableArray array];
//        //遍历结果集合
//        while ([resultSet  next])
//        {
//            int idNum = [resultSet intForColumn:@"id"];
//            NSString *name = [resultSet objectForColumn:@"name"];
//            NSDate *date = [resultSet dateForColumn:@"date"];
//            bool sex = [resultSet boolForColumn:@"sex"];
//            float height = [resultSet doubleForColumn:@"height"];
//            TestFMDBObject *objc = [[TestFMDBObject alloc]init];
//            objc.testName = name;
//            objc.testID = idNum;
//            objc.testDate = date;
//            objc.sex = sex;
//            objc.height = height;
//            [objects addObject:objc];
//        }
//        if (blockAll) {
//            blockAll(objects);
//        }
//
//    }];

}


- (void)drop{
    //如果表格存在 则销毁
    [self.database executeUpdate:@"drop table if exists test_table;"];
}


@end
