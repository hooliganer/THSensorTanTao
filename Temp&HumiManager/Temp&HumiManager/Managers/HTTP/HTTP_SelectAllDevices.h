//
//  HTTP_SelectAllDevices.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"
#import "DeviceInfo.h"

@interface HTTP_SelectAllDevices : HTTP_Manager

+ (HTTP_SelectAllDevices *)sharedInstance;

- (void)selectAllDevicesWithUid:(int)uid Block:(void(^)(NSArray<DeviceInfo *> *devsInfo))block;



- (void)linkDevWithMac:(NSString *)mac Name:(NSString *)name Block:(void(^)(bool success,NSString *info))block;

@end
