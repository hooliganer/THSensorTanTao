//
//  AFManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/17.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AFManager.h"

@interface AFManager ()


@end

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

- (void)fakeLoadQueue:(dispatch_queue_t)queue Block:(void (^)(void))block{
    
    int time = arc4random() % 3 + 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), queue, ^{
        block();
    });
}


- (void)fakeLoad{

    

//    for (int i=0; i<200; i++) {
//        [self.sessionManager GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%d",i);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%d",i);
//        }];
//    }

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

- (void)selectMembersOfGroupWithGid:(int)gid Block:(void (^)(NSArray<DeviceInfo *> *))block Fail:(void (^)(NSError *))fail{

    UserInfo * user = [MyDefaultManager userInfo];

    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/group/group_dev_query.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"uid":@(user.uid),
                             @"gid":@(gid),
                             @"data":@"yes",
                             @"nio":@"yes"};

    LRWeakSelf(self);
    [self.sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
//        LRLog(@"%@",dic);
        id dev = [dic valueForKey:@"dev"];
        if (!dev) {
            return ;
        }
        NSMutableArray <DeviceInfo *>* devs = [NSMutableArray array];
        if ([dev isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dd in dev) {
                DeviceInfo * device = [weakself deviceWithDic:dd];
                [devs addObject:device];
            }
        } else if ([dev isKindOfClass:[NSDictionary class]]){
            DeviceInfo * device = [weakself deviceWithDic:dev];
            [devs addObject:device];
        } else {
            LRLog(@"未识别字段“dev”:%@",dev);
        }
        if (block) {
            block(devs);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];

}

- (DeviceInfo *)deviceWithDic:(NSDictionary *)dic{

    DeviceInfo * dev = [[DeviceInfo alloc]init];
    dev.dateline = [[dic valueForKey:@"dateline"] doubleValue];
    dev.dID = [[dic valueForKey:@"did"] intValue];
    dev.dType = [[dic valueForKey:@"dtype"] intValue];
    dev.motostep = [[dic valueForKey:@"motostep"] intValue];
    dev.mac = [dic valueForKey:@"name"];
    dev.nickName = [dic valueForKey:@"nickname"];
    dev.nio = [dic valueForKey:@"nio"];
    dev.rid = [dic valueForKey:@"rid"];
    dev.showName = [dic valueForKey:@"showname"];
    dev.state = [dic valueForKey:@"state"];
    
    NSString * dpStr = [dic valueForKey:@"devpost"];
    dpStr = [dpStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    dpStr = [dpStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray * devPostData = [dpStr componentsSeparatedByString:@","];
    double x = [[devPostData firstObject] floatValue];
    double y = [[devPostData lastObject] floatValue];
    dev.devpost = DevicePostMake(x, y);
    
    return dev;
}

- (NSString *)fullUrl:(NSString *)url Param:(NSDictionary *)param{
    NSMutableString * ss = [[NSMutableString alloc]initWithString:url];
    for (int i=0; i<param.allKeys.count; i++) {
        NSString * key = param.allKeys[i];
        NSString * value = [NSString stringWithFormat:@"%@",param.allValues[i]];
        if (i != 0) {
            [ss appendFormat:@"&"];
        }
        [ss appendFormat:@"%@=%@",key,value];
    }
    return ss;
}

@end
