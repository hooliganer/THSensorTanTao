//
//  AppDelegate+Catergory.h
//  Temp&HumiManager
//
//  Created by terry on 2018/9/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Catergory)

- (void)initCrashHandler;

/**
 判断本地是否用用户，无则注册
 */
- (void)judgeHasUser;

@end
