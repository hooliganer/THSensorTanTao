//
//  HTTP_GroupManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/23.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"
#import "TH_GroupInfo.h"

@interface HTTP_GroupManager : HTTP_Manager

@property (nonatomic,copy)void(^didGetGroups)(NSArray <TH_GroupInfo *>* groups);
@property (nonatomic,copy)void(^didGetGroupsFail)(NSString *info);

@property (nonatomic,copy)void(^didLinkDevice)(bool success,NSString *info);

+ (HTTP_GroupManager *)shreadInstance;

/**
 * 查询用户关注组
 */
- (void)selectGroupOfUserWithUid:(int)uid Pwd:(NSString *)pwd;

- (void)linkGroupWithMac:(NSString *)mac Uid:(NSString *)uid Pwd:(NSString *)pwd;

@end
