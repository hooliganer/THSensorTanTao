//
//  MainCollectionObject.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainCollectionObject.h"

@implementation MainCollectionObject

- (instancetype)initWithDeviceInfo:(DeviceInfo *)dev{
    if (self = [super initWithNewDevice:dev]) {

        self.isWifi = true;
        
        //数据赋予
        for (NSValue *value in dev.sensors) {
            if (value == nil) {
                continue ;
            }
            MemberSensor sensor = [DeviceInfo MemberSensorValue:value];
            switch (sensor.type) {
                case SensorType_Temparature:
                    self.temperatureWifi = sensor.value;
                    break;
                case SensorType_Humidity:
                    self.humidityWifi = sensor.value;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}


- (instancetype)initWithNewCollectionObject:(MainCollectionObject *)objc{
    if (self = [super initWithNewDevice:objc]) {
        self.isBle = objc.isBle;
        self.isWifi = objc.isWifi;
        self.tempWarning = objc.tempWarning;
        self.humiWarning = objc.humiWarning;

//        self.tempBleText = objc.tempBleText;
//        self.humiBleText = objc.humiBleText;
//        self.powerBleText = objc.powerBleText;
//
//        self.tempWifiText = objc.tempWifiText;
//        self.humiWifiText = objc.humiWifiText;
//        self.powerWifiText = objc.powerWifiText;

        self.temperatureWifi = objc.temperatureWifi;
        self.humidityWifi = objc.humidityWifi;
        self.powerWifi = objc.powerWifi;

        self.temperatureBle = objc.temperatureBle;
        self.humidityBle = objc.humidityBle;
        self.powerBle = objc.powerBle;

        self.thresholdTemp = objc.thresholdTemp;
        self.thresholdHumi = objc.thresholdHumi;

    }
    return self;
}


- (void)setBleInfoWithBleObject:(MainCollectionObject *)objc{
    self.bleInfo = objc.bleInfo;
    self.temperatureBle = objc.temperatureBle;
    self.powerBle = objc.powerBle;
    self.humidityBle = objc.humidityBle;
    self.isBle = objc.isBle;
}

- (void)setWifiInfoWithWifiObject:(MainCollectionObject *)objc{

    self.temperatureWifi = objc.temperatureWifi;
    self.powerWifi = objc.powerWifi;
    self.humidityWifi = objc.humidityWifi;
    self.isWifi = objc.isWifi;
    self.nickName = objc.nickName;
    self.showName = objc.showName;

    self.dID = objc.dID;
    self.dateline = objc.dateline;
    self.dType = objc.dType;
    self.motostep = objc.motostep;
    self.state = objc.state;
    self.cityCode = objc.cityCode;
    self.email = objc.email;
    self.nio = objc.nio;
    self.devpost = objc.devpost;
    self.pwd = objc.pwd;
    self.sensors = objc.sensors;    
}

- (bool)isWifiData{
    if (self.temperatureWifi == 0 && self.humidityWifi == 0 && self.powerWifi == 0) {
        return false;
    } else {
        return true;
    }
}

- (bool)isBleData{
    if (self.temperatureBle == 0 && self.humidityBle == 0 && self.powerBle == 0) {
        return false;
    } else {
        return true;
    }
}

- (bool)isEqualOfMacTo:(MainCollectionObject *)mco{
    return ([self.mac compare:mco.mac options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

- (MCODataType)hasData{
    if (self.powerWifi == 0 && self.temperatureWifi == 0 && self.humidityWifi == 0) {
        if (self.powerBle == 0 && self.temperatureBle == 0 && self.humidityBle == 0) {
            return MCODataType_None;
        }
        else {
            return MCODataType_Ble;
        }
    }
    else {
        return MCODataType_Wifi;
    }
}

- (IsContain)isContainInArray:(NSArray <MainCollectionObject *>*)array{
    IsContain ic = IsContainMake(-1, false);
    for (NSInteger i=0;i<array.count;i++) {
        MainCollectionObject *objc = [array objectAtIndex:i];
        if ([objc.mac isEqualToString:self.mac]) {
            ic.index = i;
            ic.isExist = true;
            break ;
        }
    }
    return ic;
}

+ (bool)array1:(NSArray <MainCollectionObject *>*)arr1 isHasSameToArray2:(NSArray <MainCollectionObject *>*)arr2{
    bool is = false;
    for (int i=0; i<arr1.count; i++) {
        MainCollectionObject *objc1 = [arr1 objectAtIndex:i];
        for (int j=0; j<arr2.count; j++) {
            MainCollectionObject *objc2 = [arr2 objectAtIndex:i];
            if ([objc1.mac isEqualToString:objc2.mac]) {
                is = true;
                break ;
            }
        }
        if (is) {
            break ;
        }
    }
    return is;
}

@end
