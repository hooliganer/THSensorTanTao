//
//  MainTableObject.m
//  Temp&HumiManager
//
//  Created by terry on 2018/9/1.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainTableObject.h"

@implementation MainTableObject

- (instancetype)init {
    if (self = [super init]) {
        self.devices = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Outside Method

- (int)powerBle{

    NSString * dataStr = [self bleDataString];

    if (dataStr.length >= 20 ) {
        int power = [[dataStr substringWithRange:NSMakeRange(18, 2)] toDecimalByHex];
        return power;
    } else {
        return -1000;
    }
}

- (float)temperatureBle{

    NSString * dataStr = [self bleDataString];

    if (dataStr.length >= 24 ) {

        bool positive = [[dataStr stringOfIndex:20] isEqualToString:@"0"];
        int temp = [[dataStr substringWithRange:NSMakeRange(21, 3)] toDecimalByHex];
        float temperature = positive?(temp/100.0):-(temp/100.0);
        return temperature;
    } else {
        return -1000;
    }
}

- (int)humidityBle{

    NSString * dataStr = [self bleDataString];

    if (dataStr.length >= 26 ) {
        int humi = [[dataStr substringWithRange:NSMakeRange(24, 2)] toDecimalByHex];
        return humi;
    } else {
        return -1000;
    }
}


#pragma mark - Inside Method
- (NSString *)bleDataString{

    NSData * data = [self.bleInfo.advertisementData valueForKey:@"kCBAdvDataManufacturerData"];

    if (data) {
        NSString *dataStr = [data.description getStringBetweenFormerString:@"<" AndLaterString:@">"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        return dataStr;
    } else {
        return nil;
    }
}

@end
