//
//  BlueToothManager+Delegate.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BlueToothManager+Delegate.h"
#import "BlueToothManager+Extension.h"

@implementation BlueToothManager (Delegate)

#pragma mark - <CBCentralManagerDelegate>
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {

    if (@available(iOS 10.0, *)) {
        switch (central.state) {
            case CBManagerStateUnknown:
            {
                LRLog(@"CBManagerStateUnknown");
            }
                break;
            case CBManagerStatePoweredOn:
            {
                [self startScan];
            }
                break;

            default:
                break;
        }
    } else {
        switch (central.state) {
            case CBCentralManagerStateUnknown:
            {
                LRLog(@"CBCentralManagerStateUnknown");
            }
                break;
            case CBCentralManagerStatePoweredOn:
            {
                [self startScan];
            }
                break;


            default:
                break;
        }
    }

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{

    //按蓝牙名称过滤设备
    if (![peripheral.name containsString:@"PX-HP"]) {
        return ;
    }

    ContainStruct cs = [self containPeripheral:peripheral];
    BlueToothInfo * info;

    //新设备
    if (!cs.isExist) {
        info = [[BlueToothInfo alloc]init];
        info.peripheral = peripheral;
        info.rssi = RSSI;
        info.advertisementData = advertisementData;
        [self.discoveredPeripherals addObject:info];
    } else{
        info = self.discoveredPeripherals[cs.index];
        info.peripheral = peripheral;
        info.rssi = RSSI;
        info.advertisementData = advertisementData;
    }
    if (self.discoveredPeripheral) {
        self.discoveredPeripheral(self, info);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{

    peripheral.delegate = self;
    [peripheral discoverServices:self.serviceUUIDs];
}

#pragma mark <CBCentralManagerDelegate>

#pragma mark <CBPeripheralDelegate>
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{

    if (error) {
        NSLog(@"didDiscoverServices error:%@",error.userInfo);
        return ;
    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:self.characteristicUUIDs forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error{

    CBUUID * requestUUID = nil;//[CBUUID UUIDWithString:Request_Characteristic];
    CBUUID * responseUUID = nil;//[CBUUID UUIDWithString:Response_Characteristic];

    for (CBCharacteristic *character in service.characteristics) {
        if ([requestUUID isEqual:character.UUID]) {
            //request
        }
        else if ([responseUUID isEqual:character.UUID]){
            //response
            //回传接口始终处于监测状态，didUpdateNotificationStateForCharacteristic:方法回传
            [peripheral setNotifyValue:true forCharacteristic:character];
        }
        else{
            NSInteger index = [service.characteristics indexOfObject:character];
            if (index == 0) {
                //request
            } else {
                //response
                [peripheral setNotifyValue:true forCharacteristic:character];
            }
        }
    }

    [self.connectingPeripherals addObject:peripheral];

    if (self.didConnectPeripheral) {
        self.didConnectPeripheral(self,peripheral);
    }

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

    if (error) {
        NSLog(@"didUpdateNotificationStateForCharacteristic - error : %@",error);
    } else{
        NSLog(@"didUpdateNotificationStateForCharacteristic - description : %@",characteristic.value.description);
    }
}

//withoutResponse to this method
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{

    if (error) {
        NSLog(@"didUpdateValueForCharacteristic - error : %@", error.localizedFailureReason);
        return;
    }
    else{

        if (self.didGetData) {
            self.didGetData(self,characteristic);
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

//for (NSDictionary *dic in self.currentPerips) {
//
//    CBPeripheral *peripheraler = [dic valueForKey:@"peripheral"];
//
//    CBCharacteristic *receiveChar = dic[@"receiveCharacteristic"];
//    CBCharacteristic *sendChar = dic[@"sendCharacteristic"];
//
//    //            NSLog(@"--UUID-- : %@",receiveChar.UUID);
//
//    if ([peripheral.identifier isEqual:peripheraler.identifier]) {
//
//        if ([characteristic isEqual:receiveChar]) {
//            //                     NSLog(@"--recieve-- %@", receiveChar.value.description);
//
//            if (self.didResponse) {
//                self.didResponse(peripheral, characteristic,self);
//            }
//
//        } else if ([characteristic isEqual:sendChar]){
//            //                     NSLog(@"--send-- %@", receiveChar.value.description);
//
//            if (self.didRequest) {
//                self.didRequest(peripheral, characteristic,self);
//            }
//        } else{
//            NSLog(@"unkown characteristic : %@",characteristic);
//        }
//        //                if (querySendBlock) {
//        //                    querySendBlock(peripheral,characteristic.value);
//        //                }
//        break ;
//    }
//}




#pragma methods
- (ContainStruct)containPeripheral:(CBPeripheral *)peri{
    ContainStruct cs = ContainStructMake(0, false);
    for (NSInteger i=0;i<self.discoveredPeripherals.count;i++) {
        BlueToothInfo * info = [self.discoveredPeripherals objectAtIndex:i];
        if ([peri.identifier isEqual:info.peripheral.identifier]) {
            cs.index = i;
            cs.isExist = true;
        }
    }
    return cs;
}


@end
