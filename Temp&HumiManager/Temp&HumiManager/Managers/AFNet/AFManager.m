//
//  AFManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/17.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AFManager.h"

@implementation AFManager

+ (AFManager *)shared{
    static AFManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFManager alloc]init];
    });
    return manager;
}

- (AFHTTPSessionManager *)sessionManager{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30;
        // 声明上传的是json格式的参数
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}


- (void)fakeLoad{


    for (int i=0; i<200; i++) {
        [self.sessionManager GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%d",i);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%d",i);
        }];
    }

//    for (int i=0; i<30; i++) {
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//        dispatch_async(queue, ^{
//            [self loadParam:i Block:^(int param) {
//                NSLog(@"load finish - %d",param);
//            }];
//        });
//    }

}

- (void)loadParam:(int)p Block:(void(^)(int param))block{
    [self.sessionManager GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(p);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(p);
    }];

}

- (void)getSameRequest:(NSString *)url WithCount:(int)count ByParam:(NSArray <NSDictionary *>*)params OtherParam:(NSDictionary *)otherParam{

    NSMutableArray * datas = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t group = dispatch_group_create();

    for (int i=0; i<count; i++) {

        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:otherParam];
        NSDictionary * param = params[i];
        [mdic setValuesForKeysWithDictionary:param];

        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{

            [self.sessionManager GET:url parameters:mdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                [datas addObject:responseObject];
                dispatch_group_leave(group);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                dispatch_group_leave(group);
            }];
        });
    }
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify");
    });
}

- (void)selectMembersOfGroupWithGid:(int)gid Block:(void (^)(void))block{

    UserInfo * user = [MyDefaultManager userInfo];

    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/group/group_dev_query.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(user.uid),
                             @"gid":@(gid),
                             @"data":@"yes",
                             @"nio":@"yes"};

    [self.sessionManager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (block) {
            block();
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];


}

@end
