//
//  BlueToothInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothInfo : NSObject

@property (nonatomic,strong) NSNumber * rssi;
@property (nonatomic,strong) CBPeripheral * peripheral;
@property (nonatomic,strong) NSDictionary * advertisementData;


/*!
 * 根据advertisementData获得Mac
 */
- (NSString *)mac;

/*!
 * 通过rssi计算距离
 */
- (double)distanceByRSSI;


- (int)powerBle;

- (float)temperatureBle;

- (int)humidityBle;




@end
