//
//  DetailInfoController+BGBLE.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//

#import "DetailInfoController+BGBLE.h"
#import "DetailInfoController+Extension.h"
#import "DetailInfoController+UI.h"

#import "DeviceDB+CoreDataClass.h"
#import "WarnRecordSetDB+CoreDataClass.h"
#import "WarnHistoryRecordDB+CoreDataClass.h"

#import "BLEManager.h"

@implementation DetailInfoController (BGBLE)

#pragma mark - 蓝牙请求
- (void)startBLE{
    
    BLEManager *manager = [BLEManager shareInstance];
    
    //设置蓝牙的回调
    
    LRWeakSelf(self);
    manager.didResponse = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        
        if (characteristic.value == nil) {
            return ;
        }
        //        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
        //        NSLog(@"response : %@ %@",result,characteristic.value.description);
        
        Byte *recByte = (Byte *)[characteristic.value bytes];
        if (recByte[0] != 'P' && recByte[1] != 'X') {
            return ;
        }
        
        //实时温湿度
        if (recByte[3] == 'P' && recByte[4] == 'S') {
            [weakself parseBLETHData:characteristic.value];
        }
        //历史数据
        else if (recByte[3] == 'M' && recByte[4] == 'S')
        {
            weakself.isBLEHistory = true;
            [weakself parseHistoryDataWithData:characteristic.value];
        }
        
    };
    
    manager.didRequest = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        NSLog(@"request : %@",characteristic.value.description);
    };
    
    manager.didUnknownCharacter = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        //LRLog(@"unkonwn : %@",characteristic.value.description);
    };
    
    //开始请求蓝牙历史数据
    [self queryHistoryDataWithStart:true];
    //蓝牙实时数据
    [self queryBLET_HData];
    
    
//    // 介绍 :假装返回数据
//
//    NSString * mac = self.deviceInfo[@"mac"];
//    for (int i=0; i<arc4random()%10+10; i++) {
//
//        float tp = (arc4random()%50 + 5);
//        int hm = arc4random()%95 + 5;
//        float hours = arc4random()%2400/100.0;
//        int days = arc4random()%30;
//        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - hours*3600.0 - 86400*days;
//
//        //从本地查询 当前设备对应时间戳 的历史数据
//        NSArray <WarnHistoryRecordDB *>* records = [WarnHistoryRecordDB readAllByMac:mac Time:interval];
//        //如果没有，则证明是未保存的，进行存储
//        if (records.count == 0) {
//            WarnHistoryRecordDB * whd = [WarnHistoryRecordDB newWarnHistoryRecord];
//            whd.time = interval;
//            whd.temparature = tp;
//            whd.humidity = hm;
//            whd.mac = mac;
//            [whd save];
//        }
//    }
    
    
}

#pragma mark - 本地数据库信息操作
- (void)readLocalInfo{
    
//    [DeviceDB deleteByMac:@"df36fbc37df"];
//    [WarnRecordSetDB deleteAll];
//
//    for (DeviceDB * dd in [DeviceDB readAll]) {
//        NSLog(@"%@ %@ %lu",dd.dbName,dd.mac,dd.warnSetRecords.count);
//    }
//
//    for (WarnRecordSetDB *dd in [WarnRecordSetDB readAll]) {
//        NSLog(@"%@ %f %f",dd.mac,dd.settime,dd.tempMin);
//    }
    
    DeviceDB * dd = [DeviceDB readBymac:[self macFromPeripheral]];
    if (dd) {
        [self refreshInfoByLocalDevice:dd];
    } else {
        MyPeripheral * peripheral = (MyPeripheral *)self.deviceInfo;
        if (peripheral.macAddress.length > 0) {
            
            bool iswarn = self.editer.switcher.isOn;
            float tpMin = [self.editer.limitTemp.tfLess_textField.text floatValue];
            float tpMax = [self.editer.limitTemp.tfMore_textField.text floatValue];
            float hmMin = [self.editer.limitHumi.tfLess_textField.text floatValue];
            float hmMax = [self.editer.limitHumi.tfMore_textField.text floatValue];
            
            dd = [DeviceDB newDevice];
            dd.mac = peripheral.macAddress;
            dd.dbName = peripheral.peripheral.name ?peripheral.peripheral.name : peripheral.peripheral.identifier.UUIDString;
            dd.devType = self.editer.type;
            dd.tempTime = [[NSDate date] timeIntervalSince1970];
            dd.humiTime = [[NSDate date] timeIntervalSince1970];
            dd.isWarn = iswarn;
            dd.lessTemper = tpMin;
            dd.overTemper = tpMax;
            dd.lessHumidi = hmMin;
            dd.overHumidi = hmMax;
            
            [dd save];
            
        } else {
            LRLog(@"空Mac的蓝牙设备！不进行保存至本地!");
        }
    }
}

- (void)saveLocalInfo{
    
    NSString * mac = [self macFromPeripheral];
    NSString * name = self.editer.tfName.text;
    bool iswarn = self.editer.switcher.isOn;
    float tpMin = [self.editer.limitTemp.tfLess_textField.text floatValue];
    float tpMax = [self.editer.limitTemp.tfMore_textField.text floatValue];
    float hmMin = [self.editer.limitHumi.tfLess_textField.text floatValue];
    float hmMax = [self.editer.limitHumi.tfMore_textField.text floatValue];
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    int type = self.editer.type;
    
    //根据Mac先从本地读
    DeviceDB * dd = [DeviceDB readBymac:mac];
    if (!dd) {
        dd = [DeviceDB newDevice];
    }
    dd.mac = mac;
    dd.dbName = name;
    dd.isWarn = iswarn;
    dd.lessTemper = tpMin;
    dd.overTemper = tpMax;
    dd.lessHumidi = hmMin;
    dd.overHumidi = hmMax;
    dd.tempTime = time;
    dd.humiTime = time;
    dd.devType = type;
    
    WarnRecordSetDB * wd = [WarnRecordSetDB newWarnSetRecord];
    wd.mac = mac;
    wd.settime = time;
    wd.tempMax = tpMax;
    wd.tempMin = tpMin;
    wd.humiMin = hmMin;
    wd.humiMax = hmMax;
    wd.ison = iswarn;
    wd.device = dd;
    [wd save];
    
    [dd addWarnSetRecordsObject:wd];
    
}

- (void)readLocalTemparatureRecord{
    
    [self readLocalTHData:^(NSArray<WarnHistoryRecordDB *> *records) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            float max = [[records valueForKeyPath:@"@max.temparature"] floatValue];
            float min = [[records valueForKeyPath:@"@min.temparature"] floatValue];
            NSMutableArray <NSNumber *>* tps = [NSMutableArray array];
            for (WarnHistoryRecordDB * dd in records) {
                CGFloat percent;
                if ((max - min) == 0) {
                    if (max == 0) {
                        percent = 0;
                    } else {
                        percent = 1;
                    }
                } else {
                    percent = (dd.temparature - min)/(max - min);
                }
                [tps addObject:@(percent)];
            }
            [self.temperatureView.liner reDrawWithX:10 Y:10 Values:tps];
        });
        
    }];
    
    
}

- (void)readLocalHumidityRecord{
    
    [self readLocalTHData:^(NSArray<WarnHistoryRecordDB *> *records) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            float max = [[records valueForKeyPath:@"@max.humidity"] floatValue];
            float min = [[records valueForKeyPath:@"@min.humidity"] floatValue];
            NSMutableArray <NSNumber *>* tps = [NSMutableArray array];
            for (WarnHistoryRecordDB * dd in records) {
                CGFloat percent;
                if ((max - min) == 0) {
                    if (max == 0) {
                        percent = 0;
                    } else {
                        percent = 1;
                    }
                } else {
                    percent = (dd.humidity - min)/(max - min);
                }
                [tps addObject:@(percent)];
            }
            [self.humidityView.liner reDrawWithX:10 Y:10 Values:tps];
            
            
        });
        
    }];
}

- (void)readLocalWarnRecord{
    
    //先读出本地该时间段内所有温湿度数据
    LRWeakSelf(self);
    [My_AlertView showLoading:^(My_AlertView *loading) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(queue, ^{
            
            [weakself readLocalTHData:^(NSArray<WarnHistoryRecordDB *> *records) {
                
                NSString * mac = [weakself macFromPeripheral];//[self macFromPeripheral];
                
                //再读出所有报警设置的记录
                NSArray <WarnRecordSetDB *>* sets = [WarnRecordSetDB readAllOrderByMac:mac];
                NSMutableArray <DetailWarnSetObject *>* warns = [NSMutableArray array];
                for (WarnHistoryRecordDB * record in records) {
                    for (WarnRecordSetDB * set in sets) {
                        if (record.time >= set.settime) {
                            if (set.ison) {
                                DetailWarnSetObject * warn;
                                //温度判断是否超过阈值
                                if (record.temparature <= set.tempMin ||
                                    record.temparature >= set.tempMax) {
                                    if (!warn) {
                                        warn = [[DetailWarnSetObject alloc]init];
                                    }
                                    warn.temparature = record.temparature;
                                }
                                //湿度判断是否超过阈值
                                if (record.humidity <= set.humiMin ||
                                    record.humidity >= set.humiMax) {
                                    if (!warn) {
                                        warn = [[DetailWarnSetObject alloc]init];
                                    }
                                    warn.humidity = record.humidity;
                                }
                                if (warn) {
                                    warn.time = record.time;
                                    [warns addObject:warn];
                                }
                            }
                            break ;
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loading dismiss];
                    weakself.warnView.records = warns;
                    [weakself.warnView.collection reloadData];
                });
                
            }];
        });
    }];
    
    
}

- (void)readLocalTHData:(void(^)(NSArray <WarnHistoryRecordDB *>*records))block{
    
    NSString * mac = [self macFromPeripheral];//[self macFromPeripheral];
    
    NSTimeInterval last = self.segmentView.times.last;
    NSTimeInterval next = self.segmentView.times.next;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        //查时间段之内的所有温湿度记录
        NSArray * records = [WarnHistoryRecordDB readAllOrderByMac:mac Stime:last Etime:next];
        
        self.currentDatas = @[].mutableCopy;
        for (WarnHistoryRecordDB *wh in records) {
            DeviceInfo * dev = [[DeviceInfo alloc]init];
            dev.temparature = wh.temparature;
            dev.humidity = wh.humidity;
            dev.power = wh.power;
            dev.utime = wh.time;
            [self.currentDatas addObject:dev];
        }
        if (block) {
            block(records);
        }
    });
}

#pragma mark - 私有方法

/**
 根据本地数据库信息刷新信息

 @param info 信息
 */
- (void)refreshInfoByLocalDevice:(DeviceDB *)info{
    
    self.editer.tfName.text = info.dbName;
    self.editer.switcher.isOn = info.isWarn;
    self.editer.limitTemp.tfLess_textField.text = [NSString stringWithFormat:@"%.1f",info.lessTemper];
    self.editer.limitTemp.tfMore_textField.text = [NSString stringWithFormat:@"%.1f",info.overTemper];
    self.editer.limitHumi.tfLess_textField.text = [NSString stringWithFormat:@"%.1f",info.lessHumidi];
    self.editer.limitHumi.tfMore_textField.text = [NSString stringWithFormat:@"%.1f",info.overHumidi];
    self.editer.type = info.devType;
    
    self.topView.labTitle.text = info.dbName;
    
    
//    NSMutableArray <DetailWarnSetObject *>* records = @[].mutableCopy;
//    for (WarnRecordSetDB *dd in info.warnSetRecords) {
////        NSLog(@"%@ %f %f",dd.mac,dd.settime,dd.tempMin);
//        DetailWarnSetObject * objc = [[DetailWarnSetObject alloc]init];
//        objc.time = dd.settime;
//    }
    
}

/**
 根据蓝牙温湿度数据判断是否报警

 @param temp 蓝牙温度
 @param humi 蓝牙湿度
 */
- (void)judgeWhetherWarnByBLETemp:(float)temp Humi:(int)humi{
    
    if (self.editer.switcher.isOn) {
        float tempmax = [WarnRecordSetDB readAllOrderByMac:[self macFromPeripheral]].firstObject.tempMax;
        float tempmin = [WarnRecordSetDB readAllOrderByMac:[self macFromPeripheral]].firstObject.tempMax;
        float humimax = [WarnRecordSetDB readAllOrderByMac:[self macFromPeripheral]].firstObject.tempMax;
        float humimin = [WarnRecordSetDB readAllOrderByMac:[self macFromPeripheral]].firstObject.tempMax;
        if (temp <= tempmin || temp >= tempmax || humi <= humimin || humi >= humimax) {
            [self showIsWaner:true];
        } else {
            [self showIsWaner:false];
        }
    }
    
    
    
}

- (NSString *)macFromPeripheral{
//    NSDictionary * dic = self.deviceInfo;
//    return dic[@"mac"];
    MyPeripheral * peripheral = (MyPeripheral *)self.deviceInfo;
    return peripheral.macAddress;
}

/**
 请求蓝牙历史数据

 @param start 是开始还是结，true为开始，false为结束
 */
- (void)queryHistoryDataWithStart:(bool)start{
    
    //如果已经接收到了蓝牙历史数据，那么久不再请求蓝牙数据了
    //此处这么做是因为下方有递归本函数
    if (self.isBLEHistory) {
        return ;
    }
    
    NSString * strData = [NSString stringWithFormat:@"PX-MQ#%d",start?1:0];
    NSData * data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    
//    Byte * byte = (Byte *)[data bytes];
//    byte[6] = start?1:0;
//    data = [[NSData alloc]initWithBytes:byte length:7];
    
    //    NSString * queryStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    LRLog(@"请求历史数据:%@ -- %@",queryStr,data.description);
    
    MyPeripheral * peri = self.deviceInfo;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
       [[BLEManager shareInstance] queryWithData:data CBPeripheral:peri.peripheral];
    });
    
    //10秒之后还未接收到蓝牙历史数据，再请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryHistoryDataWithStart:true];
    });
    
}

/**
 请求蓝牙实时数据
 */
- (void)queryBLET_HData{
    NSString * str = @"PX-GS#I";
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        if ([self.deviceInfo isKindOfClass:[CBPeripheral class]]) {
            BLEManager * manager = [BLEManager shareInstance];
            [manager queryWithData:data CBPeripheral:self.deviceInfo];
        }
    });
}

/**
 解析蓝牙历史数据

 @param data 数据
 */
- (void)parseHistoryDataWithData:(NSData *)data{
    
//    //打印一下
//    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    LRLog(@"history result : %@",result);
//    LRLog(@"history record : %@",data.description);
    
    Byte *recByte = (Byte *)[data bytes];
    
    int number = recByte[6];
    NSDate *nowDate = [NSDate zoneDate];
    NSTimeInterval nowInterval = [nowDate timeIntervalSince1970];
    
    for (int i=0; i<3; i++) {
        
        //第几个小时记录的时间戳
        NSTimeInterval interval = nowInterval - (number+1) * (i+1) * 3600;
        
        float tp = ((recByte[7+i*3] & 0x7f) * 0x100 + (recByte[8+i*3] & 0xff))/100.0;
        int hm = recByte[9+i*3];
        
        if (tp == 0 && hm == 0) {
            LRLog(@"此记录无效不作记录:%@",data.description);
            continue ;
        }
        
        //从本地查询 当前设备对应时间戳 的历史数据
        NSArray <WarnHistoryRecordDB *>* records = [WarnHistoryRecordDB readAllByMac:[self macFromPeripheral] Time:interval];
        //如果没有，则证明是未保存的，进行存储
        if (records.count == 0) {
            WarnHistoryRecordDB * whd = [WarnHistoryRecordDB newWarnHistoryRecord];
            whd.time = interval;
            whd.temparature = tp;
            whd.humidity = hm;
            whd.mac = [self macFromPeripheral];
            [whd save];
        }
        
    }
}

/**
 解析蓝牙实时数据

 @param data 数据
 */
- (void)parseBLETHData:(NSData *)data{
    
    //从本地获取温度单位
    NSString * unit = [MyDefaultManager unit];
    
    NSString * dataStr = data.description;
    dataStr = [dataStr getStringBetweenFormerString:@"<" AndLaterString:@">"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /* 温湿度数据 eg : 50582d505323 894900 0a633462 */
    //PX-PS#
    if ([dataStr containsString:@"50582d505323"])
    {
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@"50582d505323" withString:@""];
    }
    else
    {
        return  ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        float temp = 0;
        if (dataStr.length >= 10) {
            bool positive = [[dataStr stringOfIndex:6] isEqualToString:@"0"];
            int tempInt = [[dataStr substringWithRange:NSMakeRange(7, 3)] toDecimalByHex];
            temp = positive?tempInt/100.0:-tempInt/100.0;
            self.topView.labTempar.text = [NSString stringWithFormat:@"%.1f%@",temp,unit];
        }
        
        int humi = 0;
        if (dataStr.length >= 12) {
            humi = [[dataStr substringWithRange:NSMakeRange(10, 2)] toDecimalByHex];
            self.topView.labHumi.text = [NSString stringWithFormat:@"%d%%",humi];
        }
        
        if (dataStr.length >= 14) {
            int power = [[dataStr substringWithRange:NSMakeRange(12, 2)] toDecimalByHex];
            self.topView.labPower.text = [NSString stringWithFormat:@"%d%%",power];
        }
        
        //刷新warning
        [self judgeWhetherWarnByBLETemp:temp Humi:humi];
    });
}



@end
