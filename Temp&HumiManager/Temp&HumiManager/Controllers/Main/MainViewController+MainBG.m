//
//  MainViewController+MainBG.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController+MainBG.h"
#import "MainViewController+MainExtention.h"

#import "HTTP_SelectAllDevices.h"
#import "HTTP_ReigistUser.h"
#import "HTTP_SelectAllDevices.h"
#import "HTTP_GroupManager.h"
#import "HTTP_MemberManager.h"
#import "FMDB_DeviceInfo.h"

#import "THBlueToothManager.h"

@implementation MainViewController (MainBG)


- (void)startTimer{

    //定时查网络信息
    if (self.selectTimer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        self.selectTimer = gcd_timer(self.selectTimer, 7, queue, ^{
            [self selectAllDevices];
//            [self selectGroups];
        });
    }

    //定时查报警
    if (self.warningTimer == nil) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        self.warningTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.warningTimer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.warningTimer, ^{
            [self warningCheck];
        });
        dispatch_resume(self.warningTimer);
    }
}

//- (void)selectGroups{
//    LRWeakSelf(self);
//    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
//    HTTP_GroupManager *manager = [HTTP_GroupManager shreadInstance];
//    [manager selectGroupOfUserWithUid:user.uid Pwd:user.upwd];
//    manager.didGetGroups = ^(NSArray<TH_GroupInfo *> *groups) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself refershArrayAndUIWithGroups:groups];
//            [weakself selectMemberOfGroups];
//        });
//
//
//    };
//}

- (void)selectAllDevices{

    LRWeakSelf(self);
    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];

    //如果本地没有用户信息，则3s后再递归回来继续，知道本地有数据为止
    if (!user) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself selectAllDevices];
        });
        return ;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        //查所有关注设备
        [[HTTP_SelectAllDevices sharedInstance] selectAllDevicesWithUid:user.uid Block:^(NSArray<DeviceInfo *> *devsInfo) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself refershArrayAndUIWithDevs:devsInfo];
            });
        }];
    });
}

/*!
 * 搜索蓝牙设备
 */
- (void)searchBLEDevices{

    LRWeakSelf(self);
    async_bgqueue(^{

        THBlueToothManager * managerer = [THBlueToothManager sharedInstance];

        //搜索到设备的回调
        managerer.discoveredPeripheral = ^(BlueToothManager *manager, BlueToothInfo *peripheral) {
            if (weakself.bleDatas.count < manager.discoveredPeripherals.count) {
                [weakself.bleDatas addObjectsFromArray:manager.discoveredPeripherals];
                
            }
        };
        [managerer startScan];
//        manager.discoveredPeripheral = ^(CBPeripheral *peripheral) {
//            
//        };
//        weakself.bleManager.discoverPeripheral = ^(BLEManager *manager, MyPeripheral *peripheral) {
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [weakself refershArrayAndUIWithBLEPeripheral:peripheral CBPeripheral:peripheral.peripheral BLEDiscoverPeripherals:manager.discoveredPeripherals];
//            });
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotiName_ToBleSetControler object:peripheral];
//        };
//        [weakself.bleManager startScan];
    });
}

- (void)linkDeviceWithMac:(NSString *)mac Name:(NSString *)name{

//    NSLog(@"%@ %@",mac,name);
    LRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{

        [[HTTP_SelectAllDevices sharedInstance] linkDevWithMac:mac Name:name Block:^(bool success, NSString *info) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showAlertWithTitle:@"Tips" Message:info DismissTime:1.5];
            });
        }];
    });
}

/*!
 * 报警检测
 */
- (void)warningCheck{

    LRWeakSelf(self);
    NSMutableArray *tempObjects = self.mainCollection.objects;

    //创建组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    for (int i=0; i<tempObjects.count; i++) {
        MyGroupCollectionObject *gco = [tempObjects objectAtIndex:i];

        for (MainCollectionObject *mco in gco.infos) {

            //加进组
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{

                [[FMDB_DeviceInfo sharedInstance] selectAllByMac:mco.mac Block:^(NSArray<FMDB_DeviceInfo *> *allDevInfos) {

                    if (allDevInfos.count == 1) {
                        FMDB_DeviceInfo *devInfo = [allDevInfos firstObject];
                        //                    LRLog(@"%@ %d",devInfo.mac,devInfo.isWarn);

                        if (devInfo.isWarn) {
                            //报警判断
                            [weakself parse:mco
                                    maxTemp:devInfo.overTemper
                                    minTemp:devInfo.lessTemper
                                    maxHumi:devInfo.overHumidi
                                    minHumi:devInfo.lessHumidi
                                   TempTime:devInfo.tempTime
                                   HumiTime:devInfo.humiTime];

                        } else {
                            mco.humiWarning = false;
                            mco.tempWarning = false;
                        }
                    }
                    //没有，默认开启®
                    else if (allDevInfos.count == 0){

                        float tempMax = 35;
                        float tempMin = 10;
                        int humiMax = 70;
                        int humiMin = 20;

                        if (gco.type == MyGroupCollectionType_Section) {

                        } else {
                            //报警判断
                            [weakself parse:mco maxTemp:tempMax minTemp:tempMin maxHumi:humiMax minHumi:humiMin TempTime:0 HumiTime:0];
                        }
                    } else {
                        LRLog(@"数据库 错误的个数 : %@",allDevInfos);
                    }

                    //移除组
                    dispatch_group_leave(group);
                }];
            });
        }
    }

    //组任务全部完结
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.mainCollection.objects = tempObjects;
        [self.mainCollection reloadData];
    });
}

- (void)showWarningViewWithIndexPath:(NSIndexPath *)indexPath{

    MainCollectionCell *cell = (MainCollectionCell *)[self.mainCollection cellForItemAtIndexPath:indexPath];
    MyGroupCollectionObject *mgco = [self.mainCollection.objects objectAtIndex:indexPath.section];
    MainCollectionObject *mco = [mgco.infos objectAtIndex:indexPath.row];

    NSMutableArray<TH_LableImvView *>* thliViews = [NSMutableArray array];

    bool tempTPWarn = mco.tempWarning;
    bool tempHMWarn = mco.humiWarning;

    if (mco.tempWarning) {
        TH_LableImvView *view = [[TH_LableImvView alloc]init];
        view.imv1.image = [UIImage imageNamed:@"warning"];
        view.imv2.image = [UIImage imageNamed:@"tempar_black"];
        view.lab1.text = [NSString stringWithFormat:@"%.1f< >%.1f",mco.thresholdTemp.min,mco.thresholdTemp.max];
        [view.lab1 sizeToFit];
        view.lab2.text = cell.temparature;
        [view.lab2 sizeToFit];
        [thliViews addObject:view];
    }

    if (mco.humiWarning) {
        TH_LableImvView *view = [[TH_LableImvView alloc]init];
        view.imv1.image = [UIImage imageNamed:@"warning"];
        view.imv2.image = [UIImage imageNamed:@"humi_black"];
        view.lab1.text = [NSString stringWithFormat:@"%.0f%%< >%.0f%%",mco.thresholdHumi.min,mco.thresholdHumi.max];
        [view.lab1 sizeToFit];
        view.lab2.text = cell.humidity;
        [view.lab2 sizeToFit];
        [thliViews addObject:view];
    }


    LRWeakSelf(self);
    MyAlertView *alert = [[MyAlertView alloc]init];
    [alert showTHLITitle:[NSString stringWithFormat:
                          @"%@ Warning",mco.nickName?mco.nickName:mco.bleInfo.peripheral.name]
                 confirm:@"I Know"
            confirmBlock:^(MyAlertView *alertView) {

                //设置确认时间
                async_bgqueue(^{

                    [[FMDB_DeviceInfo sharedInstance] selectAllByMac:mco.mac Block:^(NSArray<FMDB_DeviceInfo *> *allDevInfos) {

                        FMDB_DeviceInfo *dev;
                        if (allDevInfos.count == 0) {
                            dev = [[FMDB_DeviceInfo alloc]init];
                            dev.mac = mco.mac;
                            if (tempHMWarn) {
                                dev.humiTime = [[NSDate date] timeIntervalSince1970];
                            }
                            if (tempTPWarn) {
                                dev.tempTime = [[NSDate date] timeIntervalSince1970];
                            }
                            dev.isWarn = true;
                            dev.showName = mco.showName;
                            dev.motostep = mco.motostep;
                            dev.lessTemper = 10;
                            dev.lessHumidi = 10;
                            dev.overTemper = 35;
                            dev.overHumidi = 70;
                            [dev insert];
                        } else {
                            dev = [allDevInfos firstObject];
                            if (tempHMWarn) {
                                dev.humiTime = [[NSDate date] timeIntervalSince1970];
                                [dev updateHumiTime];
                            }
                            if (tempTPWarn) {
                                dev.tempTime = [[NSDate date] timeIntervalSince1970];
                                [dev updateTempTime];
                            }
                        }
                    }];
                });

                mco.tempWarning = false;
                mco.humiWarning = false;

                [mgco.infos replaceObjectAtIndex:indexPath.row withObject:mco];
                [weakself.mainCollection.objects replaceObjectAtIndex:indexPath.section withObject:mgco];

            }
           THLIViewArray:thliViews];
}

//==========================================================================

#pragma mark - inside method
/*!
 * 刷新网络关注的设备信息,需在主线程中调用
 * @param devsInfo 关注的设备信息集
 */
- (void)refershArrayAndUIWithDevs:(NSArray<DeviceInfo *> *)devsInfo{

    //根据查回的 关注数据 生成新的 组对象集
    NSMutableArray <MyGroupCollectionObject*>* newGcos = [NSMutableArray array];
    //取得旧的数据
    NSMutableArray <MyGroupCollectionObject*>* oldGcos = [NSMutableArray arrayWithArray:self.mainCollection.objects];

    for (DeviceInfo *di in devsInfo) {
        //生成新的组对象
        MyGroupCollectionObject *gcoNew = [[MyGroupCollectionObject alloc]init];
        //此步是将新的单个对象信息进行赋予
        MainCollectionObject *mcoNew = [[MainCollectionObject alloc]initWithDeviceInfo:di];
        //其他信息赋予
        mcoNew.tempUnit = [self getTemparatureUnit];
        //网络数据赋予
        [self setInternetObject:mcoNew Sensors:di.sensors];
        mcoNew.isWifi = true;

        [gcoNew.infos addObject:mcoNew];
        [newGcos addObject:gcoNew];
    }

    //更新旧的数组
    for (MyGroupCollectionObject *gcoOld in oldGcos.reverseObjectEnumerator) {
        for (MainCollectionObject *mcoOld in gcoOld.infos.reverseObjectEnumerator) {

            for (MyGroupCollectionObject *gcoNew in newGcos.reverseObjectEnumerator) {
                for (MainCollectionObject *mcoNew in gcoNew.infos.reverseObjectEnumerator) {

                    if ([mcoOld.mac compare:mcoNew.mac options:NSCaseInsensitiveSearch] == NSOrderedSame) {

                        [mcoOld setWifiInfoWithWifiObject:mcoNew];

                        NSInteger indexRow = [gcoOld.infos indexOfObject:mcoOld];
                        [gcoOld.infos replaceObjectAtIndex:indexRow withObject:mcoOld];
                        NSInteger indexSec = [oldGcos indexOfObject:gcoOld];
                        [oldGcos replaceObjectAtIndex:indexSec withObject:gcoOld];

                        [newGcos removeObject:gcoNew];

                        break ;
                    }
                }
            }
        }
    }

    [oldGcos addObjectsFromArray:newGcos];

    [self orderArray:oldGcos];

    self.mainCollection.objects = oldGcos;
    [self.mainCollection reloadData];

}

/*!
 * 刷新扫描到的蓝牙设备
 */
- (void)refershArrayAndUIWithBLEPeripheral:(MyPeripheral *)info CBPeripheral:(CBPeripheral *)peripheral BLEDiscoverPeripherals:(NSArray <MyPeripheral *>*)peripherals{

    //过滤设备
    if (info.macAddress == nil || ![info.peripheral.name containsString:@"PX-HP"]) {
        return ;
    }

    //先生成一个新的对象
    MainCollectionObject *mcoNew = [[MainCollectionObject alloc]init];
    mcoNew.mac = info.macAddress;
    mcoNew.bleInfo = info;
    mcoNew.isBle = true;

    //解析蓝牙数据赋予
    [self setDataWithManuData:info Object:mcoNew];

    NSMutableArray <MyGroupCollectionObject *>* oldGcos = [NSMutableArray arrayWithArray:self.mainCollection.objects];

    bool isEqual = false;
    for (MyGroupCollectionObject *gcoOld in oldGcos.reverseObjectEnumerator) {
        for (MainCollectionObject *mcoOld in gcoOld.infos.reverseObjectEnumerator) {
            if ([mcoOld.mac compare:mcoNew.mac options:NSCaseInsensitiveSearch] == NSOrderedSame) {

                //蓝牙数据赋予
                [mcoOld setBleInfoWithBleObject:mcoNew];

                NSInteger indexRow = [gcoOld.infos indexOfObject:mcoOld];
                [gcoOld.infos replaceObjectAtIndex:indexRow withObject:mcoOld];
                NSInteger indexSec = [oldGcos indexOfObject:gcoOld];
                [oldGcos replaceObjectAtIndex:indexSec withObject:gcoOld];

                isEqual = true;

                break ;
            }
        }
        if (isEqual) {
            break ;
        }
    }

    if (!isEqual) {
        MyGroupCollectionObject *gcoNew = [[MyGroupCollectionObject alloc]init];
        [gcoNew.infos addObject:mcoNew];
        [oldGcos addObject:gcoNew];
    }

    self.mainCollection.objects = oldGcos;
    [self.mainCollection reloadData];

}

/*!
 * 刷新网络里的分组
 */
- (void)refershArrayAndUIWithGroups:(NSArray<TH_GroupInfo *> *)groups{

    NSMutableArray <MyGroupCollectionObject *>* newGcos = [NSMutableArray array];
    for (TH_GroupInfo *gi in groups) {
        MyGroupCollectionObject *gco = [[MyGroupCollectionObject alloc]init];
        gco.type = MyGroupCollectionType_Section;
        gco.groupInfo = gi;
        [newGcos addObject:gco];
    }
    NSMutableArray <MyGroupCollectionObject *>* oldGcos = [NSMutableArray arrayWithArray:self.mainCollection.objects];

    for (MyGroupCollectionObject *gcoNew in newGcos.reverseObjectEnumerator) {
        for (MyGroupCollectionObject *gcoOld in oldGcos.reverseObjectEnumerator) {
            if ([gcoNew.groupInfo.mac compare:gcoOld.groupInfo.mac options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                gcoNew.flex = gcoOld.flex;

                [oldGcos removeObject:gcoOld];
                NSInteger index = [newGcos indexOfObject:gcoNew];
                [newGcos replaceObjectAtIndex:index withObject:gcoNew];
            }
        }
    }

    [newGcos addObjectsFromArray:oldGcos];

    self.mainCollection.objects = newGcos;
}

/**
 * 查询所有组的组成员,需在主线程中调用
 */
- (void)selectMemberOfGroups{

//    int i=0;
//    if (i==0) {
//        return ;
//    }
    
    LRWeakSelf(self);

    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];

    NSMutableArray <MyGroupCollectionObject *>* oldGroups = [NSMutableArray array];
    NSMutableArray <MyGroupCollectionObject *>* oldGcos = [NSMutableArray arrayWithArray:self.mainCollection.objects];

    //便利筛选出所有组对象
    for (MyGroupCollectionObject *gco in oldGcos.reverseObjectEnumerator) {
        if (gco.type == MyGroupCollectionType_Section) {
            [oldGroups addObject:gco];
            [oldGcos removeObject:gco];
        }
    }

    /**
     * 生成dispatch semaphore，计数初始值为1
     * 保证查询组成员的线程同时只有一个
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    for (NSInteger i=oldGroups.count-1; i>=0; i--) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

            /**
             * 等待dispatch semaphore
             * 一直等待，直到dispatch semaphore的计数值大于等于1
             */
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

            MyGroupCollectionObject *oldGco = oldGroups[i];

            HTTP_MemberManager *manager = [HTTP_MemberManager shareadInstance];
            [manager selectMembersWithUid:user.uid Gid:oldGco.groupInfo.gid];
            manager.didGetMembers = ^(HTTP_MemberManager *manager, NSArray<DeviceInfo *> *members) {
                NSMutableArray <MainCollectionObject *>* newMcos = [NSMutableArray array];
                //生成新的单组所有对象集
                for (DeviceInfo *di in members) {
                    MainCollectionObject *mcoNew = [[MainCollectionObject alloc]initWithDeviceInfo:di];
                    [newMcos addObject:mcoNew];
                }

                //新旧遍历对比，如果相同就将 新成员对象的数据 给 旧成员对象，并替换对应旧成员对象
                for (MainCollectionObject *mcoOld in oldGco.infos.reverseObjectEnumerator) {
                    for (MainCollectionObject *mcoNew in newMcos.reverseObjectEnumerator) {
                        if ([mcoNew isEqualOfMacTo:mcoOld]) {

                            //将新的网络数据给旧的
                            [mcoOld setWifiInfoWithWifiObject:mcoNew];

                            //替换旧的
                            NSInteger index = [oldGco.infos indexOfObject:mcoOld];
                            [oldGco.infos replaceObjectAtIndex:index withObject:mcoOld];

                            //删除新对象集中相同的
                            NSInteger index1 = [newMcos indexOfObject:mcoNew];
                            [newMcos replaceObjectAtIndex:index1 withObject:mcoNew];

                            break ;
                        }
                    }
                }

                //将没有与原数据相同的添加进来
                [oldGco.infos addObjectsFromArray:newMcos];

                //替换旧的 组对象
                [oldGroups replaceObjectAtIndex:i withObject:oldGco];

                //添加之前的非组对象到后边
                [oldGroups addObjectsFromArray:oldGcos];

                //刷新单组
                dispatch_async(dispatch_get_main_queue(), ^{

                    //                    weakself.mainCollection.objects = oldGroups;
                    ////                    [weakself.mainCollection reloadSections:[NSIndexSet indexSetWithIndex:i]];
                    [weakself.mainCollection reloadData];
                });

                /**
                 * 将dispatch semaphore的计数值加1
                 * 如果有通过dispatch_semaphore_wait函数等待dispatch semaphore增加的线程，就由最先等待的线程执行
                 */
                dispatch_semaphore_signal(semaphore);
            };
            manager.getFail = ^(HTTP_MemberManager *manager, NSString *failInfo) {

            };
        });
    }
}

/*!
 * 根据温湿度阈值以及对应的对象 解析赋值温湿度是否报警
 */
- (void)parse:(MainCollectionObject *)mco maxTemp:(float)tempMax minTemp:(float)tempMin maxHumi:(float)humiMax minHumi:(float)humiMin TempTime:(NSTimeInterval)tptime HumiTime:(NSTimeInterval)hmtime{

    mco.thresholdHumi = ThresholdMake(humiMin, humiMax);
    mco.thresholdTemp = ThresholdMake(tempMin, tempMax);

    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];

    switch ([mco hasData]) {
        case MCODataType_Wifi://有网络数据
        {
            //用网络温度数据与阈值比较确定是否报警
            if ((mco.temperatureWifi > tempMax) || (mco.temperatureWifi < tempMin)) {
                mco.tempWarning = ((nowTime - tptime) > 180);
            } else {
                mco.tempWarning = false;
            }

            //用网络湿度数据与阈值比较确定是否报警
            if ((mco.humidityWifi > humiMax) || (mco.humidityWifi < humiMin)) {
                mco.humiWarning = ((nowTime - hmtime) > 180);
            } else {
                mco.humiWarning = false;
            }
        }
            break;

        case MCODataType_Ble://有蓝牙数据
        {
            //用蓝牙温度数据与阈值比较确定是否报警
            if ((mco.temperatureBle > tempMax) || (mco.temperatureBle < tempMin)) {
                mco.tempWarning = ((nowTime - tptime) > 180);
            } else {
                mco.tempWarning = false;
            }

            //用蓝牙湿度数据与阈值比较确定是否报警
            if ((mco.humidityBle > humiMax) || (mco.humidityBle < humiMin)) {
                mco.humiWarning = ((nowTime - hmtime) > 180);
            } else {
                mco.humiWarning = false;
            }
        }
            break;

        default://二者数据都没有
        {
            mco.tempWarning = false;
            mco.humiWarning = false;
        }
            break;
    }
}

#pragma mark ----- 便利方法

/*!
 * 数组排序
 */
- (void)orderArray:(NSMutableArray <MyGroupCollectionObject *>*)array{

    //分组对象提前
    for (NSInteger i = array.count-1; i>0; i--) {
        for (NSInteger j = array.count-1; j>array.count - i - 1; j--) {
            MyGroupCollectionObject *gcoNext = [array objectAtIndex:j];//后
            MyGroupCollectionObject *gcoLast = [array objectAtIndex:j-1];//前
            if (gcoNext.type == MyGroupCollectionType_Section && gcoLast.type == MyGroupCollectionType_Default) {
                MyGroupCollectionObject *t = [array objectAtIndex:j-1];
                array[j-1] = array[j];
                array[j] = t;
            }
        }
    }

    //每组对象中的 网络对象提前
    for (MyGroupCollectionObject *gco in array) {
        for (NSInteger i=gco.infos.count-1; i>0; i--) {
            for (NSInteger j=gco.infos.count-1; j>gco.infos.count-i-1; j--) {
                MainCollectionObject *mcoLast = [gco.infos objectAtIndex:j-1];
                MainCollectionObject *mcoNext = [gco.infos objectAtIndex:j];
                if (!mcoLast.isWifi && mcoNext.isWifi) {
                    MainCollectionObject *t = [gco.infos objectAtIndex:j-1];
                    gco.infos[j-1] = gco.infos[j];
                    gco.infos[j] = t;

                    NSInteger index = [array indexOfObject:gco];
                    [array replaceObjectAtIndex:index withObject:gco];
                }
            }
        }
    }

    //单个对象中 网络对象提前
    for (NSInteger i=array.count-1; i>0; i--) {
        for (NSInteger j=array.count-1; j>array.count-i-1; j--) {
            MyGroupCollectionObject *gcoNext = [array objectAtIndex:j];
            MyGroupCollectionObject *gcoLast = [array objectAtIndex:j-1];
            if (gcoLast.type == MyGroupCollectionType_Section) {
                continue ;
            }
            MainCollectionObject *mcoNext = [gcoNext.infos firstObject];
            MainCollectionObject *mcoLast = [gcoLast.infos firstObject];
            if (!mcoLast.isWifi && mcoNext.isWifi) {
                MyGroupCollectionObject *t = [array objectAtIndex:j-1];
                array[j-1] = array[j];
                array[j] = t;
            }
        }
    }

}

/*!
 * 将网络查到的数据赋予给对象
 */
- (void)setInternetObject:(MainCollectionObject *)mco Sensors:(NSArray<NSValue *> *)sensors{

    //数据赋予
    for (NSValue *value in sensors) {
        if (value == nil) {
            continue ;
        }

        MemberSensor sensor = [DeviceInfo MemberSensorValue:value];

        switch (sensor.type) {
            case SensorType_Temparature:
                //                gco.info.tempWifiText = [NSString stringWithFormat:@"%.1f%@",sensor.value,[self getTemparatureUnit]];
                mco.temperatureWifi = sensor.value;
                break;
            case SensorType_Humidity:
                //                gco.info.humiWifiText = [NSString stringWithFormat:@"%.0f%%",sensor.value];
                mco.humidityWifi = sensor.value;
                break;

            default:
                break;
        }
    }
}

- (NSString *)getTemparatureUnit{
    APPGlobalObject *gobc = [[MyArchiverManager sharedInstance] readGlobalObject];
    if (gobc) {
        return gobc.unitType?@"˚F":@"˚C";
    } else{
        return @"˚C";
    }
}

/*!
 * 根据蓝牙的广播解析数据
 */
- (void)setDataWithManuData:(MyPeripheral *)info Object:(MainCollectionObject *)mco{

    if (info.manufacture) {

        NSString *dataStr = [info.manufacture.description getStringBetweenFormerString:@"<" AndLaterString:@">"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];

        if (dataStr.length >= 20 ) {
            int power = [[dataStr substringWithRange:NSMakeRange(18, 2)] toDecimalByHex];
//            newObj.info.powerBleText = [NSString stringWithFormat:@"%d%%",power];
            mco.powerBle = power;
        }

        if (dataStr.length >= 24 ) {

            NSString *unit = [self getTemparatureUnit];

            bool positive = [[dataStr stringOfIndex:20] isEqualToString:@"0"];
            int temp = [[dataStr substringWithRange:NSMakeRange(21, 3)] toDecimalByHex];
            float temperature = positive?(temp/100.0):-(temp/100.0);
//            newObj.info.tempBleText = [NSString stringWithFormat:@"%.1f%@",temperature,unit];
            mco.temperatureBle = temperature;
            mco.tempUnit = unit;
        }

        if (dataStr.length >= 26) {
            int humi = [[dataStr substringWithRange:NSMakeRange(24, 2)] toDecimalByHex];
//            newObj.info.humiBleText = [NSString stringWithFormat:@"%d%%",humi];
            mco.humidityBle = humi;
        }
    }
//    return newObj;
}



@end
