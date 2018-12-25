//
//  DetailWarnSetObject.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 terry. All rights reserved.
//

#import "DetailWarnSetObject.h"

@implementation DetailWarnSetObject

- (instancetype)init{
    if (self = [super init]) {
        self.temparature = -1000;
        self.humidity = -1000;
    }
    return self;
}

@end
