//
//  APPGlobalObject.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/26.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "APPGlobalObject.h"

@interface APPGlobalObject ()
<NSCoding>

@end

@implementation APPGlobalObject

- (instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.wifiName forKey:@"wifiName"];
    [aCoder encodeObject:self.wifiPwd forKey:@"wifiPwd"];
    [aCoder encodeBool:self.unitType forKey:@"unitType"];
    [aCoder encodeInt:self.closeSec forKey:@"closeSec"];
    [aCoder encodeInt:self.closeMin forKey:@"closeMin"];
    [aCoder encodeBool:self.isWifiType forKey:@"isWifiType"];
//    [aCoder encodeObject:self.devIsAlert forKey:@"devIsAlert"];
//    [aCoder encodeObject:self.devLmtValue forKey:@"devLmtValue"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.wifiName = [aDecoder decodeObjectForKey:@"wifiName"];
        self.wifiPwd = [aDecoder decodeObjectForKey:@"wifiPwd"];
        self.unitType = [aDecoder decodeBoolForKey:@"unitType"];
        self.closeSec = [aDecoder decodeIntForKey:@"closeSec"];
        self.closeMin = [aDecoder decodeIntForKey:@"closeMin"];
        self.isWifiType = [aDecoder decodeBoolForKey:@"isWifiType"];
//        self.devIsAlert= [aDecoder decodeObjectForKey:@"devIsAlert"];
//        self.devLmtValue = [aDecoder decodeObjectForKey:@"devLmtValue"];
    }
    return self;
}

@end
