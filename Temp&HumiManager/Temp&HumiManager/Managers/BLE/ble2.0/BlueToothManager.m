//
//  BlueToothManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BlueToothManager.h"
#import "BlueToothManager+Extension.h"
#import "BlueToothManager+Delegate.h"


NSString * const HeartRate_Service = @"0000fff0-0000-1000-8000-00805f9b34fb";
NSString * const Request_Characteristic = @"0000fff6-0000-1000-8000-00805f9b34fb";
NSString * const Response_Characteristic = @"0000fff7-0000-1000-8000-00805f9b34fb";

@interface BlueToothManager ()

@property (nonatomic,readwrite,strong)NSMutableArray *connectingPeripherals;
@property (nonatomic,readwrite,strong)NSMutableArray <BlueToothInfo *>* discoveredPeripherals;

@end

@implementation BlueToothManager

- (instancetype)init{
    if (self = [super init]) {

        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.serviceUUIDs = [NSArray arrayWithObjects:[CBUUID UUIDWithString:HeartRate_Service], nil];
        self.characteristicUUIDs = @[[CBUUID UUIDWithString:Request_Characteristic],[CBUUID UUIDWithString:Response_Characteristic]];

        self.connectingPeripherals = [NSMutableArray array];
        self.discoveredPeripherals = [NSMutableArray array];
        

//        self.marrPeripheralInfos=[NSMutableArray array];
//        self.marrCBPeripherals=[NSMutableArray array];
//        self.marrManufatures=[NSMutableArray array];
    }
    return self;
}

#pragma mark - Outside Method

- (void)startScan{

    if (self.centralManager.state == CBCentralManagerStatePoweredOff) {
        LRLog(@"can`t scan,cause CBCentralManagerStatePoweredOff");
        return ;
    }

    NSDictionary * options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    //self.serviceUUIDs
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void)stopScan{
    [self.centralManager stopScan];
    [self.discoveredPeripherals removeAllObjects];
}

- (void)connetPeripheal:(CBPeripheral *)peripheral{

}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral{

}

- (void)queryData:(NSData *)data{
    
}


@end
