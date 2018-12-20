//
//  MainViewData.m
//  Temp&HumiManager
//
//  Created by terry on 2018/7/10.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewData.h"

@implementation MainViewData

- (instancetype)init{
    if (self = [super init]) {
        self.tempUnit = @"˚C";
    }
    return self;
}

- (TH_BLEData)getBLEData{

    TH_BLEData tbd = TH_BLEDataMake(0, 0, 0);
    if (self.periInfo.manufacture) {

        NSString *dataStr = [self.periInfo.manufacture.description getStringBetweenFormerString:@"<" AndLaterString:@">"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];

        if (dataStr.length >= 20 ) {
            int power = [[dataStr substringWithRange:NSMakeRange(18, 2)] toDecimalByHex];
            tbd.power = power;
        }

        if (dataStr.length >= 24 ) {

            bool positive = [[dataStr stringOfIndex:20] isEqualToString:@"0"];
            int temp = [[dataStr substringWithRange:NSMakeRange(21, 3)] toDecimalByHex];
            float temperature = positive?(temp/100.0):-(temp/100.0);
            tbd.temperature = temperature;
        }

        if (dataStr.length >= 26) {
            int humi = [[dataStr substringWithRange:NSMakeRange(24, 2)] toDecimalByHex];
            tbd.humidity = humi;
        }
    }
    return tbd;
}

@end
