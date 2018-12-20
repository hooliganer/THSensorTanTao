//
//  MyPeripheral.m
//  TestAll
//
//  Created by terry on 2018/5/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyPeripheral.h"

@interface MyPeripheral ()

@property (nonatomic,copy,readwrite) NSString *macAddress;
@property (nonatomic,strong,readwrite)NSData *manufacture;

@end

@implementation MyPeripheral

- (void)setAdvertisement:(NSDictionary *)advertisement{
    _advertisement = advertisement;
    self.manufacture = advertisement[@"kCBAdvDataManufacturerData"];
    self.macAddress = [self getMacWithManufactureData:self.manufacture];
}

- (NSString *)getMacWithManufactureData:(NSData *)data{

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

- (NSString *)manuString{
    if (self.manufacture) {
        const char * charString = [[self.manufacture description] cStringUsingEncoding:NSUTF8StringEncoding];
        if (charString) {
            NSString *manuString = [[NSString alloc]initWithUTF8String:charString];
            manuString = [manuString stringByReplacingOccurrencesOfString:@" " withString:@""];
            manuString = [manuString stringByReplacingOccurrencesOfString:@"<" withString:@""];
            manuString = [manuString stringByReplacingOccurrencesOfString:@">" withString:@""];
            return manuString;
        } else{
            return nil;
        }
    }
    return nil;
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


- (bool)isEqualToPeripheral:(MyPeripheral *)peripheral{
    return [self.peripheral.identifier isEqual:peripheral.peripheral.identifier];
}

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


- (NSString *)bleDataString{

    NSData * data = [self.advertisement valueForKey:@"kCBAdvDataManufacturerData"];

    if (data) {
        NSString *dataStr = [data.description getStringBetweenFormerString:@"<" AndLaterString:@">"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        return dataStr;
    } else {
        return nil;
    }
}


@end
