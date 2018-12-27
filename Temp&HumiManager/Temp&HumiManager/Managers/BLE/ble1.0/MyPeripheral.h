//
//  MyPeripheral.h
//  TestAll
//
//  Created by terry on 2018/5/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface MyPeripheral : NSObject

@property (nonatomic,strong)CBPeripheral * peripheral;
@property (nonatomic,strong)CBCharacteristic * characteristic;
@property (nonatomic,strong)NSNumber * rssi;
@property (nonatomic,copy)NSDictionary * advertisement;

@property (nonatomic,strong)id objc;

/**
 * 设备的Mac地址（广播包里的）
 */
@property (nonatomic,copy,readonly) NSString *macAddress;

@property (nonatomic,strong,readonly)NSData *manufacture;

- (bool)isEqualToPeripheral:(MyPeripheral *)peripheral;
- (double)distanceByRSSI;

/*!
 * manufacture的字符串形式
 */
- (NSString *)manuString;

- (int)powerBle;

- (float)temperatureBle;

- (int)humidityBle;

@end
