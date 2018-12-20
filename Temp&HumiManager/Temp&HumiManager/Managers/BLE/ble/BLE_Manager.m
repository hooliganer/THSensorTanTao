//
//  BLE_Manager.m
//  HomeKitSystem
//
//  Created by 谭滔 on 2017/11/29.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "BLE_Manager.h"

NSString * const heartRateService = @"0000fff0-0000-1000-8000-00805f9b34fb";
//请求数据
NSString * const requestCharacteristic = @"0000fff6-0000-1000-8000-00805f9b34fb";
//返回数据
NSString * const responseCharacteristic = @"0000fff7-0000-1000-8000-00805f9b34fb";

@interface BLE_Manager ()
<
CBPeripheralDelegate,
CBCentralManagerDelegate
>
@property (nonatomic,strong)CBCentralManager *centralManager;
@property (nonatomic,strong)CBPeripheralManager *peripheralManager;

@property (nonatomic,strong)NSMutableArray *marrPeripheralInfos;
@property (nonatomic,strong)NSMutableArray *marrCBPeripherals;
@property (nonatomic,strong)NSMutableArray *marrManufatures;

@property (nonatomic,strong)CBPeripheral *currentPeripheral;
@end


@implementation BLE_Manager
{
    NSArray *serviceUUIDs;
    NSArray *characteristicUUIDs;
    
    CBCharacteristic *sendCharacteristic;
    CBCharacteristic *receiveCharacteristic;
    
    void(^didSearchedDevices)(NSArray *,NSArray *);
    void(^didSearchedDevice)(BLEPeripheralInfo *,CBPeripheral *);

    void(^connectCBPeripheralBlock)(bool,NSString *,CBPeripheral *);///<链接设备成功与否 回调
    void(^disConnectCBPeripheralBlock)(bool,NSString *,CBPeripheral *);///<断开设备成功与否 回调

    void(^querySendBlock)(CBPeripheral *,NSData *);///<发送指令回调
}

+ (BLE_Manager *)shareInstance{
    static BLE_Manager *bleMNG=nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        bleMNG=[[BLE_Manager alloc]init];
    });
    return bleMNG;
}

- (instancetype)init{
    if (self=[super init]) {
        
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        serviceUUIDs = [NSArray arrayWithObjects:[CBUUID UUIDWithString:heartRateService], nil];
        characteristicUUIDs = @[[CBUUID UUIDWithString:requestCharacteristic],[CBUUID UUIDWithString:responseCharacteristic]];

        self.marrPeripheralInfos=[NSMutableArray array];
        self.marrCBPeripherals=[NSMutableArray array];
        self.marrManufatures=[NSMutableArray array];
        
    }
    return self;
}

#pragma mark - outside method
/*!
 * 搜索设备，返回 BLEPeripheralInfo 的数组和 CBPeripheral 的数组
 */
- (void)searchBLEDeviceWithBlock:(void (^)(NSArray<BLEPeripheralInfo *> *, NSArray<CBPeripheral *> *))block{

    switch (self.centralManager.state) {
        case CBCentralManagerStatePoweredOff:
//            NSLog(@"BLE PoweredOff");
            return;
            break;

        default:
            break;
    }
    
    didSearchedDevices = block;
    
    [self cleanDatas];

    NSDictionary *options=@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};

    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void)searchBLEPeripheralBlock:(void (^)(BLEPeripheralInfo *, CBPeripheral *))block{

    if (@available(iOS 9.0, *)) {
        if (self.centralManager.isScanning) {
            [self.centralManager stopScan];
        }
    } else {
        [self.centralManager stopScan];
    }


    if (_centralManager.state == CBCentralManagerStatePoweredOff) {
        NSLog(@"BLE PoweredOff");
        return;
    }

    didSearchedDevice = block;

    [self cleanDatas];

    NSDictionary *options=@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};

    [self.centralManager scanForPeripheralsWithServices:nil options:options];

}

- (void)connectCBPeripheral:(CBPeripheral *)peripheral Block:(void (^)(bool, NSString *, CBPeripheral *))block{
    if (peripheral) {
        connectCBPeripheralBlock = block;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)disConnectCBPerihperal:(CBPeripheral *)peripheral Block:(void (^)(bool, NSString *, CBPeripheral *))block{
    if (peripheral) {
        disConnectCBPeripheralBlock = block;
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)queryWithData:(NSData *)data CBPeripheral:(CBPeripheral *)peripheral Block:(void (^)(CBPeripheral *, NSData *))block{
    
    if (peripheral.state != CBPeripheralStateConnected) {
//        if ([self.myBleDelegate respondsToSelector:@selector(didDisconnectDevice)]) {
//            [self.myBleDelegate didDisconnectDevice];
//        }
        return;
    }
    querySendBlock = block;

    for (NSDictionary *dic in self.currentPerips) {
        CBPeripheral *peripheraler = [dic valueForKey:@"peripheral"];
        if ([peripheral.identifier isEqual:peripheraler.identifier]) {
            CBCharacteristic *sendCharacter = [dic valueForKey:@"sendCharacteristic"];
            if (sendCharacter) {
                [peripheral writeValue:data forCharacteristic:sendCharacter type:CBCharacteristicWriteWithoutResponse];
            }
            break ;
        }
    }
}

#pragma mark InSide Mehtod
- (void)cleanDatas{
    if (self.marrCBPeripherals) {
        [self.marrCBPeripherals removeAllObjects];
    }
    if (self.marrPeripheralInfos) {
        [self.marrPeripheralInfos removeAllObjects];
    }
    if (self.marrManufatures) {
        [self.marrManufatures removeAllObjects];
    }

}

- (void)startScans{
    
    [self cleanDatas];
    if (self.centralManager.state == CBCentralManagerStatePoweredOff) {
        return;
    }
    NSDictionary *options=@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

#pragma mark <CBCentralManagerDelegate>
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{

    if (@available(iOS 10.0, *)) {
        switch (central.state) {
            case CBManagerStatePoweredOn:
                [self startScans];
                break;
            case CBManagerStatePoweredOff:
            {
                if ([self.delegate respondsToSelector:@selector(manager:CBManagerPoweredOff:)]) {
                    [self.delegate manager:self CBManagerPoweredOff:central];
                } else{
                    NSLog(@"蓝牙未打开");
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
                [self startScans];
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

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI{

    if ([self.marrCBPeripherals containsObject:peripheral]) {
        return ;
    }

//    NSLog(@"%@",peripheral.name);

    BLEPeripheralInfo *info = [[BLEPeripheralInfo alloc]init];
    info.name = peripheral.name;
    info.uuid = peripheral.identifier.UUIDString;
    info.rssi = RSSI;
    info.manufacture = advertisementData[@"kCBAdvDataManufacturerData"];
    info.peripheral = peripheral;

    [self.marrPeripheralInfos addObject:info];
    [self.marrCBPeripherals addObject:peripheral];

    if (didSearchedDevice) {
        didSearchedDevice(info,peripheral);
    }
    
    if (didSearchedDevices) {
        didSearchedDevices(self.marrPeripheralInfos,self.marrCBPeripherals);
    }
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    _currentPeripheral=peripheral;
    _currentPeripheral.delegate=self;
    [peripheral discoverServices:serviceUUIDs];
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (connectCBPeripheralBlock) {
        connectCBPeripheralBlock(false,error.description,peripheral);
        connectCBPeripheralBlock = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (error) {
        if (disConnectCBPeripheralBlock) {
            disConnectCBPeripheralBlock(false,error.description,peripheral);
        }
    } else{
        if (disConnectCBPeripheralBlock) {
            disConnectCBPeripheralBlock(true,@"断开连接成功!",peripheral);
        }
    }
    
}

#pragma mark <CBPeripheralDelegate>
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"service error:%@",error.userInfo);
        return ;
    }
    for (CBService *service in peripheral.services) {
        [_currentPeripheral discoverCharacteristics:characteristicUUIDs forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error{
    
//    NSLog(@"%@",service);
//    NSLog(@"%@",service.characteristics);
//    NSLog(@"%@",service.includedServices);

    if (self.currentPerips == nil) {
        self.currentPerips = [NSMutableArray array];
    }
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];

    for (int i=0; i<service.characteristics.count; i++) {

        CBCharacteristic *character = service.characteristics[i];
        
        if ([character.UUID isEqual:
             [CBUUID UUIDWithString:requestCharacteristic]]) {
            //NSLog(@"--send-- %@", character);
            sendCharacteristic = character;
            [mdic setValue:character forKey:@"sendCharacteristic"];
        }
        else if([character.UUID isEqual:
                 [CBUUID UUIDWithString:responseCharacteristic]]) {
//            NSLog(@"--recieve-- %@", character);
            receiveCharacteristic = character;
            //回传接口始终处于监测状态，didUpdateNotificationStateForCharacteristic:方法回传
            [peripheral setNotifyValue:YES forCharacteristic:character];
            [mdic setValue:character forKey:@"receiveCharacteristic"];
        }
        else{
            if (i==0) {
                sendCharacteristic = character;
                [mdic setValue:character forKey:@"sendCharacteristic"];
            }
            else{
                receiveCharacteristic=character;
                [peripheral setNotifyValue:YES forCharacteristic:character];
                [mdic setValue:character forKey:@"receiveCharacteristic"];
            }
            
        }
    }

    [mdic setValue:peripheral forKey:@"peripheral"];

    [self.currentPerips addObject:mdic];

    if (connectCBPeripheralBlock) {
        connectCBPeripheralBlock(true,@"连接成功!",peripheral);
        connectCBPeripheralBlock = nil;
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

    NSLog(@"didUpdateNotificationStateForCharacteristic");
    if (error) {
        NSLog(@"error : %@",error);
    } else{
//        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
//        NSLog(@"characteristic : %@",characteristic);
        NSLog(@"description : %@",characteristic.value.description);
//        NSLog(@"result : %@",result);
    }
}

//withoutResponse to this method
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{

//    NSLog(@"didUpdateValueForCharacteristic");
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        return;
    }
    else{

        NSLog(@"%@ : %@",peripheral.name,characteristic.value.description);

//        Byte *recByte = (Byte *)[characteristic.value bytes];
//        NSLog(@"recByte : %s",recByte);
        
//        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",result);

        for (NSDictionary *dic in self.currentPerips) {

            CBPeripheral *peripheraler = [dic valueForKey:@"peripheral"];

            CBCharacteristic *receiveChar = dic[@"receiveCharacteristic"];
            CBCharacteristic *sendChar = dic[@"sendCharacteristic"];

//            NSLog(@"--UUID-- : %@",receiveChar.UUID);

            if ([peripheral.identifier isEqual:peripheraler.identifier]) {

                if ([characteristic isEqual:receiveChar]) {
//                     NSLog(@"--recieve-- %@", receiveChar.value.description);

                    if (self.didResponse) {
                        self.didResponse(peripheral, characteristic,self);
                    }

                } else if ([characteristic isEqual:sendChar]){
//                     NSLog(@"--send-- %@", receiveChar.value.description);

                    if (self.didRequest) {
                        self.didRequest(peripheral, characteristic,self);
                    }
                } else{
                    NSLog(@"unkown characteristic : %@",characteristic);
                }
//                if (querySendBlock) {
//                    querySendBlock(peripheral,characteristic.value);
//                }
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
}







@end
