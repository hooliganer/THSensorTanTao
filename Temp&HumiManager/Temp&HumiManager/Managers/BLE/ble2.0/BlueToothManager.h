//
//  BlueToothManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueToothInfo.h"

@interface BlueToothManager : NSObject

/*!
 * 当前连接着的设备
 */
@property (nonatomic,readonly,strong)NSMutableArray <CBPeripheral *>* connectingPeripherals;
/*!
 * 开始搜索后发现的设备
 */
@property (nonatomic,readonly,strong)NSMutableArray <BlueToothInfo *>* discoveredPeripherals;



@property (nonatomic,copy)void(^discoveredPeripheral)(BlueToothManager * manager,BlueToothInfo *peripheral);///<发现新设备
@property (nonatomic,copy)void(^didConnectPeripheral)(BlueToothManager * manager,CBPeripheral *peripheral);///<设备已连接
@property (nonatomic,copy)void(^didDisonnectPeripheral)(BlueToothManager * manager,CBPeripheral *peripheral);///<设备已断开连接
@property (nonatomic,copy)void(^didGetData)(BlueToothManager * manager,CBCharacteristic * character);///<已经接收到数据


- (void)startScan;
- (void)stopScan;
- (void)connetPeripheal:(CBPeripheral *)peripheral;
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;
- (void)queryData:(NSData *)data;

@end
