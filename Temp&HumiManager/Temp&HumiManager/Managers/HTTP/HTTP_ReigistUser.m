//
//  HTTP_ReigistUser.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/29.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_ReigistUser.h"

@interface HTTP_ReigistUser ()

@property (nonatomic,strong)void(^didAutoReigist)(bool,NSString *);

@end

@implementation HTTP_ReigistUser

+ (HTTP_ReigistUser *)sharedInstance{
    static HTTP_ReigistUser *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTP_ReigistUser alloc]init];
    });
    return manager;
}

- (void)autoFirstRegistUser:(void (^)(bool, NSString *))block{

    self.didAutoReigist = block;

    LRWeakSelf(self);

    NSString *uid = [[NSUUID UUID] UUIDString];
    //获取所有信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *projName = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey]; //获取项目名称
    NSString *showName = [NSString stringWithFormat:@"%@_%@",uid,projName];
    NSString *pwd = uid;

    NSString *strURL=[NSString stringWithFormat:@"http://%@:%@/aircondition/app/autoreg.jsp?auid=%@&showname=%@&pwd=%@",APPIP_KEY,APPPORT_KEY,uid,showName,pwd];
    NSLog(@"%@",strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sesTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        if (error) {
            NSString *str = error.localizedDescription;
            str = [weakself getHttpWithCode:error.code UserInfo:str];
            NSLog(@"%@",str);

        }else{
            NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",strCode);
            if ([strCode containsString:@"<cod>0</cod"]) {
                [weakself loginUserWithUname:uid Pwd:pwd];
            } else{
                if (weakself.didAutoReigist) {
                    weakself.didAutoReigist(false, @"Auto Regist Fail !");
                }
            }
        }

    }];
    [sesTask resume];
}

- (void)loginUserWithUname:(NSString *)uname Pwd:(NSString *)pwd{

    LRWeakSelf(self);

    NSString *strURL=[NSString stringWithFormat:@"http://%@:%@/aircondition/devcheck.jsp?devname=%@&pwd=%@&phonenumber=%@",APPIP_KEY,APPPORT_KEY,uname,pwd,uname];
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
//            NSLog(@"%@",strCode);
            if ([strCode containsString:@"<cod>0</cod>"]) {
                UserInfo *user = [[UserInfo alloc]init];
                user.uid = [[strCode getStringBetweenFormerString:@"<uid>" AndLaterString:@"</uid>"] intValue];
                user.uname = uname;
                user.upwd = pwd;
                user.isLogin = true;
                [[MyDefaultManager sharedInstance] saveUser:user];

                if (weakself.didAutoReigist) {
                    weakself.didAutoReigist(true, @"Auto Regist Success !");
                }
                
            } else{
                if (weakself.didAutoReigist) {
                    weakself.didAutoReigist(false, @"Auto Regist Fail !");
                }
            }
        }

    }];
    [sesTask resume];
}

@end
