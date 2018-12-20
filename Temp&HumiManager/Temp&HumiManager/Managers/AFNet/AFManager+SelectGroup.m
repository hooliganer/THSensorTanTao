//
//  AFManager+SelectGroup.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/17.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AFManager+SelectGroup.h"
#import "UserInfo.h"

@implementation AFManager (SelectGroup)

- (void)selectGroupOfUser:(void (^)(NSArray<TH_GroupInfo *> *))block{

    //http://%@:%@/aircondition/group/group_query.jsp?uid=%d&pwd=%@
    UserInfo * user = [MyDefaultManager userInfo];
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/group/group_query.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(user.uid),
                             @"pwd":user.upwd};

    [self.sessionManager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        NSArray * groups = [dic valueForKey:@"group"];
        NSMutableArray <TH_GroupInfo *>* marr = [NSMutableArray array];
        for (NSDictionary * dic in groups) {
            TH_GroupInfo * group = [[TH_GroupInfo alloc]init];
            group.mac = [dic valueForKey:@"name"];
            group.dateline = [[dic valueForKey:@"dateline"] doubleValue];
            group.name = [dic valueForKey:@"desc"];
            group.gid = [[dic valueForKey:@"id"] intValue];
            group.mCount = [[dic valueForKey:@"mcount"] intValue];
            group.online = [[dic valueForKey:@"online"] boolValue];
            group.state = [[dic valueForKey:@"state"] intValue];
            group.type = [[dic valueForKey:@"type"] intValue];
            [marr addObject:group];
        }
        if (block) {
            block(marr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
