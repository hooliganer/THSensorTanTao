//
//  MyDefaultManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"
#import "APPGlobalObject.h"


@interface MyDefaultManager : NSObject

+ (MyDefaultManager *)sharedInstance;


/*!
 * 根据对象的变量不同，此方法也需要重新定义
 */
- (UserInfo *)readUser;
+ (UserInfo *)userInfo;

- (void)saveUser:(UserInfo *)user;



- (void)saveGlobalInfo:(APPGlobalObject *)gobc;
- (APPGlobalObject *)readGlobalInfo;

/*!
 * 设置发起注册用户的时间
 */
+ (void)setAutoRegsiterTime:(NSTimeInterval)interval;
/*!
 * 读取发起注册用户的时间
 */
+ (NSTimeInterval)readAutoRegsiterDate;

@end
