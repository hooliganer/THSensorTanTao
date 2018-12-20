//
//  BLE_Manager.h
//  HomeKitSystem
//
//  Created by 谭滔 on 2017/11/29.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEPeripheralInfo.h"


@class BLE_Manager;

@protocol BLE_ManagerDelegate <NSObject>

- (void)manager:(BLE_Manager *)manager CBManagerPoweredOff:(CBCentralManager *)cbmanager;

@optional
- (void)manager:(BLE_Manager *)manager notificationStateForCharacteristic:(CBCharacteristic *)characteristic;
- (void)manager:(BLE_Manager *)manager didUpdateRequestValue:(CBCharacteristic *)character Peripheral:(CBPeripheral *)peripheral;
- (void)manager:(BLE_Manager *)manager didUpdateResponseValue:(CBCharacteristic *)character Peripheral:(CBPeripheral *)peripheral;

@end

@interface BLE_Manager : NSObject

@property (nonatomic,strong)NSMutableArray *currentPerips;///<元素为字典，{@"peripheral":CBPeripheral,@"sendCharacteristic":CBCharacteristic,@"receiveCharacteristic":CBCharacteristic}

@property (nonatomic,weak)id <BLE_ManagerDelegate>delegate;
@property (nonatomic,copy)void(^didResponse)(CBPeripheral *peripheral,CBCharacteristic *character,BLE_Manager *bleManager);
@property (nonatomic,copy)void(^didRequest)(CBPeripheral *peripheral,CBCharacteristic *character,BLE_Manager *bleManager);


+ (BLE_Manager *)shareInstance;

/**
 * 搜索设备，返回 BLEPeripheralInfo 的数组和 CBPeripheral 的数组,此方法传数组回来
 */
- (void)searchBLEDeviceWithBlock:(void(^)(NSArray<BLEPeripheralInfo *> *peripheralInfos,NSArray<CBPeripheral *> *peripherals))block;

/*!
 * 搜索设备，返回对象BLEPeripheralInfo,CBPeripheral
 */
- (void)searchBLEPeripheralBlock:(void(^)(BLEPeripheralInfo *info,CBPeripheral *peripheral))block;

/*!
 * 链接设备
 */
- (void)connectCBPeripheral:(CBPeripheral *)peripheral Block:(void(^)(bool success,NSString *info,CBPeripheral *peripheral))block;

/*!
 * 断开设备
 */
- (void)disConnectCBPerihperal:(CBPeripheral *)peripheral Block:(void(^)(bool success,NSString *info,CBPeripheral *peripheral))block;

/*!
 * @property value
 *  @discussion
 *      The value of the characteristic.
 */
- (void)queryWithData:(NSData *)data CBPeripheral:(CBPeripheral *)peripheral Block:(void(^)(CBPeripheral *peripheral,NSData *charicterData))block;

@end
