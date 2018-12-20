//
//  BLEManager.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/14.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEManager : NSObject

@property (nonatomic,copy)void(^discoverdPeipheral)(CBPeripheral *peripheral);


@end
