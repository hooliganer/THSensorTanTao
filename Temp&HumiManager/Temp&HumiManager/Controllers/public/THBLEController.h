//
//  THBLEController.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MySuperController.h"
#import "BLEManager.h"

@interface THBLEController : MySuperController

@property (nonatomic,copy)void(^didSelectBlueTooth)(MyPeripheral *periInfo);

@end
