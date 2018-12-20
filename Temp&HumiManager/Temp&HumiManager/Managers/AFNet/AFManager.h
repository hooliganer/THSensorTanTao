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

- (void)selectMembersOfGroupWithGid:(int)gid Block:(void(^)(void))block;


- (void)fakeLoad;


@end
