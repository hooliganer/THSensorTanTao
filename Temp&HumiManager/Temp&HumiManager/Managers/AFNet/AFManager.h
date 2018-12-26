//
//  AFManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/17.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XMLDictionary.h"

#import "TH_GroupInfo.h"

#define TH_IP @"www.easyhomeai.com"
#define TH_PORT @"8080"

@interface AFManager : NSObject

+ (AFManager *)shared;

@property (nonatomic,strong)AFHTTPSessionManager * sessionManager;
//@property (nonatomic,strong)NSDictionary * param;
//@property (nonatomic,copy)NSString * url;

- (void)selectMembersOfGroupWithGid:(int)gid Block:(void(^)(NSArray <DeviceInfo *>*devices))block Fail:(void(^)(NSError * error))fail;


- (void)fakeLoad;

- (void)fakeLoadQueue:(dispatch_queue_t)queue Block:(void(^)(void))block;

- (NSString *)fullUrl:(NSString *)url Param:(NSDictionary *)param;

@end
