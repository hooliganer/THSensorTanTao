//
//  AFManager+SelectDataOfDevice.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+SelectDataOfDevice.h"

@implementation AFManager (SelectDataOfDevice)

- (void)selectDataOfDevice:(int)uid Mac:(nonnull NSString *)mac{
    // /aircondition/app/sensordb_query_ex.jsp?uid=
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/app/sensordb_query_ex.jsp?uid=%d&mac=%@",TH_IP,TH_PORT,uid,mac];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LRLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
//        LRLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"%@",error);
    }];
}

@end
