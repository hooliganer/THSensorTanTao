//
//  DeviceDB+CoreDataClass.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "DeviceDB+CoreDataClass.h"
#import "DBManager.h"


@implementation DeviceDB

+ (DeviceDB *)newDevice{
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    DeviceDB * db = [NSEntityDescription insertNewObjectForEntityForName:@"DeviceDB" inManagedObjectContext:context];
    return db;
}


+ (DeviceDB *)readBymac:(NSString *)mac{
    //创建查询请求
    NSFetchRequest *request = [DeviceDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"mac = %@", mac];
    request.predicate = pre;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray <DeviceDB *>* results = [context executeFetchRequest:request error:nil];
    return results.firstObject;
}

+ (void)deleteAll{
    
    //创建删除请求
    NSFetchRequest *deleRequest = [DeviceDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (DeviceDB *db in deleArray) {
        [context deleteObject:db];
    }
    
    NSError *error = nil;
    //保存--记住保存
    if (![context save:&error]) {
        NSLog(@"删除数据失败, %@", error);
    }
}

+ (void)deleteByMac:(NSString *)mac{
    
    //创建删除请求
    NSFetchRequest *deleRequest = [DeviceDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    //条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"mac = %@", mac];
    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (DeviceDB *db in deleArray) {
        [context deleteObject:db];
    }
    
    NSError *error = nil;
    //保存--记住保存
    if (![context save:&error]) {
        NSLog(@"删除数据失败, %@", error);
    }
}

+ (NSArray <DeviceDB *>*)readAll{
    //创建查询请求
    NSFetchRequest *request = [DeviceDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray <DeviceDB *>* results = [context executeFetchRequest:request error:nil];
    return results;
}

- (void)save{
    //保存插入的数据
    NSError *error = nil;
    if (![[DBManager shareInstance].managedObjectContext save:&error]) {
        NSLog(@"保存 %@ 失败!%@",self.mac,error);
    }
}


@end
