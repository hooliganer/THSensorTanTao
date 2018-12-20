//
//  TH_GroupInfo.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "TH_GroupInfo.h"

@implementation TH_GroupInfo

- (instancetype)init{
    if (self = [super init]) {
        self.devices = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithNewRoomInfo:(TH_GroupInfo *)newInfo{
    if (self = [super init]) {
        self.name = newInfo.name;
        self.mac = newInfo.mac;
        self.dateline = newInfo.dateline;
        self.state = newInfo.state;
        self.gid = newInfo.gid;
        self.type = newInfo.type;
        self.appSID = newInfo.appSID;
        self.online = newInfo.online;
        self.devices = newInfo.devices;
        self.mCount = newInfo.mCount;
    }
    return self;
}

@end
