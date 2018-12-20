//
//  DeviceOfGroup.m
//  Temp&HumiManager
//
//  Created by terry on 2018/9/3.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DeviceOfGroup.h"

@implementation DeviceOfGroup

- (instancetype)initWithNewDevice:(DeviceOfGroup *)dev{
    if (self = [super init]) {
        self.rid = dev.rid;
        self.utime = dev.utime;
        self.tmac = dev.tmac;
        self.uuid = dev.uuid;
        self.sdata = dev.sdata;
    }
    return self;
}

@end
