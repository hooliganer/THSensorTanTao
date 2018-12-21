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

- (void)selectDataOfDevice:(int)uid Mac:(NSString *)mac;

- (void)selectLastDataOfDevice:(int)uid Mac:(NSString *)mac;

@end

NS_ASSUME_NONNULL_END
