//
//  HTTP_MemberDataManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/9/3.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"
#import "DeviceInfo.h"


@interface HTTP_MemberDataManager : HTTP_Manager

@property (nonatomic,strong)NSMutableDictionary * dataSet;
@property (nonatomic,copy)void(^didGetMemberData)(HTTP_MemberDataManager *manager,DeviceInfo *device);

+ (HTTP_MemberDataManager *)sharedInstance;

- (void)selectMemberDataWithMac:(NSString *)mac GMac:(NSString *)gmac;

@end
