//
//  HTTP_ModifyDevInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/4/1.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"

@interface HTTP_ModifyDevInfo : HTTP_Manager

+ (HTTP_ModifyDevInfo *)sharedInstance;

- (void)setDevType:(int)type Uid:(int)uid Mac:(NSString *)mac Block:(void(^)(bool success,NSString *info))block;

- (void)setDevName:(NSString *)name Uid:(int)uid Mac:(NSString *)mac Block:(void(^)(bool success,NSString *info))block;

@end
