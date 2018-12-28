//
//  WarnConfirm+CoreDataClass.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/28.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnConfirm+CoreDataClass.h"
#import "DBManager.h"

@implementation WarnConfirm

+ (WarnConfirm *)newWarnConfirm{
    NSManagedObjectContext * context = [DBManager shareInstance].managedObjectContext;
    WarnConfirm * db = [NSEntityDescription insertNewObjectForEntityForName:@"WarnConfirm" inManagedObjectContext:context];
    return db;
}

+ (WarnConfirm *)readByMac:(NSString *)mac{
    
    //创建查询请求
    NSFetchRequest *request = [WarnConfirm fetchRequest];
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
    NSArray <WarnConfirm *>* results = [context executeFetchRequest:request error:nil];
    return results.firstObject;
}

- (void)save{
    //保存插入的数据
    NSError *error = nil;
    if (![[DBManager shareInstance].managedObjectContext save:&error]) {
        NSLog(@"保存 %@ 失败!%@",self.mac,error);
    }
}
@end
