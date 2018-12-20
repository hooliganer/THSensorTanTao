//
//  HTTP_Manager.m
//  Hoologaner
//
//  Created by terry on 2018/1/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"

NSString * APPIP_KEY = @"www.easyhomeai.com";//www.puxuntech.com
NSString * APPPORT_KEY = @"8080";

@implementation HTTP_Manager

- (NSMutableDictionary *)dataSets{
    if (_dataSets == nil) {
        _dataSets = [NSMutableDictionary dictionary];
    }
    return _dataSets;
}

/**
 * 解析网络error的userinfo 和 code信息返回错误具体信息
 */
- (NSString *)getHttpWithCode:(NSUInteger)code UserInfo:(NSString *)userinfo{

    NSString *string;
    switch (code) {
        case -1009:
            string = @"请检查网络是否打开!";
            break;

        default:
            string = userinfo;
            break;
    }

    LRLog(@"%@",userinfo);
    return string;
}

- (void)queryWithURLString:(NSString *)urlString Block:(void (^)(NSData *, NSURLResponse *, NSError *))block{

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sesTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        if (block) {
            block(data,response,error);
        }
        

    }];
    [sesTask resume];
}

- (void)queryURLString:(NSString *)urlStr Block:(void (^)(NSData *))block{

    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sestask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error){
            NSDictionary *dic = error.userInfo;
            NSString *str = [dic valueForKey:@"NSLocalizedDescription"];
            str = [self getHttpWithCode:error.code UserInfo:str];
            LRLog(@"%@",error.description);
            if (self.didGetError) {
                self.didGetError(str);
            }
        }
        else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode==200 || httpResponse.statusCode==304){
                if (block) {
                    block(data);
                }
            } else{
                NSString *strCode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"服务器内部错误:%@",strCode);
                if (self.didGetError) {
                    self.didGetError([NSString stringWithFormat:@"服务器内部错误:%@",strCode]);
                }
            }
        }
    }];
    [sestask resume];

}

@end
