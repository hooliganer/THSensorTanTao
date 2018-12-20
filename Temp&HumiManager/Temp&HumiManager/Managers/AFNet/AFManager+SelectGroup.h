//
//  AFManager+SelectGroup.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/17.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AFManager.h"
#import "TH_GroupInfo.h"

@interface AFManager (SelectGroup)

- (void)selectGroupOfUser:(void(^)(NSArray <TH_GroupInfo *>*groups))block;

@end
