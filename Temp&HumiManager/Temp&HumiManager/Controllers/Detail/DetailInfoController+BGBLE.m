//
//  DetailInfoController+BGBLE.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//

#import "DetailInfoController+BGBLE.h"
#import "DetailInfoController+Extension.h"
#import "DeviceDB+CoreDataClass.h"
#import "WarnRecordSetDB+CoreDataClass.h"
#import "WarnHistoryRecordDB+CoreDataClass.h"
#import "BLEManager.h"

@implementation DetailInfoController (BGBLE)

- (void)startBLE{
    
    BLEManager *manager = [BLEManager shareInstance];
//    LRWeakSelf(self);
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
        
        //        NSLog(@"respnse : %@:%@",peripheral.name,characteristic.value.description);
        //实时温湿度
        if (recByte[3] == 'P' && recByte[4] == 'S') {
            
//            [weakself parseBLEData:characteristic.value];
        }
        //历史数据
        else if (recByte[3] == 'M' && recByte[4] == 'S')
        {
//            weakself.getBLEHistory = true;
//            [weakself parseHistoryDataWithData:characteristic.value];
        }
        
    };
    
    manager.didRequest = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        NSLog(@"request : %@",characteristic.value.description);
    };
    
    manager.didUnknownCharacter = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        //LRLog(@"unkonwn : %@",characteristic.value.description);
    };
    [self queryHistoryDataWithStart:true];
    
    
    // 介绍 :假装返回数据

    NSString * mac = self.deviceInfo[@"mac"];
    for (int i=0; i<arc4random()%10+3; i++) {
        
        float tp = (arc4random()%50 + 5);
        int hm = arc4random()%95 + 5;
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - arc4random()%10000*10;
        
        //从本地查询 当前设备对应时间戳 的历史数据
        NSArray <WarnHistoryRecordDB *>* records = [WarnHistoryRecordDB readAllByMac:mac Time:interval];
        //如果没有，则证明是未保存的，进行存储
        if (records.count == 0) {
            WarnHistoryRecordDB * whd = [WarnHistoryRecordDB newWarnHistoryRecord];
            whd.time = interval;
            whd.temparature = tp;
            whd.humidity = hm;
            whd.mac = mac;
            [whd save];
        }
    }
    
    
    
    
}

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
    
    NSDictionary * dic = self.deviceInfo;
    DeviceDB * dd = [DeviceDB readBymac:dic[@"mac"]];
    if (dd) {
        [self refreshInfoByLocalDevice:dd];
    }
}

- (void)saveLocalInfo{
    
    NSDictionary * dic = self.deviceInfo;
    NSString * mac = dic[@"mac"];
    NSString * name = dic[@"name"];
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


#pragma mark - 私有方法


- (void)refreshInfoByLocalDevice:(DeviceDB *)info{
    
    self.editer.tfName.text = info.dbName;
    self.editer.switcher.isOn = info.isWarn;
    self.editer.limitTemp.tfLess_textField.text = [NSString stringWithFormat:@"%.1f",info.lessTemper];
    self.editer.limitTemp.tfMore_textField.text = [NSString stringWithFormat:@"%.1f",info.overTemper];
    self.editer.limitHumi.tfLess_textField.text = [NSString stringWithFormat:@"%.1f",info.lessHumidi];
    self.editer.limitHumi.tfMore_textField.text = [NSString stringWithFormat:@"%.1f",info.overHumidi];
    self.editer.type = info.devType;
    
    
//    NSMutableArray <DetailWarnSetObject *>* records = @[].mutableCopy;
//    for (WarnRecordSetDB *dd in info.warnSetRecords) {
////        NSLog(@"%@ %f %f",dd.mac,dd.settime,dd.tempMin);
//        DetailWarnSetObject * objc = [[DetailWarnSetObject alloc]init];
//        objc.time = dd.settime;
//    }
    
}

- (NSString *)macFromPeripheral{
    MyPeripheral * peripheral = (MyPeripheral *)self.deviceInfo;
    return peripheral.macAddress;
}



/**
 请求蓝牙历史数据

 @param start 是开始还是结，true为开始，false为结束
 */
- (void)queryHistoryDataWithStart:(bool)start{
    LRWeakSelf(self);
    NSString * strData = [NSString stringWithFormat:@"PX-MQ#%d",start?1:0];
    NSData * data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    //    Byte *byte = (Byte *)[data bytes];
    //    byte[6] = isStart?1:0;
    //    data = [[NSData alloc]initWithBytes:byte length:7];
    
    //    NSString * queryStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    LRLog(@"请求历史数据:%@ -- %@",queryStr,data.description);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
       [[BLEManager shareInstance] queryWithData:data CBPeripheral:weakself.curDevInfo.bleInfo.peripheral];
    });
}


/**
 解析历史数据

 @param data 数据
 */
- (void)parseHistoryDataWithData:(NSData *)data{
    
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    LRLog(@"history result : %@",result);
    
    LRLog(@"history record : %@",data.description);
    
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
        
        
//        //从本地查询 当前设备对应时间戳 的历史数据
//        [[FMDB_HitoryRecord sharedInstance] selectWithDateInterval:interval Mac:self.curDevInfo.mac Block:^(NSArray<FMDB_HitoryRecord *> *hitories) {
//
//            //如果没有，则证明是未保存的，进行存储
//            if (hitories.count == 0) {
//                FMDB_HitoryRecord *record = [[FMDB_HitoryRecord alloc]initDatabase];
//                record.dateInterval = interval;
//                record.temperature = tp;
//                record.humidity = hm;
//                record.mac = self.curDevInfo.mac;
//                [record insert];
//            }
//        }];
    }
}

@end
