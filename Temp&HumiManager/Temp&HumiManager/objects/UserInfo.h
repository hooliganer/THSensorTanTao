//
//  UserInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject

@property (nonatomic,assign)int uid;
@property (nonatomic,copy)NSString *uname;
@property (nonatomic,copy)NSString *upwd;
@property (nonatomic,assign)bool isLogin;

@end
