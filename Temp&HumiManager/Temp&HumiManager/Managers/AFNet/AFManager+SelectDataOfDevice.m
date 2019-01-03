//
//  AFManager+SelectDataOfDevice.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+SelectDataOfDevice.h"

@implementation AFManager (SelectDataOfDevice)

- (void)selectLastDataOfDevice:(int)uid Mac:(NSString *)mac Block:(nonnull void (^)(NSString *))block{
    
    if (mac == nil) {
        LRLog(@"mac为空！不能查询！");
        return ;
    }
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/app/sensordb_query_ex.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(uid),
                             @"tmac":mac,
                             @"nio":@"yes",
                             @"start":@"0",
                             @"end":@"1",
                             @"pwd":@"12345678"};
    
    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        if (block) {
            block(dic[@"data"][@"da"]);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"%@",error);
        if (block) {
            block(nil);
        }
    }];
}

- (void)selectDataOfDevice:(int)uid Mac:(nonnull NSString *)mac SIndex:(int)sindex EIndex:(int)eindex Result:(nonnull void (^)(NSArray<DeviceInfo *> * _Nonnull))result{
    
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/app/sensordb_query_ex.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(uid),
                             @"tmac":mac,
                             @"nio":@"yes",
                             @"start":@(sindex),
                             @"end":@(eindex),
                             @"pwd":@"12345678"};
        
    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        LRLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        NSArray * datas = dic[@"data"];
        NSMutableArray * marr = [NSMutableArray array];
        for (NSDictionary *dd in datas) {
            DeviceInfo * dev = [[DeviceInfo alloc]init];
            dev.sdata = dd[@"da"];
            dev.utime = [dd[@"time"] doubleValue];
            [marr addObject:dev];
        }
        if (result) {
            result(marr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"%@",error);
    }];
}


//http://www.easyhomeai.com:8080/aircondition/app/sensordb_query_ex.jsp?uid=5&tmac=DB59655E25C8&nio=yes&start=0&end=720&pwd=12345678

//http://www.easyhomeai.com:8080/aircondition/app/sensordb_query_ex.jsp?uid=5&tmac=CA1C86E4EB90&nio=yes&start=0&end=720&pwd=12345678

//http://www.easyhomeai.com:8080/aircondition/app/sensordb_query_ex.jsp?uid=5&tmac=CF1206168A6D&nio=yes&start=0&end=720&pwd=12345678

@end
