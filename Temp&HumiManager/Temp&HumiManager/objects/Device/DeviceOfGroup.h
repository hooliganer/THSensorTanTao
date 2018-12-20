//
//  DeviceOfGroup.h
//  Temp&HumiManager
//
//  Created by terry on 2018/9/3.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceOfGroup : NSObject

@property (nonatomic,copy)NSString * rid;
@property (nonatomic,assign)NSTimeInterval utime;
@property (nonatomic,copy)NSString * tmac;
@property (nonatomic,copy)NSString * uuid;
@property (nonatomic,copy)NSString * sdata;

- (instancetype)initWithNewDevice:(DeviceOfGroup *)dev;

@end
