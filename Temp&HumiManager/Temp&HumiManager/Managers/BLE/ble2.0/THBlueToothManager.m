//
//  THBlueToothManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "THBlueToothManager.h"

@implementation THBlueToothManager

+ (THBlueToothManager *)sharedInstance{
    static THBlueToothManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[THBlueToothManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

@end
