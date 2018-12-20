//
//  MainViewController+BGer.m
//  Temp&HumiManager
//
//  Created by terry on 2018/9/10.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController+BGer.h"
#import "MainViewController+MainExtention.h"

#import "THBlueToothManager.h"
#import "HTTP_GroupManager.h"
#import "HTTP_MemberManager.h"
#import "HTTP_MemberDataManager.h"
#import "HTTP_SelectAllDevices.h"
#import "HTTP_ReigistUser.h"
#import "FMDB_DeviceInfo.h"

@implementation MainViewController (BGer)

#pragma mark - Outside
/*!
 * 开启定时器查询
 */
- (void)setupTimer{
    //定时查网络信息
    if (self.selectTimer == nil) {

        LRWeakSelf(self);
        dispatch_queue_t queue = dispatch_get_main_queue();
        self.selectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.selectTimer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.selectTimer, ^{
            [weakself selectGroups];//查询组
            [weakself selectDeviceData];//查询关注设备
            [weakself selectDataOfDevices];//查询设备数据（分组）
            [weakself selectWarning];//查询报警
        });
        dispatch_resume(self.selectTimer);
    }
}

/*!
 * 搜索蓝牙设备，刷新蓝牙数据
 */
- (void)startBLEData{

    THBlueToothManager * managerer = [THBlueToothManager sharedInstance];
    LRWeakSelf(self);
    //搜索到设备的回调
    managerer.discoveredPeripheral = ^(BlueToothManager *manager, BlueToothInfo *peripheral) {

        //新设备，全部刷新
        if (weakself.bleDatas.count < manager.discoveredPeripherals.count) {
            weakself.bleDatas = [NSMutableArray arrayWithArray:manager.discoveredPeripherals];
            [weakself reDatasource];
        }
        //        //已有设备，更换数据源,刷新单个
        //        else {
        //
        //        }
    };
    dispatch_queue_t que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(que, ^{
        [managerer startScan];
    });
}

#pragma mark - Query Method

/*!
 * 查询报警信息
 */
- (void)selectWarning{

    
    NSLock * lock = [[NSLock alloc]init];
    [lock lock];
    for (int sec=0; sec<self.dataSources.count; sec++) {
        MainTableObject * mto = self.dataSources[sec];
        for (int row=0; row<mto.devices.count; row++) {
            NSMutableDictionary * mdic = mto.devices[row];
            NSString * mac;
            switch (mto.type) {
                case DataType_Ble:
                {
                    BlueToothInfo * bti = [mdic valueForKey:@"ble"];
                    mac = [bti mac];
                }
                    break;
                case DataType_Wifi:
                {
                    DeviceInfo * di = [mdic valueForKey:@"wifi"];
                    mac = di.mac;
                }
                    break;
                default:
                {
                    DeviceInfo * di = [mdic valueForKey:@"wifi"];
                    mac = di.mac;
                }
                    break;
            }

            [[FMDB_DeviceInfo sharedInstance] selectAllByMac:mac Block:^(NSArray<FMDB_DeviceInfo *> *allDevInfos) {

                [mdic setValue:@{@"temp":@(true),@"humi":@(false)} forKey:@"warning"];
                if (allDevInfos.count == 1) {
                    FMDB_DeviceInfo * fd = [allDevInfos firstObject];
                    if (fd.isWarn) {
                        
                    }
                } else if (allDevInfos.count == 0){

                } else {

                }


            }];
            
        }
    }
    //    NSLog(@"----------");
    [lock unlock];
}

/*!
 * 搜索刷新分组设备
 */
- (void)selectGroups{

    LRWeakSelf(self);
    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
    //NSLog(@"%d %@",user.uid,user.upwd);
    HTTP_GroupManager *manager = [HTTP_GroupManager shreadInstance];
    manager.didGetGroups = ^(NSArray<TH_GroupInfo *> *groups) {

        weakself.groupDatas = [NSMutableArray arrayWithArray:groups];
        [weakself reDatasource];
        [weakself selectDevicesOfGroup];
    };
    dispatch_queue_t que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(que, ^{
        [manager selectGroupOfUserWithUid:user.uid Pwd:user.upwd];
    });


}

/*!
 * 搜索刷新关注设备
 */
- (void)selectDeviceData{

    LRWeakSelf(self);
    async_bgqueue(^{
        UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
        //查所有关注设备
        [[HTTP_SelectAllDevices sharedInstance] selectAllDevicesWithUid:user.uid Block:^(NSArray<DeviceInfo *> *devsInfo) {

            weakself.wifiDatas = [NSMutableArray arrayWithArray:devsInfo];
            [weakself reDatasource];

        }];
    });
}

/*!
 * 查询所有分组里的设备
 */
- (void)selectDevicesOfGroup{

    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
    LRWeakSelf(self);

    NSLock * lock = [[NSLock alloc]init];
    [lock lock];
    for (int i=0;i<self.dataSources.count;i++) {

        MainTableObject *mto = self.dataSources[i];

        if (mto.type != DataType_Default) {
            continue ;
        }

        TH_GroupInfo * tgi = mto.group;
        HTTP_MemberManager *manager = [[HTTP_MemberManager alloc]init];
        [manager.dataSet setValue:@(i) forKey:@"section"];
        [manager.dataSet setValue:@(self.groupDatas.count) forKey:@"allCount"];
        [manager.dataSet setValue:mto forKey:@"object"];

        manager.didGetMembers = ^(HTTP_MemberManager *manager, NSArray<DeviceInfo *> *members) {

            NSInteger section = [[manager.dataSet valueForKey:@"section"] integerValue];
            NSInteger allCount = [[manager.dataSet valueForKey:@"allCount"] integerValue];
            MainTableObject * objc = [manager.dataSet valueForKey:@"object"];

            NSMutableArray <NSMutableDictionary *>* oldDevs = [NSMutableArray arrayWithArray:objc.devices];

            [objc.devices removeAllObjects];
            for (DeviceInfo *di in members) {
                NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
                [mdic setValue:di forKey:@"wifi"];
                NSString * newMac = di.mac;
                for (NSMutableDictionary *dicOld in oldDevs) {
                    NSString * oldMac = [weakself macForDevice:dicOld Type:objc.type];
                    if ([oldMac isSameToString:newMac]) {
                        [mdic setValue:dicOld[@"warning"] forKey:@"warning"];
                        break ;
                    }
                }
                [objc.devices addObject:mdic];
            }

            if ((section+1) == allCount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.mainTable reloadData];
                });
            }
        };
        manager.didGetError = ^(NSString *desc) {
        };

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(queue, ^{
            [manager selectMembersWithUid:user.uid Gid:tgi.gid];
        });
    }
    [lock unlock];

}

/*!
 * 查询设备的数据
 */
- (void)selectDataOfDevices{

    NSLock * lock = [[NSLock alloc]init];
    [lock lock];

    LRWeakSelf(self);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    for (int s=0;s<self.dataSources.count;s++) {
        MainTableObject * mto = self.dataSources[s];
        if (mto.type == DataType_Default) {
            for (int i=0; i<mto.devices.count; i++) {

                dispatch_group_enter(group);

                NSMutableDictionary * mdic = [mto.devices objectAtIndex:i];
                DeviceInfo * di = [mdic valueForKey:@"wifi"];

                HTTP_MemberDataManager * manager = [[HTTP_MemberDataManager alloc]init];
                [manager.dataSets setValue:di forKey:@"data"];
                [manager.dataSets setValue:[NSIndexPath indexPathForRow:i inSection:s] forKey:@"indexPath"];

                manager.didGetMemberData = ^(HTTP_MemberDataManager *manager, DeviceInfo *device) {

                    DeviceInfo * oldDev = [manager.dataSets valueForKey:@"data"];
                    oldDev.utime = device.utime;
                    oldDev.tmac = device.tmac;
                    oldDev.uuid = device.uuid;
                    oldDev.sdata = device.sdata;

                    //                    NSLog(@"%@",[dataSets valueForKey:@"indexPath"]);

                    dispatch_group_leave(group);

                };
                manager.didGetError = ^(NSString *desc) {
                    dispatch_group_leave(group);
                };

                dispatch_group_async(group, queue, ^{
                    [manager selectMemberDataWithMac:mto.group.mac GMac:di.mac];
                });
            }

        }
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.mainTable reloadData];
        });
    });

    [lock unlock];

}


- (void)reDatasource{

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLock * lock = [[NSLock alloc]init];
        if ([lock tryLock]) {

            NSMutableArray <TH_GroupInfo *> *groupDatas = [NSMutableArray arrayWithArray:self.groupDatas];
            NSMutableArray <BlueToothInfo *>* bleDatas = [NSMutableArray arrayWithArray:self.bleDatas];
            NSMutableArray <DeviceInfo *>* wifiDatas = [NSMutableArray arrayWithArray:self.wifiDatas];

            NSMutableArray <MainTableObject *>* newDataSource = [NSMutableArray array];

            //分组
            for (TH_GroupInfo * tgi in groupDatas) {
                MainTableObject * mto = [[MainTableObject alloc]init];
                mto.type = DataType_Default;
                mto.group = tgi;
                for (MainTableObject *mtoOld in self.dataSources) {
                    if ([mtoOld.group.mac isSameToString:tgi.mac]) {
                        mto.flex = mtoOld.flex;
                        mto.devices = mtoOld.devices;
                        break ;
                    }
                }
                [newDataSource addObject:mto];
            }

            //关注
            for (DeviceInfo * di in wifiDatas) {
                MainTableObject * mto = [[MainTableObject alloc]init];
                mto.type = DataType_Wifi;
                NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
                [mdic setValue:di forKey:@"wifi"];
                for (BlueToothInfo * bti in bleDatas.reverseObjectEnumerator) {
                    if ([[bti mac] isSameToString:di.mac]) {
                        [mdic setValue:bti forKey:@"ble"];
                        [bleDatas removeObject:bti];
                        break ;
                    }
                }
                [mto.devices addObject:mdic];
                [newDataSource addObject:mto];
            }

            //蓝牙
            for (BlueToothInfo *bti in bleDatas) {
                MainTableObject * mto = [[MainTableObject alloc]init];
                mto.type = DataType_Ble;
                NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
                [mdic setValue:bti forKey:@"ble"];
                [mto.devices addObject:mdic];
                [newDataSource addObject:mto];
            }

            //报警比对
            for (MainTableObject * mtoOld in self.dataSources) {

                int i=0;
            node:{
                if (i<mtoOld.devices.count) {

                    NSMutableDictionary * dicOld = mtoOld.devices[i];
                    NSString * oldMac = [self macForDevice:dicOld Type:mtoOld.type];

                    for (MainTableObject * mtoNew in newDataSource) {
                        for (NSMutableDictionary * dicNew in mtoNew.devices) {
                            NSString * newMac = [self macForDevice:dicNew Type:mtoNew.type];
                            if ([newMac isSameToString:oldMac]) {

                                [dicNew setValue:@{@"temp":@(true),
                                                   @"humi":@(false)} forKey:@"warning"];
                                i++;//使用goto时需要先自增
                                goto node;
                            }
                        }
                    }

                    i++;//使用goto时需要先自增
                    goto node;
                }
            }


            }


            self.dataSources = [NSMutableArray arrayWithArray:newDataSource];

            [self.mainTable reloadData];

            [lock unlock];

        } else {
            LRLog(@"lock fail");
        }
    });
}

- (NSString *)macForDevice:(NSMutableDictionary *)mdic Type:(DataType)type{

    NSString * mac;
    switch (type) {
        case DataType_Ble:
        {
            BlueToothInfo * bti = [mdic valueForKey:@"ble"];
            mac = [bti mac];
        }
            break;
        case DataType_Wifi:
        {
            DeviceInfo * di = [mdic valueForKey:@"wifi"];
            mac = di.mac;
        }
            break;
        default:
        {
            DeviceInfo * di = [mdic valueForKey:@"wifi"];
            mac = di.mac;
        }
            break;
    }
    return mac;
}

@end
