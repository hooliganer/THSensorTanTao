//
//  BLEPeripheralInfo.m
//  MedicalTreatmentProject
//
//  Created by 谭滔 on 2017/8/21.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "BLEPeripheralInfo.h"

@interface BLEPeripheralInfo ()

/**
 * 设备的Mac地址（广播包里的）
 */
@property (nonatomic, copy,readwrite) NSString *macAddress;

@end

@implementation BLEPeripheralInfo

- (void)setManufacture:(NSData *)manufacture{
    _manufacture = manufacture;
    self.macAddress = [self getMacWithManufactureData:manufacture];
}

- (NSString *)getMacWithManufactureData:(NSData *)data{

    NSString *manuString;
    const char *charMac = [[data description] cStringUsingEncoding:NSUTF8StringEncoding];
    if (charMac == nil) {
        return nil;
    }
    manuString = [[NSString alloc]initWithUTF8String:charMac];
//    NSLog(@"%@",manuString);
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


@end
