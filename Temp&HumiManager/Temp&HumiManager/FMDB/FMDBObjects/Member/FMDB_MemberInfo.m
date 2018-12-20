//
//  FMDB_MemberInfo.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "FMDB_MemberInfo.h"

@implementation FMDB_MemberInfo


- (instancetype)initWithNewMember:(FMDB_MemberInfo *)member{
    if (self = [super init]) {
        self.coordinate = member.coordinate;
        self.mac = member.mac;
        self.dateline = member.dateline;
        self.dID = member.dID;
        self.cityCode = member.cityCode;
        self.email = member.email;
        self.nio = member.email;
        self.dType = member.dType;
        self.password = member.password;
        self.showName = member.showName;
        self.state = member.state;
        self.nickName = member.nickName;
        self.rid = member.rid;
        self.motostep = member.motostep;
    }
    return self;
}


#pragma mark ----- lazy load
- (NSMutableArray<NSValue *> *)sensors{
    if (_sensors == nil) {
        _sensors = [NSMutableArray array];
    }
    return _sensors;
}

#pragma mark ----- outside method
- (void)addSensorToSelfSensors:(MemberSensor)sensor{
    NSValue *value = [NSValue valueWithBytes:&sensor objCType:@encode(MemberSensor)];
    [self.sensors addObject:value];
}

- (MemberSensor)MemberSensorValue:(NSValue *)value{
    MemberSensor sensor;
    [value getValue:&sensor];
    return sensor;
}

@end
