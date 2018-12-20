//
//  MainCollectionObject.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DeviceInfo.h"
#import "MainCollectionObject+MainCollectionObjectExtension.h"
#import "MyPeripheral.h"

/*!
 * 此对象仅用作于UI显示
 */
@interface MainCollectionObject : DeviceInfo


@property (nonatomic,assign)bool isBle;///<用做标记是否有从蓝牙查回
@property (nonatomic,assign)bool isWifi;///<用做标记是否有从网络查回

@property (nonatomic,strong)MyPeripheral *bleInfo;///<蓝牙信息

@property (nonatomic,assign)bool tempWarning;///<温度是否报警🌡️
@property (nonatomic,assign)bool humiWarning;///<湿度是否报警💧

@property (nonatomic,assign)float temperatureWifi;///<网络温度🌡️
@property (nonatomic,assign)int humidityWifi;///<网络湿度💧
@property (nonatomic,assign)int powerWifi;///<网络温度电量🔋

@property (nonatomic,assign)float temperatureBle;///<蓝牙温度🌡️
@property (nonatomic,assign)int humidityBle;///<蓝牙湿度💧
@property (nonatomic,assign)int powerBle;///<蓝牙电量🔋

@property (nonatomic,copy)NSString *tempUnit;///<温度单位

@property (nonatomic)ThresholdValue thresholdTemp;///<温度阈值信息
@property (nonatomic)ThresholdValue thresholdHumi;///<温度阈值信息


- (void)setBleInfoWithBleObject:(MainCollectionObject *)objc;
- (void)setWifiInfoWithWifiObject:(MainCollectionObject *)objc;

/*!
 * 获取是否有数据,返回 无、网络、蓝牙三种数据类型
 */
- (MCODataType)hasData;
- (bool)isWifiData;
- (bool)isBleData;

- (bool)isEqualOfMacTo:(MainCollectionObject *)mco;

/*!
 * 根据DeviceInfo的信息进行初始化，初始化后自带所有网络(DeviceInfo)信息
 */
- (instancetype)initWithDeviceInfo:(DeviceInfo *)dev;

- (instancetype)initWithNewCollectionObject:(MainCollectionObject *)objc;

- (IsContain)isContainInArray:(NSArray <MainCollectionObject *>*)array;
+ (bool)array1:(NSArray <MainCollectionObject *>*)arr1 isHasSameToArray2:(NSArray <MainCollectionObject *>*)arr2;

@end



