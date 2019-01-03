//
//  BLEManager.m
//  TestAll
//
//  Created by terry on 2018/5/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BLEManager.h"

NSString * const heartRateService1 = @"0000fff0-0000-1000-8000-00805f9b34fb";
//请求数据
NSString * const requestCharacteristic1 = @"0000fff6-0000-1000-8000-00805f9b34fb";
//返回数据
NSString * const responseCharacteristic1 = @"0000fff7-0000-1000-8000-00805f9b34fb";


@interface BLEManager ()


@property (nonatomic,copy)NSArray <CBUUID *> *serviceUUIDs;
@property (nonatomic,copy)NSArray <CBUUID *> *characteristicUUIDs;

@property (nonatomic,strong,readwrite)NSMutableArray <CBPeripheral *> *connectingPeripherals;///<当前连接着的设备
@property (nonatomic,strong,readwrite)NSMutableArray <MyPeripheral *> *discoveredPeripherals;///<扫描范围内的设备


@property (nonatomic,strong)NSMutableArray <CBPeripheral *> *discoveredCBPeripherals;
@property (nonatomic,strong)NSMutableArray <NSDictionary *> *connectingDics;///<@{@"peripheral":xx,@"sendCharacteristc":xx,@"receiveCharacteristc":xx,@"unknownCharacteristc":xx}

@property (nonatomic,strong)NSMutableArray <NSMutableDictionary *>* isConnects;

@end

@implementation BLEManager
{
    void(^connectCBPeripheralBlock)(bool,NSString *,CBPeripheral *);///<链接设备成功与否 回调
}

+ (BLEManager *)shareInstance{
    static BLEManager *bleMNG = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        bleMNG = [[BLEManager alloc]init];
    });
    return bleMNG;
}

#pragma mark ----- Lazy load
- (CBCentralManager *)centralManager{
    if (_centralManager == nil) {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

- (CBPeripheralManager *)peripheralManager{
    if (_peripheralManager == nil) {
        _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    }
    return _peripheralManager;
}

- (NSArray <CBUUID *> *)serviceUUIDs{
    if (_serviceUUIDs == nil) {
        _serviceUUIDs = [NSArray arrayWithObjects:[CBUUID UUIDWithString:heartRateService1], nil];
    }
    return _serviceUUIDs;
}

- (NSArray <CBUUID *> *)characteristicUUIDs{
    if (_characteristicUUIDs == nil) {
        _characteristicUUIDs = @[[CBUUID UUIDWithString:requestCharacteristic1],[CBUUID UUIDWithString:responseCharacteristic1]];
    }
    return _characteristicUUIDs;
}


- (NSMutableArray <NSDictionary *> *)connectingDics{
    if (_connectingDics == nil) {
        _connectingDics = [NSMutableArray array];
        _connectingDics = [NSMutableArray array];
    }
    return _connectingDics;
}

- (NSMutableArray <MyPeripheral *> *)discoveredPeripherals{
    if (_discoveredPeripherals == nil) {
        _discoveredPeripherals = [NSMutableArray array];
        _discoveredCBPeripherals = [NSMutableArray array];
    }
    return _discoveredPeripherals;
}

- (NSMutableArray<NSMutableDictionary *> *)isConnects{
    if (_isConnects == nil) {
        _isConnects = [NSMutableArray array];
    }
    return _isConnects;
}

#pragma mark ----- <CB CentralManager Delegate>
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (@available(iOS 10.0, *)) {
        switch (central.state) {
            case CBManagerStatePoweredOn:
                [self startScan];
                break;
            case CBManagerStatePoweredOff:
            {
                NSLog(@"蓝牙未打开");
                if (self.blePoweredOff) {
                    self.blePoweredOff(self, central);
                }
            }
                break;
            case CBManagerStateResetting:
                NSLog(@"蓝牙连接超时");
                break;
            case CBManagerStateUnsupported:
                NSLog(@"不支持蓝牙4.0");
                break;
            case CBManagerStateUnauthorized:
                NSLog(@"蓝牙连接失败");
                break;
            case CBManagerStateUnknown:
                NSLog(@"蓝牙未知原因1");
                break;

            default:
                NSLog(@"蓝牙未知原因2");
                break;
        }
    } else {
        switch (central.state) {
            case CBCentralManagerStatePoweredOn:
                [self startScan];
                break;
            case CBCentralManagerStatePoweredOff:
                NSLog(@"蓝牙未打开");
                break;
            case CBCentralManagerStateResetting:
                NSLog(@"蓝牙连接超时");
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"不支持蓝牙4.0");
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@"蓝牙连接失败");
                break;
            case CBCentralManagerStateUnknown:
                NSLog(@"蓝牙未知原因1");
                break;

            default:
                NSLog(@"蓝牙未知原因2");
                break;
        }
    }
}

#pragma mark ----- <CB PeripheralManager Delegate>
- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {

}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI{

    MyPeripheral *per;

    
    //新设备，替换更新
    if (![self.discoveredCBPeripherals containsObject:peripheral]) {

        per = [[MyPeripheral alloc]init];
        per.advertisement = advertisementData;
        per.rssi = RSSI;
        per.peripheral = peripheral;
        [self.discoveredPeripherals addObject:per];
        [self.discoveredCBPeripherals addObject:peripheral];

    } else{

        NSUInteger index = [self.discoveredCBPeripherals indexOfObject:peripheral];
        per = self.discoveredPeripherals[index];
        per.advertisement = advertisementData;
        per.rssi = RSSI;
        per.peripheral = peripheral;
        [self.discoveredPeripherals replaceObjectAtIndex:index withObject:per];
        [self.discoveredCBPeripherals replaceObjectAtIndex:index withObject:peripheral];
    }

    if (self.discoverPeripheral) {
        self.discoverPeripheral(self, per);
    }
}


#pragma mark <CBCentralManagerDelegate>
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{

    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    LRLog(@"didconnect");
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (connectCBPeripheralBlock) {
        connectCBPeripheralBlock(false,error.description,peripheral);
        connectCBPeripheralBlock = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (self.disconnectedPeripheral) {
        self.disconnectedPeripheral(self, peripheral, error);
    }

}


#pragma mark <CBPeripheralDelegate>
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    LRLog(@"diddiscoverservice");
    if (error) {
        NSLog(@"service error:%@",error.userInfo);
        return ;
    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:self.characteristicUUIDs forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error{

    //    NSLog(@"%@",service);
    //    NSLog(@"%@",service.characteristics);
    //    NSLog(@"%@",service.includedServices);

//    if (self.currentPerips == nil) {
//        self.currentPerips = [NSMutableArray array];
//    }

    for (CBCharacteristic *characteristic in service.characteristics) {

        CBUUID *sendUUID = [CBUUID UUIDWithString:requestCharacteristic1];
        CBUUID *receiveUUID = [CBUUID UUIDWithString:responseCharacteristic1];

        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];

        [mdic setObject:peripheral forKey:@"peripheral"];

        if ([characteristic.UUID isEqual:sendUUID]) {
            //NSLog(@"--send-- %@", character);
            [mdic setObject:characteristic forKey:@"sendCharacteristc"];
        }
        else if ([characteristic.UUID isEqual:receiveUUID]){
            //NSLog(@"--recieve-- %@", character);
            //回传接口始终处于监测状态，didUpdateNotificationStateForCharacteristic:方法回传
            [mdic setObject:characteristic forKey:@"receiveCharacteristc"];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        else {
            [mdic setObject:characteristic forKey:@"unknownCharacteristc"];
        }
        [self.connectingDics addObject:mdic];
        [self.connectingPeripherals addObject:peripheral];
    }

    if (connectCBPeripheralBlock) {
        connectCBPeripheralBlock(true,@"连接成功!",peripheral);
        connectCBPeripheralBlock = nil;
    }
    
    for (NSMutableDictionary * mdic in self.isConnects) {
        if ([mdic[@"peripheral"] isEqual:peripheral]) {
            [mdic setValue:@(true) forKey:@"isconnect"];
            break ;
        }
    }

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

//    NSLog(@"didUpdateNotificationStateForCharacteristic");
    if (error) {
        NSLog(@"error : %@",error);
    } else{

        for (NSDictionary *dic in self.connectingDics) {

            CBPeripheral *peripheraler = [dic valueForKey:@"peripheral"];

            if ([peripheral.identifier isEqual:peripheraler.identifier]) {

                CBCharacteristic *receiveChar = dic[@"receiveCharacteristc"];
                CBCharacteristic *sendChar = dic[@"sendCharacteristc"];

                if ([characteristic isEqual:receiveChar]) {

                    if (self.didResponse) {
                        self.didResponse(self, peripheral, characteristic);
                    }

                } else if ([characteristic isEqual:sendChar]){

                    if (self.didRequest) {
                        self.didRequest(self, peripheral,characteristic);
                    }
                } else{

                    if (self.didUnknownCharacter) {
                        self.didUnknownCharacter(self, peripheral, characteristic);
                    }
                }
                break ;
            }
        }
        
    }
}

//withoutResponse to this method
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{

    if (error) {
        LRLog(@"didUpdateValueForCharacteristic error:%@",error);
        return;
    }
    else{
//        LRLog(@"didUpdateValue - %@ : %@",peripheral.name,characteristic.value.description);

//        Byte *recByte = (Byte *)[characteristic.value bytes];
//        NSLog(@"recByte : %s",recByte);

//        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
//        LRLog(@"%@ %@",result,characteristic.value.description);

        for (NSDictionary *dic in self.connectingDics) {

            CBPeripheral *peripheraler = [dic valueForKey:@"peripheral"];

            if ([peripheral.identifier isEqual:peripheraler.identifier]) {

                CBCharacteristic *receiveChar = dic[@"receiveCharacteristc"];
                CBCharacteristic *sendChar = dic[@"sendCharacteristc"];

                if ([characteristic isEqual:receiveChar]) {

                    if (self.didResponse) {
                        self.didResponse(self, peripheral, characteristic);
                    }

                } else if ([characteristic isEqual:sendChar]){

                    if (self.didRequest) {
                        self.didRequest(self, peripheral,characteristic);
                    }
                } else{

                    if (self.didUnknownCharacter) {
                        self.didUnknownCharacter(self, peripheral, characteristic);
                    }
                }
                break ;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{

    NSLog(@"didWriteValueForCharacteristic:");
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        return;
    }
//    else {
//        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
//        LRLog(@"result : %@",result);
//    }
}



#pragma mark ----- Outside method
- (void)startScan{
//    NSLog(@"start scan");
    NSDictionary *options=@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void)connectCBPeripheral:(CBPeripheral *)peripheral Block:(void (^)(bool, NSString *, CBPeripheral *))block{
    if (peripheral == nil) {
        LRLog(@"can`t connect nil peripheral");
        return ;
    }
    connectCBPeripheralBlock = block;
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)connectCBPeripheral:(CBPeripheral *)peripheral OverTime:(NSTimeInterval)time Queue:(dispatch_queue_t)queue Result:(void (^)(bool, NSString *, CBPeripheral *))result{
    
    if (!peripheral) {
        LRLog(@"can`t connect nil peripheral");
        return ;
    }
    connectCBPeripheralBlock = result;
    [self.centralManager connectPeripheral:peripheral options:nil];
    
    [self.isConnects addObject:@{@"peripheral":peripheral,@"isconnect":@(false)}.mutableCopy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), queue, ^{
        for (NSMutableDictionary * mdic in self.isConnects) {
            if ([mdic[@"peripheral"] isEqual:peripheral]) {
                if (![mdic[@"isconnect"] boolValue]) {
                    if (result) {
                        result(false,@"Connection timed out !",peripheral);
                    }
                    [self.centralManager cancelPeripheralConnection:peripheral];
                }
                break ;
            }
        }
    });
}

- (void)cancelConnectCBPeripheral:(CBPeripheral *)peripheral{
    if (!peripheral) {
        LRLog(@"空的蓝牙设备，不能取消连接!");
        return ;
    }
    [self.centralManager cancelPeripheralConnection:peripheral];
}

- (void)queryWithData:(NSData *)data CBPeripheral:(CBPeripheral *)peripheral{

    if (peripheral.state != CBPeripheralStateConnected) {
        return;
    }

    for (NSDictionary *dic in self.connectingDics) {
        CBPeripheral *peripheraler = [dic valueForKey:@"peripheral"];
        if ([peripheral.identifier isEqual:peripheraler.identifier]) {
            CBCharacteristic *sendCharacter = [dic valueForKey:@"sendCharacteristc"];
            if (sendCharacter) {
                [peripheral writeValue:data forCharacteristic:sendCharacter type:CBCharacteristicWriteWithoutResponse];
            }
            break ;
        }
    }
}

- (void)disConnectCBPeripheral:(CBPeripheral *)peripheral{
    if (peripheral) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    } else {
        LRLog(@"disconnect peripheral fail ! peripheral is nil !");
    }
}

@end
