//
//  ShareFileManager.h
//  TestOC
//
//  Created by tantao on 2018/12/26.
//  Copyright © 2018 tantao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareFileManager : NSObject

+ (ShareFileManager *)shared;

- (void)shareTXTName:(NSString *)name Substance:(NSString *)substance InController:(UIViewController *)controller;

- (void)shareCSVName:(NSString *)name Substance:(NSString *)substance InController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
