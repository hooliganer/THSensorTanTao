//
//  MainListController+BG.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController+BG.h"
#import "MainListController+Extension.h"

#import "BLEManager.h"
#import "HTTP_GroupManager.h"
#import "HTTP_MemberManager.h"
#import "HTTP_MemberDataManager.h"

#import "AFManager+SelectGroup.h"
#import "AFManager+SelectDataOfDevice.h"
#import "AFManager+WarningSetRecord.h"
#import "WarnConfirm+CoreDataClass.h"
#import "WarnRecordSetDB+CoreDataClass.h"

@implementation MainListController (BG)

#pragma mark - 外部调用方法

- (void)saveWarnConfirmWithMac:(NSString *)mac{
    WarnConfirm * wc = [WarnConfirm readByMac:mac];
    if (!wc) {
        wc = [WarnConfirm newWarnConfirm];
        wc.mac = mac;
    }
    wc.time = [[NSDate date] timeIntervalSince1970];
    [wc save];
}

- (void)startBlueToothScan{
    
//    // 介绍 : 模拟扫描到2个蓝牙设备
//
//    [self.bleDatasource removeAllObjects];
//    NSDictionary * bled = @{
//                            @"name":@"啊哈哈哈",
//                            @"mac":@"df36fbc37df",
//                            @"temp":@(arc4random()%50),
//                            @"humi":@(arc4random()%100)
//                            };
//    NSMutableDictionary * mdic = @{@"fakeble":bled}.mutableCopy;
//
//    NSDictionary * bled1 = @{
//                             @"name":@"打算放弃而为",
//                             @"mac":@"df36c38ea",
//                             @"temp":@(arc4random()%50),
//                             @"humi":@(arc4random()%100)
//                             };
//    NSMutableDictionary * mdic1 = @{@"fakeble":bled1}.mutableCopy;
//
//    [self.bleDatasource addObject:mdic];
//    [self.bleDatasource addObject:mdic1];
//    [self.bleTable reloadData];
//    return ;

    LRWeakSelf(self);
    BLEManager * ble = [BLEManager shareInstance];
    [ble startScan];
    ble.discoverPeripheral = ^(BLEManager *manager, MyPeripheral *peripheral) {

        //通知蓝牙列表界面接客（蓝牙设备）啦
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiName_ToBLEController object:peripheral];

        //刷新蓝牙table
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLock * lock = [[NSLock alloc]init];
            [lock lock];

            NSInteger index = -1;
            for (int i=0; i<weakself.bleDatasource.count; i++) {
                MyPeripheral * ble = weakself.bleDatasource[i][@"ble"];
                if ([ble isEqual:peripheral]) {
                    index = i;
                    break ;
                }
            }
            if (index >= 0) {
                [weakself.bleTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
                [mdic setValue:peripheral forKey:@"ble"];
                [weakself.bleDatasource addObject:mdic];
                [weakself.bleTable reloadData];
            }

            [lock unlock];
        });

    };
}

- (void)startTimer{

    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer1, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer1, ^{
        [self selectGroupData];
        [self judgeBLEWhetherWarn];
//        [self selectDevicesOfGroup];
    });
    dispatch_resume(self.timer1);
}

/**
 判断蓝牙数据是否报警
 */
- (void)judgeBLEWhetherWarn{
    
//    [self judgeFakeBLEWarn];
//    return ;
    
    for (int row=0;row<self.bleDatasource.count;row++) {
        
        NSMutableDictionary * rowDic = self.bleDatasource[row];
        MyPeripheral * peri = rowDic[@"ble"];
        NSString * mac = peri.macAddress;
        float temp = peri.temperatureBle;
        int humi= peri.humidityBle;
        NSMutableDictionary * warnDic = rowDic[@"warn"];
        if (!warnDic) {
            warnDic = @{}.mutableCopy;
            [rowDic setValue:warnDic forKey:@"warn"];
        }
        
        WarnConfirm * wc = [WarnConfirm readByMac:mac];
        NSTimeInterval time = wc.time;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now - time < 180) {
            continue ;
        }
        
        WarnRecordSetDB * wrs = [WarnRecordSetDB readAllOrderByMac:mac].firstObject;
        float tpmin = wrs ? wrs.tempMin : 0;
        float tpmax = wrs ? wrs.tempMax : 30;
        float hmmin = wrs ? wrs.humiMin : 10;
        float hmmax = wrs ? wrs.humiMax : 70;
        bool ison = wrs ? wrs.ison : true;

        if (temp <= tpmin || temp >= tpmax) {
            [warnDic setValue:@(temp == -1000 ? false : ison) forKey:@"tempWarn"];
        } else {
            [warnDic setValue:@(false) forKey:@"tempWarn"];
        }
        
        if (humi <= hmmin || humi >= hmmax) {
            [warnDic setValue:@(humi == -1000 ? false : ison) forKey:@"humiWarn"];
        } else{
            [warnDic setValue:@(false) forKey:@"humiWarn"];
        }

    }
    
    [self.bleTable reloadData];
    
}


/**
 判断假的蓝牙报警
 */
- (void)judgeFakeBLEWarn{
    
    for (int row=0;row<self.bleDatasource.count;row++) {
        
        NSMutableDictionary * rowDic = self.bleDatasource[row];
        NSDictionary * peri = rowDic[@"fakeble"];
        NSString * mac = peri[@"mac"];
        float temp = [peri[@"temp"] floatValue];
        int humi= [peri[@"humi"] intValue];
        NSMutableDictionary * warnDic = rowDic[@"warn"];
        if (!warnDic) {
            warnDic = @{}.mutableCopy;
            [rowDic setValue:warnDic forKey:@"warn"];
        }
        
        WarnConfirm * wc = [WarnConfirm readByMac:mac];
        NSTimeInterval time = wc.time;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now - time < 180) {
            continue ;
        }
        
        WarnRecordSetDB * wrs = [WarnRecordSetDB readAllOrderByMac:mac].firstObject;
        
        if (wrs.ison) {
            if (temp <= wrs.tempMin || temp >= wrs.tempMax) {
                [warnDic setValue:@(true) forKey:@"tempWarn"];
            } else {
                [warnDic setValue:@(false) forKey:@"tempWarn"];
            }
            if (humi <= wrs.humiMin || humi >= wrs.humiMax) {
                [warnDic setValue:@(true) forKey:@"humiWarn"];
            } else{
                [warnDic setValue:@(false) forKey:@"humiWarn"];
            }
        } else{
            [warnDic setValue:@(false) forKey:@"tempWarn"];
            [warnDic setValue:@(false) forKey:@"humiWarn"];
        }
    }
    
    [self.bleTable reloadData];
}

/**
 查询分组（网关）信息
 */
- (void)selectGroupData{

    LRWeakSelf(self);
    [[AFManager shared] selectGroupOfUser:^(NSArray<TH_GroupInfo *> *groups) {

        //查询回的分组数据中遍历比较
        for (int i=0; i<groups.count; i++) {
            TH_GroupInfo * newGroup = groups[i];
            int index = -1;
            for (int j=0; j<weakself.groupDatasource.count; j++) {
                TH_GroupInfo * oldGroup = [weakself.groupDatasource[j] valueForKey:@"group"];
                //如果新旧数据一样，则替换掉旧数据
                if ([oldGroup.mac isEqual:newGroup.mac]) {
                    [weakself.groupDatasource[j] setValue:newGroup forKey:@"group"];
                    index = j;
                    break ;
                }
            }
            //有新旧数据的更迭,执行下一个循环
            if (index >= 0) {
                continue ;
            }
            //没有数据的更换，添加新数据
            NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
            [mdic setValue:newGroup forKey:@"group"];
            [mdic setValue:@(false) forKey:@"flex"];
            [weakself.groupDatasource addObject:mdic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.groupTable reloadData];
        });
        //查询子设备
        [weakself selectDevicesOfGroup];
    }];

}

/**
 查询每组的子设备信息
 */
- (void)selectDevicesOfGroup{

    LRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{

        for (int i=0; i<self.groupDatasource.count; i++) {
            TH_GroupInfo * group = self.groupDatasource[i][@"group"];
            AFManager * manager = [AFManager shared];
            [manager selectMembersOfGroupWithGid:group.gid Block:^(NSArray<DeviceInfo *> *devices) {
                
                [weakself handleDevices:devices CurrentGroup:group];
            } Fail:^(NSError *error) {
                LRLog(@"%@",error.description);
            }];
        }
        sleep(2);
        //查询子设备信息
        [weakself selectDevicesOfGroupData];

    });

}

/**
 查询每组的子设备数据
 */
- (void)selectDevicesOfGroupData{

    LRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        UserInfo * user = [MyDefaultManager userInfo];
        if (user) {
            //遍历所有组
            for (int sec=0; sec<self.groupDatasource.count; sec++) {
                //                TH_GroupInfo * group = self.groupDatasource[sec][@"group"];
                NSMutableArray * devs = self.groupDatasource[sec][@"devices"];
                //遍历单组（子设备）
                for (int row=0; row<devs.count; row++) {
                    
                    DeviceInfo * dev = devs[row][@"device"];
                    dispatch_group_enter(group);
                    [[AFManager shared] selectLastDataOfDevice:user.uid Mac:dev.mac Block:^(NSString * _Nonnull dataStr) {
                        dev.sdata = dataStr;
//                        dev.showName = dev.mac;
                        dispatch_group_leave(group);
                    }];
                }
            }
        }
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakself.groupTable reloadData];
        });
        [weakself selectInternetWarnInfo];
    });
}

/**
 查询网络报警信息
 */
- (void)selectInternetWarnInfo{
    
    //查询报警设置信息
    LRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        //遍历所有组
        for (int sec=0; sec<self.groupDatasource.count; sec++) {

            NSMutableArray * devs = self.groupDatasource[sec][@"devices"];
            //遍历单组（子设备）
            for (int row=0; row<devs.count; row++) {
                
                NSMutableDictionary * devDic = devs[row];
                NSMutableDictionary * warnDic = devDic[@"warn"];
                if (!warnDic) {
                    warnDic = [NSMutableDictionary dictionary];
                    [devDic setValue:warnDic forKey:@"warn"];
                }
                DeviceInfo * dev = devDic[@"device"];
                dispatch_group_enter(group);
                //查最后一套设置记录
                [[AFManager shared] selectLastWarnSetRecordWithMac:dev.mac Block:^(WarnSetRecord * _Nonnull record) {
                    
                    [weakself handleWarnSetRecord:record Device:dev WarnDict:warnDic];
                    
                    dispatch_group_leave(group);
                }];
                
            }
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakself.groupTable reloadData];
    });
    
}

/**
 处理查回的分组子设备

 @param members 单组的子设备数组
 @param group 分组
 */
- (void)handleDevices:(NSArray <DeviceInfo *>*)members CurrentGroup:(TH_GroupInfo *)group{

    //遍历所有组，取得对应的组
    for (int j=0; j<self.groupDatasource.count; j++) {
        TH_GroupInfo * oldGroup = self.groupDatasource[j][@"group"];
        if ([oldGroup.mac isEqualToString:group.mac]) {
            //取得原组里的子设备数组
            NSMutableArray <NSMutableDictionary *>* oldDevs = self.groupDatasource[j][@"devices"];
            //遍历新子设备、原子设备，Mac相同的替换旧设备
            for (int m=0; m<members.count; m++) {
                DeviceInfo * newMember = members[m];
                int indexM = -1;
                for (int n=0; n<oldDevs.count; n++) {
                    DeviceInfo * oldMember = oldDevs[n][@"device"];
                    if ([oldMember.mac isEqualToString:newMember.mac]) {
                        //替换旧设备为新设备
                        newMember.sdata = oldMember.sdata;
                        [oldDevs[n] setValue:newMember forKey:@"device"];
                        indexM = n;
                        break ;
                    }
                }
                //新旧设备有更迭，继续下一个循环
                if (indexM >= 0) {
                    continue ;
                }
                //未更迭，添加新数据
                NSMutableDictionary * mdicM = [NSMutableDictionary dictionary];
                [mdicM setValue:newMember forKey:@"device"];
                if (oldDevs == nil) {
                    [self.groupDatasource[j] setValue:[NSMutableArray array] forKey:@"devices"];
                    oldDevs = self.groupDatasource[j][@"devices"];
                }
                [oldDevs addObject:mdicM];
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.groupTable reloadSections:[NSIndexSet indexSetWithIndex:j] withRowAnimation:UITableViewRowAnimationNone];
//            });
            break ;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.groupTable reloadData];
    });
}

/**
 处理查回的报警设置记录
 
 @param record 报警设置记录
 @param dev 当前操作的设备
 @param warnDic 当前操作的对应报警字典
 */
- (void)handleWarnSetRecord:(WarnSetRecord *)record Device:(DeviceInfo *)dev WarnDict:(NSMutableDictionary *)warnDic{
    
    float tpmin = record ? record.threshold.tempMin.value : 0;
    float tpmax = record ? record.threshold.tempMax.value : 30;
    float hmmin = record ? record.threshold.humiMin.value : 10;
    float hmmax = record ? record.threshold.humiMax.value : 70;
    bool ison = record ? record.ison : true;
    
    [warnDic setValue:@(tpmin) forKey:@"tempMin"];
    [warnDic setValue:@(tpmax) forKey:@"tempMax"];
    [warnDic setValue:@(hmmin) forKey:@"humiMin"];
    [warnDic setValue:@(hmmax) forKey:@"humiMax"];
    
    //3分钟内不再报警
    NSTimeInterval lastTime = [WarnConfirm readByMac:dev.mac].time;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime - lastTime < 180) {
        return ;
    }
    
    //温度判断
    if (dev.temeratureBySData == -1000) {
        [warnDic setValue:@(false) forKey:@"tempWarn"];
    } else {
        if (dev.temeratureBySData <= tpmin ||
            dev.temeratureBySData >= tpmax) {
            [warnDic setValue:@(ison) forKey:@"tempWarn"];
        }else {
            [warnDic setValue:@(false) forKey:@"tempWarn"];
        }
    }
    
    //湿度判断
    if (dev.humidityBySData == -1000) {
        [warnDic setValue:@(false) forKey:@"humiWarn"];
    } else{
        if (dev.humidityBySData <= hmmin ||
            dev.humidityBySData >= hmmax) {
            [warnDic setValue:@(ison) forKey:@"humiWarn"];
        }else {
            [warnDic setValue:@(false) forKey:@"humiWarn"];
        }
    }
    
}

@end
