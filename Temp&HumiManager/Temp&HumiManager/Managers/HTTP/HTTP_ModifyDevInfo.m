//
//  HTTP_ModifyDevInfo.m
//  Temp&HumiManager
//
//  Created by terry on 2018/4/1.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_ModifyDevInfo.h"

@implementation HTTP_ModifyDevInfo


+ (HTTP_ModifyDevInfo *)sharedInstance{
    static HTTP_ModifyDevInfo *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTP_ModifyDevInfo alloc]init];
    });
    return manager;
}

- (void)setDevType:(int)type Uid:(int)uid Mac:(NSString *)mac Block:(void (^)(bool, NSString *))block{

//    __weak typeof(self) weakself = self;
    NSString *strURL=[NSString stringWithFormat:
                      @"http://%@:%@/aircondition/app/set_dev_info.jsp"
                      "?uid=%d"
                      "&opertype=%@"
                      "&motostep=%d"
                      "&mac=%@"
                      "&pwd=%@"
                      ,APPIP_KEY,APPPORT_KEY,uid,@"setmotostep",type,mac,@"123456"];
    NSLog(@"%@",strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sesTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        if (error) {
            NSDictionary *dic=error.userInfo;
            NSString *str=[dic valueForKey:@"NSLocalizedDescription"];
            str=[self getHttpWithCode:error.code UserInfo:str];
            NSLog(@"%@",str);

        }else{
            NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",strCode);
            if ([strCode containsString:@"<cod>0</cod>"]) {

            } else{

            }
        }

    }];
    [sesTask resume];
}


- (void)setDevName:(NSString *)name Uid:(int)uid Mac:(NSString *)mac Block:(void (^)(bool, NSString *))block{

//    "http://"  + GlobalVarData.PX_PROD_FD_SERVER + ":" + GlobalVarData.PX_PROD_FD_SERVER_PORT
//    + "/aircondition/app/set_dev_info.jsp?"
//    +"mac="+GlobalVarData.gCurOperDev.getUserName()
//    +"&opertype=rename"
//    +"&uid="+ GlobalVarData.gCurUserId
//    +"&pwd=123456"
//    +"&showname="+strGroupName
//    +"&encode=utf-8"

    //    __weak typeof(self) weakself = self;
    NSString *strURL=[NSString stringWithFormat:
                      @"http://%@:%@/aircondition/app/set_dev_info.jsp"
                      "?mac=%@"
                      "&opertype=%@"
                      "&uid=%d"
                      "&pwd=%@"
                      "&showname=%@"
                      "&encode=%@"
                      ,APPIP_KEY,APPPORT_KEY,mac,@"rename",uid,@"123456",name,@"utf-8"];
    NSLog(@"%@",strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sesTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        if (error) {
            NSDictionary *dic=error.userInfo;
            NSString *str=[dic valueForKey:@"NSLocalizedDescription"];
            str=[self getHttpWithCode:error.code UserInfo:str];
            NSLog(@"%@",str);

        }else{
//            NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",strCode);
//            if ([strCode containsString:@"<cod>0</cod>"]) {
//
//            } else{
//
//            }
        }

    }];
    [sesTask resume];
}



@end
