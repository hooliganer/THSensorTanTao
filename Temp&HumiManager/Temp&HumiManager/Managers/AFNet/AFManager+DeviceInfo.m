//
//  AFManager+DeviceInfo.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/26.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+DeviceInfo.h"

@implementation AFManager (DeviceInfo)

- (void)setDeviceName:(NSString *)name Mac:(NSString *)mac Uid:(int)uid Result:(nonnull void (^)(bool, NSString * _Nonnull))result{
    
    name = [name getUTF8String];
    NSString * url = [NSString stringWithFormat:
                      @"http://%@:%@/aircondition/app/set_dev_info.jsp"
                      "?mac=%@"
                      "&opertype=%@"
                      "&uid=%d"
                      "&pwd=%@"
                      "&showname=%@"
                      "&encode=%@"
                      ,TH_IP,TH_PORT,mac,@"rename",uid,@"12345678",name,@"utf-8"];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        int code = [dic[@"cod"] intValue];
        NSString * desc = dic[@"desc"];
        if (result) {
            result(code == 0,desc);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (result) {
            result(false,error.description);
        }
    }];
}

- (void)setDeviceType:(int)type Mac:(NSString *)mac Uid:(int)uid Result:(nonnull void (^)(bool, NSString * _Nonnull))result{
    NSString * url = [NSString stringWithFormat:
                      @"http://%@:%@/aircondition/app/set_dev_info.jsp"
                      "?uid=%d"
                      "&opertype=%@"
                      "&motostep=%d"
                      "&mac=%@"
                      "&pwd=%@"
                      ,TH_IP,TH_PORT,uid,@"setmotostep",type,mac,@"12345678"];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        int code = [dic[@"cod"] intValue];
        NSString * desc = dic[@"desc"];
        if (result) {
            result(code == 0,desc);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (result) {
            result(false,error.description);
        }
    }];
}

@end
