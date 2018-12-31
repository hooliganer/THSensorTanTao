//
//  DeviceInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo+DeviceInfoExtension.h"

typedef NS_OPTIONS(NSInteger, DeviceDataType) {
    DeviceDataType_Device ,///<关注设备数据类型
    DeviceDataType_Member ,///<组成员设备数据类型
};

/*!
 * 网络对象,可能是用户关注的对象，也可能是组里面的对象
 */
@interface DeviceInfo : NSObject

@property (nonatomic,assign)int dID;
@property (nonatomic,assign)NSTimeInterval dateline;
@property (nonatomic,assign)int dType;
@property (nonatomic,assign)int motostep;
@property (nonatomic,assign)bool state;

@property (nonatomic,copy)NSString *mac;
@property (nonatomic,copy)NSString *cityCode;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *nio;
@property (nonatomic)DevicePost devpost;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *showName;
@property (nonatomic,copy)NSString *rid;
@property (nonatomic,copy)NSString *pwd;

@property (nonatomic,assign)DeviceDataType type;

//组成员数据
@property (nonatomic,assign)NSTimeInterval utime;
@property (nonatomic,copy)NSString * tmac;
@property (nonatomic,copy)NSString * uuid;
@property (nonatomic,copy)NSString * sdata;

@property (nonatomic,strong)NSMutableArray<NSValue *>* sensors;///<MemberSensor结构体集

@property (nonatomic,assign)float temparature;
@property (nonatomic,assign)float humidity;
@property (nonatomic,assign)float power;


- (instancetype)initWithNewDevice:(DeviceInfo *)dev;


- (void)addSensorToSelfSensors:(MemberSensor)sensor;
+ (MemberSensor)MemberSensorValue:(NSValue *)value;

- (float)temeratureBySData;
- (int)humidityBySData;
- (int)powerBySData;
/**
 判断是否是标准数据

 @return 判断结果
 */
- (bool)isTHData;

- (float)temeratureBySensor;

- (int)humidityBySensor;

- (NSString *)imageNameWithMototype;

+ (float)temeratureBySData:(NSString *)sdata;
+ (int)humidityBySData:(NSString *)sdata;
+ (int)powerBySData:(NSString *)sdata;

@end
