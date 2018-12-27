//
//  DetailInfoController+BG.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController+BG.h"
#import "DetailInfoController+Extension.h"
#import "DetailInfoController+UI.h"
#import "AFManager+WarningSetRecord.h"
#import "AFManager+SelectDataOfDevice.h"
#import "AFManager+DeviceInfo.h"

@implementation DetailInfoController (BG)


/**
 查询温度并刷新（根据）
 */
- (void)selectInternetTemparature{
    
    LRWeakSelf(self);
    [My_AlertView showLoading:^(My_AlertView *loading) {
        
        //查询数据
        [weakself selectInternetTHData:^(NSArray<DeviceInfo *> *datas) {
            
            weakself.currentDatas = datas.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loading dismiss];
                
                float max = [[datas valueForKeyPath:@"@max.temeratureBySData"] floatValue];
                float min = [[datas valueForKeyPath:@"@min.temeratureBySData"] floatValue];
                NSMutableArray <NSNumber *>* tps = [NSMutableArray array];
                for (DeviceInfo * dd in datas) {
                    CGFloat percent;
                    if ((max - min) == 0) {
                        if (max == 0) {
                            percent = 0;
                        } else {
                            percent = 1;
                        }
                    } else {
                        percent = (dd.temeratureBySData - min)/(max - min);
                    }
                    [tps addObject:@(percent)];
                }
                [self.temperatureView.liner reDrawWithX:10 Y:10 Values:tps];
            });
        }];
        
    }];
}

/**
 查询湿度并刷新（根据）
 */
- (void)selectInternetHumidity{
    
    LRWeakSelf(self);
    [My_AlertView showLoading:^(My_AlertView *loading) {
        
        //查询数据
        [weakself selectInternetTHData:^(NSArray<DeviceInfo *> *datas) {
            
            weakself.currentDatas = datas.mutableCopy;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loading dismiss];
                
                float max = [[datas valueForKeyPath:@"@max.humidityBySData"] floatValue];
                float min = [[datas valueForKeyPath:@"@min.humidityBySData"] floatValue];
                NSMutableArray <NSNumber *>* tps = [NSMutableArray array];
                for (DeviceInfo * dd in datas) {
                    CGFloat percent;
                    if ((max - min) == 0) {
                        if (max == 0) {
                            percent = 0;
                        } else {
                            percent = 1;
                        }
                    } else {
                        percent = (dd.humidityBySData - min)/(max - min);
                    }
                    [tps addObject:@(percent)];
                }
                [self.humidityView.liner reDrawWithX:10 Y:10 Values:tps];
            });
        }];
        
    }];
}

/**
 查询报警记录并刷新
 */
- (void)selectInternetWarnRecord{
    
    
    LRWeakSelf(self);
    [My_AlertView showLoading:^(My_AlertView *loading) {
        
        NSTimeInterval last = weakself.segmentView.times.last;
        NSTimeInterval next = weakself.segmentView.times.next;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        
        int count = round((now - last)/120.0);
        int start = round((now - next)/120.0);
        
        UserInfo * user = [MyDefaultManager userInfo];
        
        __block NSMutableArray <DeviceInfo *>* devs;
        __block NSMutableArray <WarnSetRecord *>* tpmaxs;
        __block NSMutableArray <WarnSetRecord *>* tpmins;
        __block NSMutableArray <WarnSetRecord *>* hmmaxs;
        __block NSMutableArray <WarnSetRecord *>* hmmins;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            
            //查时间段之内的所有温湿度记录
            dispatch_group_enter(group);
            [[AFManager shared] selectDataOfDevice:user.uid Mac:[weakself macFormDevice] SIndex:start EIndex:count Result:^(NSArray<DeviceInfo *> * _Nonnull datas) {
                devs = [NSMutableArray arrayWithArray:datas];
                dispatch_group_leave(group);
            }];
            
            //查所有设置报警的记录
            dispatch_group_enter(group);
            [[AFManager shared] selectAllWarnRecordSetWithMac:[weakself macFormDevice] Block:^(NSArray<WarnSetRecord *> * _Nonnull tempMax, NSArray<WarnSetRecord *> * _Nonnull tempMin, NSArray<WarnSetRecord *> * _Nonnull humiMax, NSArray<WarnSetRecord *> * _Nonnull humiMin) {
                
                tpmaxs = [NSMutableArray arrayWithArray:tempMax];
                tpmins = [NSMutableArray arrayWithArray:tempMin];
                hmmaxs = [NSMutableArray arrayWithArray:humiMax];
                hmmins = [NSMutableArray arrayWithArray:humiMin];
                dispatch_group_leave(group);
            }];
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            NSMutableArray <DetailWarnSetObject *>* warns = [NSMutableArray array];
            
            //遍历取得所有超过温度最大值的记录
            NSMutableArray <DeviceInfo *>* devTPMax = [NSMutableArray array];
            for (DeviceInfo * dd in devs) {
                //在所有温度最大值设置记录中遍历
                for (WarnSetRecord * ws in tpmaxs) {
                    //如果该记录为打开、时间早于温度记录的时间、值大于等于温度最大值，那就认定这条记录报警，跳出循环，判断下一条记录
                    if (ws.ison && (ws.settime < dd.utime) && (ws.tvalue <= [dd temeratureBySData])) {
                        [devTPMax addObject:dd];
                        break ;
                    }
                }
            }
            
            //遍历取得所有低于温度最小值的记录
            NSMutableArray <DeviceInfo *>* devTPMin = [NSMutableArray array];
            for (DeviceInfo * dd in devs) {
                //在所有温度最大值设置记录中遍历
                for (WarnSetRecord * ws in tpmins) {
                    //如果该记录为打开、时间早于温度记录的时间、值小于等于温度最小值，那就认定这条记录报警，跳出循环，判断下一条记录
                    if (ws.ison && (ws.settime < dd.utime) && (ws.tvalue >= [dd temeratureBySData])) {
                        [devTPMin addObject:dd];
                        break ;
                    }
                }
            }
            
            //遍历取得所有超过湿度最大值的记录
            NSMutableArray <DeviceInfo *>* devHMMax = [NSMutableArray array];
            for (DeviceInfo * dd in devs) {
                //在所有温度最大值设置记录中遍历
                for (WarnSetRecord * ws in hmmaxs) {
                    //如果该记录为打开、时间早于湿度记录的时间、值大于等于湿度最小值，那就认定这条记录报警，跳出循环，判断下一条记录
                    if (ws.ison && (ws.settime < dd.utime) && (ws.tvalue <= [dd humidityBySData])) {
                        [devHMMax addObject:dd];
                        break ;
                    }
                }
            }
            
            //遍历取得所有低于湿度最大小值的记录
            NSMutableArray <DeviceInfo *>* devHMMin = [NSMutableArray array];
            for (DeviceInfo * dd in devs) {
                //在所有温度最大值设置记录中遍历
                for (WarnSetRecord * ws in hmmins) {
                    //如果该记录为打开、时间早于湿度记录的时间、值大于等于湿度最小值，那就认定这条记录报警，跳出循环，判断下一条记录
                    if (ws.ison && (ws.settime < dd.utime) && (ws.tvalue >= [dd humidityBySData])) {
                        [devHMMin addObject:dd];
                        break ;
                    }
                }
            }
            
            //赋予数据源
            
            for (DeviceInfo *d1 in devTPMax) {
                DetailWarnSetObject * objc = [[DetailWarnSetObject alloc]init];
                objc.temparature = d1.temeratureBySData;
                objc.time = d1.utime;
                [warns addObject:objc];
            }
            for (DeviceInfo *d1 in devTPMin) {
                DetailWarnSetObject * objc = [[DetailWarnSetObject alloc]init];
                objc.temparature = d1.temeratureBySData;
                objc.time = d1.utime;
                [warns addObject:objc];
            }
            for (DeviceInfo *d1 in devHMMax) {
                DetailWarnSetObject * objc = [[DetailWarnSetObject alloc]init];
                objc.humidity = d1.humidityBySData;
                objc.time = d1.utime;
                [warns addObject:objc];
            }
            for (DeviceInfo *d1 in devHMMin) {
                DetailWarnSetObject * objc = [[DetailWarnSetObject alloc]init];
                objc.humidity = d1.humidityBySData;
                objc.time = d1.utime;
                [warns addObject:objc];
            }
            
            [loading dismiss];
            
            weakself.warnView.records = warns;
            [weakself.warnView.collection reloadData];
            
            UILabel * lab1 = [weakself.warnView.topView viewWithTag:13];
            lab1.text = [NSString stringWithFormat:@"%lu",(unsigned long)warns.count];
            UILabel * lab2 = [weakself.warnView.topView viewWithTag:14];
            lab2.text = [NSString stringWithFormat:@"%lu",devTPMin.count+devTPMax.count];
            UILabel * lab3 = [weakself.warnView.topView viewWithTag:15];
            lab3.text = [NSString stringWithFormat:@"%lu",devHMMin.count+devHMMax.count];
            
        });
    }];
    
    
}

- (void)selectInternetInfo{
    
    LRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        //查最新一条设置记录
        [[AFManager shared] selectLastWarnSetRecordWithMac:[self macFormDevice] Block:^(WarnSetRecord * _Nonnull record) {

            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.editer.switcher.isOn = record.ison;
                weakself.editer.limitTemp.tfLess_textField.text = [NSString stringWithFormat:@"%.0f",record.threshold.tempMin.value];
                weakself.editer.limitTemp.tfMore_textField.text = [NSString stringWithFormat:@"%.0f",record.threshold.tempMax.value];
                weakself.editer.limitHumi.tfLess_textField.text = [NSString stringWithFormat:@"%.0f",record.threshold.humiMin.value];
                weakself.editer.limitHumi.tfMore_textField.text = [NSString stringWithFormat:@"%.0f",record.threshold.humiMax.value];
            });
            
            //如果开关打开，则查询实时数据看是否报警
            if (record.ison) {
                int uid = [MyDefaultManager userInfo].uid;
                [[AFManager shared] selectLastDataOfDevice:uid Mac:[weakself macFormDevice] Block:^(NSString * _Nonnull dataStr) {
                    
                    float temp = [DeviceInfo temeratureBySData:dataStr];
                    int humi = [DeviceInfo humidityBySData:dataStr];
                    
                    if (temp < record.threshold.tempMin.value || temp > record.threshold.tempMax.value || humi < record.threshold.humiMin.value || humi > record.threshold.humiMax.value) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakself.warner.labTemp.text = [NSString stringWithFormat:@"%.1f%@",temp,[MyDefaultManager unit]];
                            [weakself.warner.labTemp sizeToFit];
                            weakself.warner.labHumi.text = [NSString stringWithFormat:@"%d%%",humi];
                            [weakself.warner.labHumi sizeToFit];
                            [weakself showIsWaner:true];
                        });
                    }
                    
                    
                }];
            }
        }];
    });
    
}

- (void)setInternetDevName{
    
    NSString * name = self.editer.tfName.text;
    NSString * mac = [self macFormDevice];
    UserInfo * user = [MyDefaultManager userInfo];
    [[AFManager shared] setDeviceName:name Mac:mac Uid:user.uid Result:^(bool success, NSString * _Nonnull info) {
        if (!success) {
            LRLog(@"设置名称失败！%@",info);
        }
    }];
}

- (void)setInternetDevType{
    int type;
    switch (self.editer.type) {
        case 1:
            type = 8;
            break;
        case 2:
            type = 7;
            break;
        case 3:
            type = 9;
            break;
            
        default:
            type = 6;
            break;
    }
    NSString * mac = [self macFormDevice];
    UserInfo * user = [MyDefaultManager userInfo];
    [[AFManager shared] setDeviceType:type Mac:mac Uid:user.uid Result:^(bool success, NSString * _Nonnull info) {
        if (!success) {
            LRLog(@"设置类型失败！%@",info);
        }
    }];
}

/**
设置报警参数阈值及其是否打开
 */
- (void)setInternetWarnSet{
    
    bool ison = self.editer.switcher.isOn;
    int uid = [MyDefaultManager userInfo].uid;
    float tempmin = [self.editer.limitTemp.tfLess_textField.text floatValue];
    float tempmax = [self.editer.limitTemp.tfMore_textField.text floatValue];
    int humimin = [self.editer.limitHumi.tfLess_textField.text floatValue];
    int humimax = [self.editer.limitHumi.tfMore_textField.text floatValue];
    [[AFManager shared] setWarnWithMac:[self macFormDevice] Type:@"01" IsOn:ison Uid:uid Value:@(tempmin)];
    [[AFManager shared] setWarnWithMac:[self macFormDevice] Type:@"02" IsOn:ison Uid:uid Value:@(tempmax)];
    [[AFManager shared] setWarnWithMac:[self macFormDevice] Type:@"03" IsOn:ison Uid:uid Value:@(humimin)];
    [[AFManager shared] setWarnWithMac:[self macFormDevice] Type:@"04" IsOn:ison Uid:uid Value:@(humimax)];
}

/**
 查询选择时间段内的数据

 @param block 回调 - 温湿度数据等等
 */
- (void)selectInternetTHData:(void(^)(NSArray<DeviceInfo *> *datas))block{
    
    NSTimeInterval last = self.segmentView.times.last;
    NSTimeInterval next = self.segmentView.times.next;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    int count = round((now - last)/120.0);
    int start = round((now - next)/120.0);
    
    UserInfo * user = [MyDefaultManager userInfo];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        //查时间段之内的所有温湿度记录
        [[AFManager shared] selectDataOfDevice:user.uid Mac:[self macFormDevice] SIndex:start EIndex:count Result:block];
    });
}

- (NSString *)macFormDevice{
    DeviceInfo * device = self.deviceInfo;
    return device.mac;
}



@end
