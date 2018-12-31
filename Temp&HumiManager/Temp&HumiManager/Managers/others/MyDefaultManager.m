//
//  MyDefaultManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyDefaultManager.h"
#import "OBJCManager.h"

@implementation MyDefaultManager

+ (MyDefaultManager *)sharedInstance{
    static MyDefaultManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyDefaultManager alloc]init];
    });
    return manager;
}

+ (UserInfo *)userInfo{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserInfo"];

    UserInfo *user ;
    if (dic) {
        user = [[UserInfo alloc]init];
        user.uid = [dic[@"uid"] intValue];
        user.uname = dic[@"uname"];
        user.upwd = dic[@"upwd"];
        user.isLogin = [dic[@"isLogin"] boolValue];
//        user.uname = @"b0:df:c1:6d:09:60";
//        user.upwd = @"b0:df:c1:6d:09:60px";
//        user.uid = 5;
    }
    return user;
}

+ (NSString *)unit{
    NSString * value = [[NSUserDefaults standardUserDefaults] stringForKey:@"TemparatureUnit"];
    if (value) {
        return value;
    }
    return @"˚C";
}

+ (void)saveUnit:(NSString *)unit{
    [[NSUserDefaults standardUserDefaults] setObject:unit forKey:@"TemparatureUnit"];
}

- (UserInfo *)readUser{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserInfo"];

    UserInfo *user ;
    if (dic) {
        user = [[UserInfo alloc]init];
        user.uid = [dic[@"uid"] intValue];
        user.uname = dic[@"uname"];
        user.upwd = dic[@"upwd"];
        user.isLogin = [dic[@"isLogin"] boolValue];
        user.uname = dic[@"uname"];//@"b0:df:c1:6d:09:60";
        user.upwd = dic[@"upwd"];//@"b0:df:c1:6d:09:60px";
        user.uid = [dic[@"uid"] intValue];//5;
    }
    user.uname = @"b0:df:c1:6d:09:60";
    user.upwd = @"b0:df:c1:6d:09:60px";
    user.uid = 5;
    return user;
}

- (void)saveUser:(UserInfo *)user{
    NSDictionary *dic = [[OBJCManager sharedInstance] getDictionaryWithObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"UserInfo"];
}



- (void)saveGlobalInfo:(APPGlobalObject *)gobc{
    NSDictionary *dic = [[OBJCManager sharedInstance] getDictionaryWithObject:gobc];
//    NSLog(@"%@",dic);
//    NSLog(@"%@",dic[@"devIsAlert"]);
//    NSLog(@"%@",dic[@"devLmtValue"]);
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"GolbalInfo"];

    
}

- (APPGlobalObject *)readGlobalInfo{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"GolbalInfo"];
    APPGlobalObject *info;
    if (dic) {
        info = [[APPGlobalObject alloc]init];
        info.wifiName = dic[@"wifiName"];
        info.wifiPwd = dic[@"wifiPwd"];
        info.unitType = [dic[@"unitType"] boolValue];
        info.closeSec = [dic[@"closeSec"] intValue];
        info.closeMin = [dic[@"closeMin"] intValue];
//        info.devIsAlert = dic[@"devIsAlert"];
//        info.devLmtValue = dic[@"devLmtValue"];
    }
    return info;
}


+ (void)setAutoRegsiterTime:(NSTimeInterval)interval{
    [[NSUserDefaults standardUserDefaults] setDouble:interval forKey:@"AutoRegisterTime"];
}

+ (NSTimeInterval)readAutoRegsiterDate{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"AutoRegisterTime"];
}

@end
