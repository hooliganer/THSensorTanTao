//
//  BLEPeripheralInfo.h
//  MedicalTreatmentProject
//
//  Created by 谭滔 on 2017/8/21.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_OPTIONS(NSInteger, PeripheralConnectState) {
    PeripheralConnectState_Disconnected = 0 ,
    PeripheralConnectState_Connecting             ,
    PeripheralConnectState_Connected              ,
    PeripheralConnectState_Disconnecting          ,
};

@interface BLEPeripheralInfo : NSObject

/**
 * 蓝牙名称
 */
@property (nonatomic, copy) NSString *name;
/**
 * 蓝牙uuid
 */
@property (nonatomic, copy) NSString *uuid;
/**
 * 设备的Mac地址（广播包里的）
 */
@property (nonatomic, copy,readonly) NSString *macAddress;
/**
 * 蓝牙rssi
 */
@property (nonatomic, strong) NSNumber *rssi;
/**
 * 蓝牙manufactureData
 */
@property (nonatomic, strong) NSData *manufacture;
/**
 * 蓝牙连接状态
 */
@property (nonatomic, assign) PeripheralConnectState isConnected;

@property (nonatomic,strong)CBPeripheral *peripheral;


@end
