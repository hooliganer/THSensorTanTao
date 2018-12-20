//
//  DetailInfoController+DetailInfoBG.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController+DetailInfoBG.h"
#import "DetailInfoController+DetailInfo.h"
#import "HTTP_SelectAllDevices.h"
#import "HTTP_ModifyDevInfo.h"
#import "FMDB_DeviceInfo.h"

@implementation DetailInfoController (DetailInfoBG)


- (void)startTimer{

    /* 尝试懒加载定时器 */

    //    [self selectTimer];

    [self historyTimer];
}


/*!
 * 设置本地信息
 */
- (void)setLocalInfo{

    LRWeakSelf(self);
    [[FMDB_DeviceInfo sharedInstance] selectAllByMac:self.curDevInfo.mac Block:^(NSArray<FMDB_DeviceInfo *> *allDevInfos) {

        if (allDevInfos.count > 0) {
            FMDB_DeviceInfo *info = [allDevInfos firstObject];

            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.editAlert.switcher.isOn = info.isWarn;

                float tpLs = info.lessTemper;;
                float tpOv = info.overTemper;
                float hmLs = info.lessHumidi;
                float hmOv = info.overHumidi;
                weakself.editAlert.limitTemp.tfLess_textField.text = [NSString stringWithFormat:@"%.1f",tpLs];
                weakself.editAlert.limitTemp.tfMore_textField.text = [NSString stringWithFormat:@"%.1f",tpOv];
                weakself.editAlert.limitHumi.tfLess_textField.text = [NSString stringWithFormat:@"%.1f",hmLs];
                weakself.editAlert.limitHumi.tfMore_textField.text = [NSString stringWithFormat:@"%.1f",hmOv];
            });
        }

    }];
}

/*!
 * 请求蓝牙（实时数据）
 */
- (void)selecetBLEDevData{

//    __weak typeof(self) weakself = self;
    NSString *strData = @"PX-GS#I";
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    async_bgqueue(^{
        BLEManager *manager = [BLEManager shareInstance];
        [manager queryWithData:data CBPeripheral:self.curDevInfo.bleInfo.peripheral];
    });
}

/*!
 * 请求历史数据
 * @parama isStart 开始/结束
 */
- (void)selecetHistoryDataIsStart:(bool)isStart{

    LRWeakSelf(self);
    NSString * strData = [NSString stringWithFormat:@"PX-MQ#%d",isStart?1:0];
    NSData * data = [strData dataUsingEncoding:NSUTF8StringEncoding];
//    Byte *byte = (Byte *)[data bytes];
//    byte[6] = isStart?1:0;
//    data = [[NSData alloc]initWithBytes:byte length:7];

//    NSString * queryStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    LRLog(@"请求历史数据:%@ -- %@",queryStr,data.description);

    async_bgqueue(^{
        [[BLEManager shareInstance] queryWithData:data CBPeripheral:weakself.curDevInfo.bleInfo.peripheral];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.getBLEHistory) {
            [self selecetHistoryDataIsStart:true];
        }
    });
}

/*!
 * 读本地所有历史数据
 */
- (void)readLocalHistory{

    LRWeakSelf(self);
    async_bgqueue(^{
        //读本地温湿度历史记录
        [[FMDB_HitoryRecord sharedInstance] selectAllByMac:self.curDevInfo.mac Block:^(NSArray<FMDB_HitoryRecord *> *allHistories) {

            weakself.histories = [NSMutableArray arrayWithArray:allHistories];

//            weakself.histories = [NSMutableArray array];
//            NSTimeInterval nowInter = [[NSDate date] timeIntervalSince1970];

//            for (int i=0; i<1000; i++) {
//                FMDB_HitoryRecord * fhr = [[FMDB_HitoryRecord alloc]init];
//                fhr.temperature = arc4random_uniform(500)/10.0;
//                fhr.humidity = arc4random_uniform(100);
//                int minute = arc4random_uniform(60)+1;
//                nowInter -= minute*60;
//                fhr.dateInterval = nowInter;
//                fhr.mac = @"d3c45af3bb";
//                //NSLog(@"%f",fhr.dateInterval);
//                [weakself.histories addObject:fhr];
//            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself refershHistoryUI];
            });

        }];

        //读本地报警记录
        [[FMDB_DeviceWarn sharedInstance] selectAllByMac:self.curDevInfo.mac Block:^(NSArray<FMDB_DeviceWarn *> *allWarnInfos) {

            weakself.warnInfos = [NSMutableArray arrayWithArray:allWarnInfos];
            dispatch_async(dispatch_get_main_queue(), ^{

                [weakself refershWarnUI];
            });

        }];
    });

}

/*!
 * 设置设备名称（网络）
 */
- (void)setDevName{
    
//    NSLog(@"=%@",self.editAlert.tfName.text);
//    NSLog(@"=%@",self.editAlert.limitTemp.tfLess_textField.text);
//    NSLog(@"=%@",self.editAlert.limitTemp.tfMore_textField.text);
//    NSLog(@"=%@",self.editAlert.limitHumi.tfLess_textField.text);
//    NSLog(@"=%@",self.editAlert.limitHumi.tfMore_textField.text);
//    NSLog(@"=%d",self.editAlert.switcher.isOn);
//    NSLog(@"=%d",self.editAlert.type);

    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
    NSString *name = [self.editAlert.tfName.text getUTF8String];
    async_bgqueue(^{
        [[HTTP_ModifyDevInfo sharedInstance] setDevName:name Uid:user.uid Mac:self.curDevInfo.mac Block:^(bool success, NSString *info) {

        }];
    });


}

- (void)setDevType{

    int type = 0;
    switch (self.editAlert.type) {
        case 0:
            type = 6;
            break;
        case 1:
            type = 7;
            break;
        case 2:
            type = 8;
            break;
        case 3:
            type = 9;
            break;

        default:
            break;
    }

    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[HTTP_ModifyDevInfo sharedInstance] setDevType:type Uid:user.uid Mac:self.curDevInfo.mac Block:^(bool success, NSString *info) {

        }];
    });

}

/*!
 * 设置设备是否报警
 */
- (void)setDevIsAlert{

    bool isOn = self.editAlert.switcher.isOn;
    NSString *mac = self.curDevInfo.mac;
    if (mac.length == 0) {
        return ;
    }

    [[FMDB_DeviceInfo sharedInstance] selectAllByMac:mac Block:^(NSArray<FMDB_DeviceInfo *> *allHistories) {

        if (allHistories.count > 0)
        {
            FMDB_DeviceInfo *info = [allHistories firstObject];
            info.isWarn = isOn;
            [info updateIsWarn];
        }
        else
        {
            FMDB_DeviceInfo *info = [[FMDB_DeviceInfo alloc]init];
            info.isWarn = isOn;
            info.mac = mac;
            [info insert];
        }
    }];

}

/*!
 * 设置设备报警⚠️阈值
 */
- (void)setDevLimitValue{

    NSString *mac = self.curDevInfo.mac;

    NSString *tpLs = self.editAlert.limitTemp.tfLess_textField.text;
    NSString *tpMr = self.editAlert.limitTemp.tfMore_textField.text;
    NSString *hmLs = self.editAlert.limitHumi.tfLess_textField.text;
    NSString *hmMr = self.editAlert.limitHumi.tfMore_textField.text;

    [[FMDB_DeviceInfo sharedInstance] selectAllByMac:mac Block:^(NSArray<FMDB_DeviceInfo *> *allHistories) {

        if (allHistories.count > 0)
        {
            FMDB_DeviceInfo *info = [allHistories firstObject];
            info.lessTemper = [tpLs floatValue];
            info.overTemper = [tpMr floatValue];
            info.lessHumidi = [hmLs floatValue];
            info.overHumidi = [hmMr floatValue];
            [info updateWarnValue];
        }
        else
        {
            FMDB_DeviceInfo *info = [[FMDB_DeviceInfo alloc]init];
            info.lessTemper = [tpLs floatValue];
            info.overTemper = [tpMr floatValue];
            info.lessHumidi = [hmLs floatValue];
            info.overHumidi = [hmMr floatValue];
            info.mac = mac;
            [info insert];
        }
    }];

}

/*!
 * 关注设备
 */
- (void)linkDev{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[HTTP_SelectAllDevices sharedInstance] linkDevWithMac:self.curDevInfo.mac Name:self.curDevInfo.nickName?self.curDevInfo.nickName:self.curDevInfo.bleInfo.peripheral.name Block:nil];
    });
}


/*!
 * 刷新报警alert
 */
- (void)refershWarningWithTemp:(float)temp Humi:(float)humi UnitTemp:(NSString *)unitTP UnitHumi:(NSString *)unitHM{

    LRWeakSelf(self);
    //查询当前设备的报警阈值信息
    [[FMDB_DeviceInfo sharedInstance] selectAllByMac:self.curDevInfo.mac Block:^(NSArray<FMDB_DeviceInfo *> *allHistories) {

        //有设置报警阈值
        if (allHistories.count > 0)
        {
            FMDB_DeviceInfo *info = [allHistories firstObject];
            if (info.isWarn) {
                float tpLs = info.lessTemper;
                float tpOv = info.overTemper;
                float hmLs = info.lessHumidi;
                float hmOv = info.overHumidi;
                if (temp < tpLs || temp > tpOv || humi < hmLs || humi > hmOv) {
                    weakself.mainScroll.warnAlert.labTemp.text = [NSString stringWithFormat:@"%.1f%@",temp,unitTP];
                    [weakself.mainScroll.warnAlert.labTemp sizeToFit];
                    weakself.mainScroll.warnAlert.labHumi.text = [NSString stringWithFormat:@"%.1f%@",humi,unitHM];
                    [weakself.mainScroll.warnAlert.labHumi sizeToFit];
                    weakself.mainScroll.warning = true;

                    //保存一条报警记录
                    [weakself saveWarnInfoInBGQueueWithTemp:temp Humi:humi];

                } else{
                    weakself.mainScroll.warning = false;
                }
            }
        }
        //没有报警信息
        else
        {
            //nothing
        }

    }];
}

/*!
 * 刷新中部文字信息区域
 */
- (void)refershHistoryUI{

    NSString *unit = [self currentTemperUnit];

    NSMutableArray <NSNumber *> * tempers = [NSMutableArray array];
    NSMutableArray <NSNumber *> * humidis = [NSMutableArray array];
    for (FMDB_HitoryRecord *info in self.histories) {
        [tempers addObject:@(info.temperature)];
        [humidis addObject:@(info.humidity)];
    }

    FMDB_HitoryRecord *objc0 = [self.histories firstObject];
    NSDate *date0 = [NSDate dateWithTimeIntervalSince1970:objc0.dateInterval];

    switch (self.mainScroll.typeView.type) {
        case 0://温度
        {
            switch (self.mainScroll.chooseSeg.type) {
                case 1:
                {

                }
                    break;
                default:
                {
                    [self refreshMiddleTemperatureWithDate:date0 History:objc0 Temperatures:tempers Unit:unit];
                }
                    break;
            }
        }
            break;
        case 1://湿度
        {
            [self refreshMiddleHumidityWithDate:date0 History:objc0 Humidities:humidis];
        }
        default:
            break;
    }
}





- (void)refreshMiddleTemperatureWithDate:(NSDate *)date0 History:(FMDB_HitoryRecord *)history Temperatures:(NSArray <NSNumber*> *)tempers Unit:(NSString *)unit{

    UILabel *lab1 = [self.mainScroll.tempView.tempInfoView viewWithTag:11];
    UILabel *lab2 = [self.mainScroll.tempView.tempInfoView viewWithTag:12];
    UILabel *lab3 = [self.mainScroll.tempView.tempInfoView viewWithTag:13];
    UILabel *lab7 = [self.mainScroll.tempView.tempInfoView viewWithTag:17];
    UILabel *lab8 = [self.mainScroll.tempView.tempInfoView viewWithTag:18];
    UILabel *lab9 = [self.mainScroll.tempView.tempInfoView viewWithTag:19];

    lab1.text = [NSString stringWithFormat:@"%02d/%02d/%d",[date0 month],[date0 day],[date0 year]];

    lab3.text = [NSString stringWithFormat:@"%02d:%02d:%02d",[date0 hour],[date0 minute],[date0 second]];

    lab2.text = [NSString stringWithFormat:@"%.1f%@",history.temperature,unit];

    lab7.text = [NSString stringWithFormat:@"%.1f%@",[[tempers maxNumber] floatValue],unit];

    lab8.text = [NSString stringWithFormat:@"%.1f%@",[[tempers minNumber] floatValue],unit];

    lab9.text = [NSString stringWithFormat:@"%.1f%@",[[tempers avgNumber] floatValue],unit];

    [lab1 sizeToFit];
    [lab2 sizeToFit];
    [lab3 sizeToFit];
    [lab7 sizeToFit];
    [lab8 sizeToFit];
    [lab9 sizeToFit];

}

- (void)refreshMiddleHumidityWithDate:(NSDate *)date0 History:(FMDB_HitoryRecord *)history Humidities:(NSArray <NSNumber*> *)humidis{

    UILabel *lab1 = [self.mainScroll.humiView.humiInfoView viewWithTag:11];
    UILabel *lab2 = [self.mainScroll.humiView.humiInfoView viewWithTag:12];
    UILabel *lab3 = [self.mainScroll.humiView.humiInfoView viewWithTag:13];
    UILabel *lab7 = [self.mainScroll.humiView.humiInfoView viewWithTag:17];
    UILabel *lab8 = [self.mainScroll.humiView.humiInfoView viewWithTag:18];
    UILabel *lab9 = [self.mainScroll.humiView.humiInfoView viewWithTag:19];

    lab1.text = [NSString stringWithFormat:@"%02d/%02d/%d",[date0 month],[date0 day],[date0 year]];

    lab3.text = [NSString stringWithFormat:@"%02d:%02d:%02d",[date0 hour],[date0 minute],[date0 second]];

    lab2.text = [NSString stringWithFormat:@"%d%%",history.humidity];

    lab7.text = [NSString stringWithFormat:@"%.0f%%",[[humidis maxNumber] floatValue]];

    lab8.text = [NSString stringWithFormat:@"%.0f%%",[[humidis minNumber] floatValue]];

    lab9.text = [NSString stringWithFormat:@"%.0f%%",[[humidis avgNumber] floatValue]];

    [lab1 sizeToFit];
    [lab2 sizeToFit];
    [lab3 sizeToFit];
    [lab7 sizeToFit];
    [lab8 sizeToFit];
    [lab9 sizeToFit];
}

/*!
 * 刷新报警信息类型视图
 */
- (void)refershWarnUI{

    if (self.warnInfos.count == 0) {
        return ;
    }

    self.mainScroll.warnView.datasArray = [NSMutableArray arrayWithArray:self.warnInfos];
    [self.mainScroll.warnView.collection reloadData];

    NSString *unit = [self currentTemperUnit];

    UILabel *lab3 = [self.mainScroll.warnView.topView viewWithTag:13];
    UILabel *lab4 = [self.mainScroll.warnView.topView viewWithTag:14];
    UILabel *lab5 = [self.mainScroll.warnView.topView viewWithTag:15];


    NSMutableArray <NSNumber *> *tempers = [NSMutableArray array];
    NSMutableArray <NSNumber *> *humidis = [NSMutableArray array];
    for (FMDB_DeviceWarn *warn in self.warnInfos) {
        [tempers addObject:@(warn.temperature)];
        [humidis addObject:@(warn.humidity)];
    }

    float avgTemp = [[tempers avgNumber] floatValue];
    int avgHumi = [[humidis avgNumber] intValue];

    lab3.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.warnInfos.count];
    [lab3 sizeToFit];

    lab4.text = [NSString stringWithFormat:@"%.1f%@",avgTemp,unit];
    [lab4 sizeToFit];

    lab5.text = [NSString stringWithFormat:@"%d%%",avgHumi];
    [lab5 sizeToFit];

}

/*！
 * 获取当前温度单位
 */
- (NSString *)currentTemperUnit{
    APPGlobalObject *gobc = [[MyArchiverManager sharedInstance] readGlobalObject];
    NSString *unit;
    if (gobc) {
        unit = gobc.unitType?@"˚F":@"˚C";
    } else{
        unit = @"˚C";
    }
    return unit;
}


#pragma mark ----- inside method
/*!
 * 解析蓝牙实时数据（温湿度）
 */
- (void)parseBLEData:(NSData *)data{

    //从本地获取温度单位
    NSString *unit = [self currentTemperUnit];

    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *dataStrring = data.description;
        dataStrring = [dataStrring getStringBetweenFormerString:@"<" AndLaterString:@">"];
        dataStrring = [dataStrring stringByReplacingOccurrencesOfString:@" " withString:@""];

        /* 温湿度数据 eg : 50582d505323 894900 0a633462 */
        //PX-PS#
        if ([dataStrring containsString:@"50582d505323"])
        {
            dataStrring = [dataStrring stringByReplacingOccurrencesOfString:@"50582d505323" withString:@""];
        }
        else
        {
            return  ;
        }

//        NSLog(@"实时温湿度 ：%@",dataStrring);

        float temp = 0;
        if (dataStrring.length >= 10) {
            bool positive = [[dataStrring stringOfIndex:6] isEqualToString:@"0"];
            int tempInt = [[dataStrring substringWithRange:NSMakeRange(7, 3)] toDecimalByHex];
            temp = positive?tempInt/100.0:-tempInt/100.0;
            self.mainScroll.cellView.labTempar.text = [NSString stringWithFormat:@"%.1f%@",temp,unit];
            [self.mainScroll.cellView.labTempar sizeToFit];

        }

        int humi = 0;
        if (dataStrring.length >= 12) {
            humi = [[dataStrring substringWithRange:NSMakeRange(10, 2)] toDecimalByHex];
            self.mainScroll.cellView.labHumi.text = [NSString stringWithFormat:@"%d%%",humi];
            [self.mainScroll.cellView.labHumi sizeToFit];
        }

        if (dataStrring.length >= 14) {
            int power = [[dataStrring substringWithRange:NSMakeRange(12, 2)] toDecimalByHex];
            self.mainScroll.cellView.labPower.text = [NSString stringWithFormat:@"%d%%",power];
            [self.mainScroll.cellView.labPower sizeToFit];
        }

        //刷新warning
        [self refershWarningWithTemp:temp Humi:humi UnitTemp:unit UnitHumi:@"%"];
    });

}

/*!
 * 解析历史数据
 */
- (void)parseHistoryDataWithData:(NSData *)data{

//    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    LRLog(@"history result : %@",result);

    LRLog(@"history record : %@",data.description);

    Byte *recByte = (Byte *)[data bytes];

    int number = recByte[6];
    NSDate *nowDate = [NSDate zoneDate];
    NSTimeInterval nowInterval = [nowDate timeIntervalSince1970];

//    LRLog(@"%d",number);
//    int i = 0;
//    if (i==0) {
//        return ;
//    }
    for (int i=0; i<3; i++) {

        //第几个小时记录的时间戳
        NSTimeInterval interval = nowInterval - (number+1) * (i+1) * 3600;

        float tp = ((recByte[7+i*3] & 0x7f) * 0x100 + (recByte[8+i*3] & 0xff))/100.0;
        int hm = recByte[9+i*3];

//        LRLog(@"temperature : %f  humidity : %d",tp,hm);

        if (tp == 0 && hm == 0) {
            LRLog(@"此记录无效不作记录:%@",data.description);
            continue ;
        }

        //从本地查询 当前设备对应时间戳 的历史数据
        [[FMDB_HitoryRecord sharedInstance] selectWithDateInterval:interval Mac:self.curDevInfo.mac Block:^(NSArray<FMDB_HitoryRecord *> *hitories) {

            //如果没有，则证明是未保存的，进行存储
            if (hitories.count == 0) {
                FMDB_HitoryRecord *record = [[FMDB_HitoryRecord alloc]initDatabase];
                record.dateInterval = interval;
                record.temperature = tp;
                record.humidity = hm;
                record.mac = self.curDevInfo.mac;
                [record insert];
            }
        }];
    }
}


/*!
 * 监听蓝牙返回数据
 */
- (void)notifyValueForCharacteristic{

    BLEManager *manager = [BLEManager shareInstance];
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

//        NSLog(@"respnse : %@:%@",peripheral.name,characteristic.value.description);
        //实时温湿度
        if (recByte[3] == 'P' && recByte[4] == 'S') {

            [weakself parseBLEData:characteristic.value];
        }
        //历史数据
        else if (recByte[3] == 'M' && recByte[4] == 'S')
        {
            weakself.getBLEHistory = true;
            [weakself parseHistoryDataWithData:characteristic.value];
        }

    };

    manager.didRequest = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        NSLog(@"request : %@",characteristic.value.description);
    };

    manager.didUnknownCharacter = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
//        LRLog(@"unkonwn : %@",characteristic.value.description);
    };
}



/*!
 * 向数据库保存一条报警记录
 */
- (void)saveWarnInfoInBGQueueWithTemp:(float)temp Humi:(float)humi{

    if (self.curDevInfo.mac.length == 0) {
        return ;
    }

    async_bgqueue(^{
        FMDB_DeviceWarn *warn = [[FMDB_DeviceWarn alloc]initDatabase];
        warn.mac = self.curDevInfo.mac;
        warn.temperature = temp;
        warn.humidity = humi;
        warn.dateLine = [[NSDate date] timeIntervalSince1970];
        [warn insert];
    });
}

@end

