//
//  AFManager+SelectDataOfDevice.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+SelectDataOfDevice.h"

@implementation AFManager (SelectDataOfDevice)

- (void)selectLastDataOfDevice:(int)uid Mac:(NSString *)mac{
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/app/sensordb_query_ex.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(uid),
                             @"tmac":mac,
                             @"nio":@"yes",
                             @"start":@"0",
                             @"end":@"1",
                             @"pwd":@"12345678"};
    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        LRLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"%@",error);
    }];
}

- (void)selectDataOfDevice:(int)uid Mac:(nonnull NSString *)mac{
    
    // /aircondition/app/sensordb_query_ex.jsp?uid=&tmac=&pwd=&starttime=&endtime=&nio=yes&start=0&end=720
    // /aircondition/app/sensordb_query_ex.jsp?uid=
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/app/sensordb_query_ex.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(uid),
                             @"tmac":mac,
                             @"nio":@"yes",
                             @"start":@(0),
                             @"end":@(72),
                             @"pwd":@"12345678"};
    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        LRLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
//        LRLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"%@",error);
    }];
//    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        LRLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
//        LRLog(@"%@",dic);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        LRLog(@"%@",error);
//    }];
}

//http://www.easyhomeai.com:8080/aircondition/app/sensordb_query_ex.jsp?uid=5&tmac=DB59655E25C8&nio=yes&start=0&end=720&pwd=12345678

//http://www.easyhomeai.com:8080/aircondition/app/sensordb_query_ex.jsp?uid=5&tmac=CA1C86E4EB90&nio=yes&start=0&end=720&pwd=12345678

//http://www.easyhomeai.com:8080/aircondition/app/sensordb_query_ex.jsp?uid=5&tmac=CF1206168A6D&nio=yes&start=0&end=720&pwd=12345678

@end
