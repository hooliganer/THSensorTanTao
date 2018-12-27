//
//  BLEManager.h
//  TestAll
//
//  Created by terry on 2018/5/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPeripheral.h"

@interface BLEManager : NSObject
<
CBPeripheralDelegate,CBCentralManagerDelegate,CBPeripheralManagerDelegate
>

@property (nonatomic,strong)CBCentralManager *centralManager;
@property (nonatomic,strong)CBPeripheralManager *peripheralManager;

@property (nonatomic,strong,readonly)NSMutableArray <CBPeripheral *> *connectingPeripherals;///<当前连接着的设备
@property (nonatomic,strong,readonly)NSMutableArray <MyPeripheral *> *discoveredPeripherals;///<扫描范围内的设备


@property (nonatomic,copy)void(^discoverPeripheral)(BLEManager *manager,MyPeripheral *peripheral);
@property (nonatomic,copy)void(^disconnectedPeripheral)(BLEManager *manager,CBPeripheral *peripheral,NSError *error);

@property (nonatomic,copy)void(^didResponse)(BLEManager *manager,CBPeripheral *peripheral,CBCharacteristic *characteristic);
@property (nonatomic,copy)void(^didRequest)(BLEManager *manager,CBPeripheral *peripheral,CBCharacteristic *characteristic);
@property (nonatomic,copy)void(^didUnknownCharacter)(BLEManager *manager,CBPeripheral *peripheral,CBCharacteristic *characteristic);
@property (nonatomic,copy)void(^blePoweredOff)(BLEManager* manager,CBCentralManager* centralManager);


+ (BLEManager *)shareInstance;

- (void)startScan;

/*!
 * 链接设备
 */
- (void)connectCBPeripheral:(CBPeripheral *)peripheral Block:(void(^)(bool success,NSString *info,CBPeripheral *peripheral))block;

- (void)cancelConnectCBPeripheral:(CBPeripheral *)peripheral;

/**
 断开连接

 @param peripheral 蓝牙设备
 */
- (void)disConnectCBPeripheral:(CBPeripheral *)peripheral;

- (void)queryWithData:(NSData *)data CBPeripheral:(CBPeripheral *)peripheral;

@end
