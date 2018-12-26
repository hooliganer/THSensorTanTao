//
//  AFManager+DeviceInfo.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/26.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFManager (DeviceInfo)

- (void)setDeviceName:(NSString *)name Mac:(NSString *)mac Uid:(int)uid Result:(void(^)(bool success,NSString * info))result;

- (void)setDeviceType:(int)type Mac:(NSString *)mac Uid:(int)uid Result:(void(^)(bool success,NSString * info))result;

@end

NS_ASSUME_NONNULL_END
