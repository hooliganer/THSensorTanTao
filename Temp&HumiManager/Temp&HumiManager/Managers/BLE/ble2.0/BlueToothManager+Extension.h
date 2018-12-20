//
//  BlueToothManager+Extension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BlueToothManager.h"

//心跳包
extern NSString * const HeartRate_Service;
//请求数据
extern NSString * const Request_Characteristic;
//返回数据
extern NSString * const Response_Characteristic;

@interface BlueToothManager ()

@property (nonatomic,strong)CBCentralManager * centralManager;
@property (nonatomic,strong)CBPeripheralManager * peripheralManager;

@property (nonatomic,copy)NSArray <CBUUID *>* serviceUUIDs;
@property (nonatomic,copy)NSArray * characteristicUUIDs;

@end
