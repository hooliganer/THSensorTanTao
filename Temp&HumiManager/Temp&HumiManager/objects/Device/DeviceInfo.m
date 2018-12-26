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
    //  50582D505323 4900 072B 33 5E
    //  50582D505323 这个为头 截断之后以49位标识 49后面就是数据
    //  例如50582D505323 4900 0950 49 64 ；
    //  “0950”，“0”：+，
    //  温度950 =>16 = 2384/10=23.84℃；
    //  湿度：49 =>16 = 73%;
    //  电量：64=>16 =100%
    if (![self.sdata containsString:@"50582D505323"]) {
        return -1000;
    }
    if (self.sdata.length < 20) {
        return -1000;
    }
    bool is = [[self.sdata substringWithRange:NSMakeRange(16, 1)] boolValue];
    NSString * temp = [self.sdata substringWithRange:NSMakeRange(17, 3)];
    float value = is ? -[temp toDecimalByHex]/100.0 : [temp toDecimalByHex]/100.0;
    return value;
}
- (int)humidityBySData{
    if (![self.sdata containsString:@"50582D505323"]) {
        return -1000;
    }
    if (self.sdata.length < 22) {
        return -1000;
    }
    NSString * temp = [self.sdata substringWithRange:NSMakeRange(20, 2)];
    int value = [temp toDecimalByHex];
    return value;
}
- (int)powerBySData{
    if (![self.sdata containsString:@"50582D505323"]) {
        return -1000;
    }
    if (self.sdata.length < 24) {
        return -1000;
    }
    NSString * temp = [self.sdata substringWithRange:NSMakeRange(22, 2)];
    int value = [temp toDecimalByHex];
    return value;
}

+ (float)temeratureBySData:(NSString *)sdata{
    if (![sdata containsString:@"50582D505323"]) {
        return -1000;
    }
    if (sdata.length < 20) {
        return -1000;
    }
    bool is = [[sdata substringWithRange:NSMakeRange(16, 1)] boolValue];
    NSString * temp = [sdata substringWithRange:NSMakeRange(17, 3)];
    float value = is ? -[temp toDecimalByHex]/100.0 : [temp toDecimalByHex]/100.0;
    return value;
}
+ (int)humidityBySData:(NSString *)sdata{
    if (![sdata containsString:@"50582D505323"]) {
        return -1000;
    }
    if (sdata.length < 22) {
        return -1000;
    }
    NSString * temp = [sdata substringWithRange:NSMakeRange(20, 2)];
    int value = [temp toDecimalByHex];
    return value;
}
+ (int)powerBySData:(NSString *)sdata{
    if (![sdata containsString:@"50582D505323"]) {
        return -1000;
    }
    if (sdata.length < 24) {
        return -1000;
    }
    NSString * temp = [sdata substringWithRange:NSMakeRange(22, 2)];
    int value = [temp toDecimalByHex];
    return value;
}

- (NSString *)imageNameWithMototype{
    switch (self.motostep) {
        case 6:
            return @"ic_room_wc";
            break;
        case 7:
            return @"ic_room_bar";
            break;
        case 8://bed
            return @"ic_room_car";
            break;
        case 9:
            return@"ic_room_baby";
            break;
            
        default:
            return @"ic_room_car";
            break;
    }
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
