//
//  DeviceInfo.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DeviceInfo.h"


@implementation DeviceInfo

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithNewDevice:(DeviceInfo *)dev{
    if (self = [super init]) {
        self.dID = dev.dID;
        self.nickName = dev.nickName;
        self.showName = dev.showName;
        self.mac = dev.mac;
        self.dateline = dev.dateline;
        self.dType = dev.dType;
        self.devpost = dev.devpost;
        self.motostep = dev.motostep;
        self.state = dev.state;
        self.cityCode = dev.cityCode;
        self.email = dev.email;
        self.nio = dev.nio;
        self.pwd = dev.pwd;
        self.sensors = dev.sensors;
        self.rid = dev.rid;

        //组成员数据
        self.utime = dev.utime;
        self.tmac = dev.tmac;
        self.uuid = dev.uuid;
        self.sdata = dev.sdata;
    }
    return self;
}

#pragma mark ----- outside method
- (void)addSensorToSelfSensors:(MemberSensor)sensor{
    NSValue *value = [NSValue valueWithBytes:&sensor objCType:@encode(MemberSensor)];
    [self.sensors addObject:value];
}

+ (MemberSensor)MemberSensorValue:(NSValue *)value{
    MemberSensor sensor;
    [value getValue:&sensor];
    return sensor;
}

- (float)temeratureBySData{
    return arc4random_uniform(500)/10.0;
}
- (int)humidityBySData{
    return arc4random_uniform(101);
}
- (int)powerBySData{
    return arc4random_uniform(101);
}


- (float)temeratureBySensor{
    float tp = -1000;
    //数据赋予
    for (NSValue *value in self.sensors) {
        if (!value) {
            continue ;
        }
        MemberSensor ss = [DeviceInfo MemberSensorValue:value];
        if (ss.type == SensorType_Temparature) {
            tp = ss.value;
            break ;
        }
    }
    return tp;
}

- (int)humidityBySensor{
    int hm = -1000;
    //数据赋予
    for (NSValue *value in self.sensors) {
        if (!value) {
            continue ;
        }
        MemberSensor ss = [DeviceInfo MemberSensorValue:value];
        if (ss.type == SensorType_Humidity) {
            hm = ss.value;
            break ;
        }
    }
    return hm;
}


@end
