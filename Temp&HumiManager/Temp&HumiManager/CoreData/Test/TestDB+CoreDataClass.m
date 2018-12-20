//
//  TestDB+CoreDataClass.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import "TestDB+CoreDataClass.h"
#import "DBManager.h"

@implementation TestDB

+ (TestDB *)newTest{
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    TestDB * test = [NSEntityDescription insertNewObjectForEntityForName:@"TestDB" inManagedObjectContext:context];
    return test;
}

- (void)insert{
    //保存插入的数据
    NSError *error = nil;
    if (![[DBManager shareInstance].managedObjectContext save:&error]) {
        NSLog(@"保存testdb失败!%@",error);
    }
}

- (void)delete{

    //创建删除请求
    NSFetchRequest *deleRequest = [TestDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;

    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", self.name];
    deleRequest.predicate = pre;

    //返回需要删除的对象数组
    NSArray *deleArray = [context executeFetchRequest:deleRequest error:nil];

    //从数据库中删除
    for (TestDB *db in deleArray) {
        [context deleteObject:db];
    }

    NSError *error = nil;
    //保存--记住保存
    if (![context save:&error]) {
        NSLog(@"删除数据失败, %@", error);
    }

}

+ (TestDB *)readByName:(NSString *)name{
    //创建查询请求
    NSFetchRequest *request = [TestDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", name];
    request.predicate = pre;

    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;

    //发送查询请求
    NSArray <TestDB *>* results = [context executeFetchRequest:request error:nil];
    return results.firstObject;
}

- (void)update{

    //创建查询请求
    NSFetchRequest *request = [TestDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", self.name];
    request.predicate = pre;

    //发送请求
    NSArray *resArray = [context executeFetchRequest:request error:nil];

    //修改
    for (TestDB *db in resArray) {
        db.name = self.name;
    }

    //保存
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"更新数据失败, %@", error);
    }

}








@end
