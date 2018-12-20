//
//  HTTP_MemberManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"
//#import "FMDB_MemberInfo.h"
#import "DeviceInfo.h"

@interface HTTP_MemberManager : HTTP_Manager

@property (nonatomic,copy)void(^didGetMembers)(HTTP_MemberManager *manager,NSArray <DeviceInfo *>*members);
@property (nonatomic,copy)void(^getFail)(HTTP_MemberManager *manager,NSString *failInfo);

@property (nonatomic,strong)NSMutableDictionary * dataSet;

+ (HTTP_MemberManager *)shareadInstance;

- (void)selectMembersWithUid:(int)uid Gid:(int)gid;


@end
