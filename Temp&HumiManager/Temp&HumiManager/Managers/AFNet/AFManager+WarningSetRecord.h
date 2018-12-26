//
//  AFManager+WarningSetRecord.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/24.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager.h"
#import "WarnSetRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFManager (WarningSetRecord)

- (void)selectLastWarnSetRecordWithMac:(NSString *)mac Block:(void(^)(WarnSetRecord * record))block;

/**
 查询所有设置报警的记录，按不同的值得类型分

 @param mac MAC地址
 @param block 回调 - 4个数组，温度、湿度最值
 */
- (void)selectAllWarnRecordSetWithMac:(NSString *)mac Block:(void(^)(NSArray <WarnSetRecord *>*tempMax,NSArray <WarnSetRecord *>*tempMin,NSArray <WarnSetRecord *>*humiMax,NSArray <WarnSetRecord *>*humiMin))block;

- (void)setWarnWithMac:(NSString *)mac Type:(NSString *)type IsOn:(bool)ison Uid:(int)uid Value:(NSNumber *)value;

@end

NS_ASSUME_NONNULL_END
