//
//  AFManager+AFAutoRegister.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+AFAutoRegister.h"

@implementation AFManager (AFAutoRegister)

- (void)autoFirstRegistUser:(void (^)(bool, NSString *))block{
    
    LRWeakSelf(self);
    
    NSString *uid = [[NSUUID UUID] UUIDString];
    //获取所有信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *projName = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey]; //获取项目名称
    NSString *showName = [NSString stringWithFormat:@"%@_%@",uid,projName];
    NSString *pwd = uid;
    
    NSString *strURL=[NSString stringWithFormat:@"http://%@:%@/aircondition/app/autoreg.jsp?auid=%@&showname=%@&pwd=%@",TH_IP,TH_PORT,uid,showName,pwd];
    
    LRLog(@"%@",strURL);
    
    [self.sessionManager GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData * data = responseObject;
        NSString *strCode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([strCode containsString:@"<cod>0</cod"]) {
            [weakself loginUserWithUname:uid Pwd:pwd Block:block];
        } else{
            if (block) {
                block(false,@"自动注册失败！");
            }
            LRLog(@"%@",strCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(false,error.description);
        }
    }];
    
}

/**
 登录(登录成功会保存信息至本地)

 @param uname 用户名
 @param pwd 密码
 */
- (void)loginUserWithUname:(NSString *)uname Pwd:(NSString *)pwd Block:(void(^)(bool suc,NSString * info))block{
        
    NSString *strURL=[NSString stringWithFormat:@"http://%@:%@/aircondition/devcheck.jsp?devname=%@&pwd=%@&phonenumber=%@",TH_IP,TH_PORT,uname,pwd,uname];
    NSLog(@"%@",strURL);
    [self.sessionManager GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData * data = responseObject;
        NSString *strCode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        if ([strCode containsString:@"<cod>0</cod>"]) {
            UserInfo *user = [[UserInfo alloc]init];
            user.uid = [[strCode getStringBetweenFormerString:@"<uid>" AndLaterString:@"</uid>"] intValue];
            user.uname = uname;
            user.upwd = pwd;
            user.isLogin = true;
            [[MyDefaultManager sharedInstance] saveUser:user];
            
            if (block) {
                block(true,@"自动注册并保存成功！");
            }
        } else{
            if (block) {
                block(false,[NSString stringWithFormat:@"自动注册，尝试登录时失败！%@",strCode]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LRLog(@"登录请求错误！%@",error.description);
    }];
    
}

@end
