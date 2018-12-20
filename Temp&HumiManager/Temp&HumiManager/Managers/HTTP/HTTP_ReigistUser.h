//
//  HTTP_ReigistUser.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/29.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"

@interface HTTP_ReigistUser : HTTP_Manager

+ (HTTP_ReigistUser *)sharedInstance;

/*!
 * 根据uuid 自动生成用户名和密码进行注册,注册成功紧接着登录
 */
- (void)autoFirstRegistUser:(void(^)(bool success,NSString *info))block;

@end
