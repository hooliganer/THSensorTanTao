//
//  DeviceDB+CoreDataClass.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
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

- (void)insert{
    if (self.mac == nil) {
        NSLog(@"不能保存空Mac！");
        return ;
    }
    //保存插入的数据
    NSError *error = nil;
    if (![[DBManager shareInstance].managedObjectContext save:&error]) {
        NSLog(@"保存 %@ 失败!%@",self.mac,error);
    }
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

@end
