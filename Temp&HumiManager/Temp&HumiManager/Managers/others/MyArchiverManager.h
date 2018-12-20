//
//  MyArchiverManager.h
//  TestAll
//
//  Created by terry on 2018/4/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPGlobalObject.h"

@interface MyArchiverManager : NSObject

+ (MyArchiverManager *)sharedInstance;

- (void)saveGlobalObject:(APPGlobalObject *)object;
- (APPGlobalObject *)readGlobalObject;

@end
