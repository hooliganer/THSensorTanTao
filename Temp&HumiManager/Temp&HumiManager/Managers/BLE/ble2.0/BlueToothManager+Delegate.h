//
//  BlueToothManager+Delegate.h
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BlueToothManager.h"

@interface BlueToothManager (Delegate)
<CBPeripheralDelegate,CBCentralManagerDelegate>

@end
