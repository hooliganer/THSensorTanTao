//
//  AFManager+AFAutoRegister.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFManager (AFAutoRegister)

/**
 首次自动注册的请求

 @param block 成功与否
 */
- (void)autoFirstRegistUser:(void (^)(bool success, NSString *info))block;

@end

NS_ASSUME_NONNULL_END
