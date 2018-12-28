//
//  DetailInfoController.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MySuperController.h"
#import "MainCollectionObject.h"

@interface DetailInfoController : MySuperController

@property (nonatomic,strong)MainCollectionObject *curDevInfo;///<当前页面的设备

@property (nonatomic,strong)id deviceInfo;

@end
