//
//  BlueToothInfo.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "BlueToothInfo.h"

@interface BlueToothInfo ()

@end

@implementation BlueToothInfo

- (void)setAdvertisementData:(NSDictionary *)advertisementData{
    _advertisementData = advertisementData;
}


#pragma mark - Outside Method
- (NSString *)mac{

    NSData * data = [self.advertisementData valueForKey:@"kCBAdvDataManufacturerData"];
    if (!data) {
        return nil;
    }

    NSString *manuString;
    const char *charMac = [[data description] cStringUsingEncoding:NSUTF8StringEncoding];
    if (charMac == nil) {
        return nil;
    }

    manuString = [[NSString alloc]initWithUTF8String:charMac];
    manuString = [manuString stringByReplacingOccurrencesOfString:@" " withString:@""];
    manuString = [manuString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    manuString = [manuString stringByReplacingOccurrencesOfString:@">" withString:@""];

    if (manuString.length >= 16) {
        NSString *mac=[manuString substringWithRange:NSMakeRange(4, 12)];
        return mac;
    }
    else{
        return  nil;
    }
}

/*!
 * 通过rssi计算距离
 */
- (double)distanceByRSSI{

    /*
     * d = 10^((abs(RSSI) - A) / (10 * n))
     * d - 计算所得距离
     * RSSI - 接收信号强度（负值
     * A - 发射端和接收端相隔1米时的信号强度
     * n - 环境衰减因子
     * 通过实验，A值的最佳范围为45—49，n值最佳范围为3.25—4.5，N在15---25。
     */
    double A = 47;
    double n = 3.875;
    double zs = (abs([self.rssi intValue]) - A) / (10 * n);
    return pow(10, zs);

}



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

    NSData * data = [self.advertisementData valueForKey:@"kCBAdvDataManufacturerData"];

    if (data) {
        NSString *dataStr = [data.description getStringBetweenFormerString:@"<" AndLaterString:@">"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        return dataStr;
    } else {
        return nil;
    }
}




@end
