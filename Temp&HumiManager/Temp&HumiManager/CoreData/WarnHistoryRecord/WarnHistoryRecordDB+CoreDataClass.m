//
//  WarnHistoryRecordDB+CoreDataClass.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnHistoryRecordDB+CoreDataClass.h"
#import "DBManager.h"
#import <objc/runtime.h>

@implementation WarnHistoryRecordDB

+ (WarnHistoryRecordDB *)newWarnHistoryRecord{
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    WarnHistoryRecordDB * db = [NSEntityDescription insertNewObjectForEntityForName:@"WarnHistoryRecordDB" inManagedObjectContext:context];
    return db;
}


+ (WarnHistoryRecordDB *)readByTime:(NSTimeInterval)time{
    //创建查询请求
    NSFetchRequest *request = [WarnHistoryRecordDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"time = %f", time];
    request.predicate = pre;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray <WarnHistoryRecordDB *>* results = [context executeFetchRequest:request error:nil];
    return results.firstObject;
}

+ (void)deleteAll{
    
    //创建删除请求
    NSFetchRequest *deleRequest = [WarnHistoryRecordDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (WarnHistoryRecordDB *db in deleArray) {
        [context deleteObject:db];
    }
    
    NSError *error = nil;
    //保存--记住保存
    if (![context save:&error]) {
        NSLog(@"删除数据失败, %@", error);
    }
}

+ (NSArray <WarnHistoryRecordDB *>*)readAll{
    
    //创建查询请求
    NSFetchRequest *request = [WarnHistoryRecordDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray <WarnHistoryRecordDB *>* results = [context executeFetchRequest:request error:nil];
    return results;
}

+ (NSArray<WarnHistoryRecordDB *> *)readAllByMac:(NSString *)mac{
    
    //创建查询请求
    NSFetchRequest *request = [WarnHistoryRecordDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    //条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mac = %@",mac];
    request.predicate = predicate;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray <WarnHistoryRecordDB *>* results = [context executeFetchRequest:request error:nil];
    return results;
}

+ (NSArray<WarnHistoryRecordDB *> *)readAllByMac:(NSString *)mac Time:(NSTimeInterval)time{
    
    //创建查询请求
    NSFetchRequest *request = [WarnHistoryRecordDB fetchRequest];
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    
    //条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mac = %@ and time = %f",mac,time];
    request.predicate = predicate;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray <WarnHistoryRecordDB *>* results = [context executeFetchRequest:request error:nil];
    return results;
}

- (void)save{
    //保存插入的数据
    NSError *error = nil;
    if (![[DBManager shareInstance].managedObjectContext save:&error]) {
        NSLog(@"保存 %@ 失败!%@",self.mac,error);
    }
}

+ (void)logAll{
    NSArray * all = [WarnHistoryRecordDB readAll];
    for (WarnHistoryRecordDB *whd in all) {
        [WarnHistoryRecordDB logObject:whd];
    }
}

+ (void)logObject:(id)objc{
    
    unsigned int count ,i;
    objc_property_t *propertyArray = class_copyPropertyList([objc class], &count);
    NSMutableString * mstr = @"{ \n".mutableCopy;
    
    for (i = 0; i < count; i++) {
        objc_property_t property = propertyArray[i];
        NSString * key = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id value = [objc valueForKey:key];
        [mstr appendFormat:@"%@ - %@ \n",key,value];
    }
    [mstr appendFormat:@"\n }"];
    LRLog(@"%@",mstr);
}

@end
