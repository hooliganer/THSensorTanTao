//
//  AFManager+SelectDataOfDevice.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFManager (SelectDataOfDevice)


- (void)selectDataOfDevice:(int)uid Mac:(nonnull NSString *)mac SIndex:(int)sindex EIndex:(int)eindex Result:(void(^)(NSArray <DeviceInfo *>*datas))result;

/**
 查询最后一条数据（视为最新实时数据）

 @param uid uid
 @param mac mac地址
 */
- (void)selectLastDataOfDevice:(int)uid Mac:(NSString *)mac Block:(void(^)(NSString * dataStr))block;

@end

NS_ASSUME_NONNULL_END
