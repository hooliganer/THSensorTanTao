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

@implementation MainListController (BG)

#pragma mark - 外部调用方法

- (void)startBlueToothScan{
    
    NSDictionary * bled = @{@"name":@"啊哈哈哈",@"mac":@"df36fbc37df"};
    NSMutableDictionary * mdic = @{@"fakeble":bled}.mutableCopy;
    NSDictionary * bled1 = @{@"name":@"打算放弃而为",@"mac":@"df36c38ea"};
    NSMutableDictionary * mdic1 = @{@"fakeble":bled1}.mutableCopy;
    [self.bleDatasource addObject:mdic];
    [self.bleDatasource addObject:mdic1];
    [self.bleTable reloadData];
    
    return ;

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
        [self selectDevicesOfGroup];
    });
    dispatch_resume(self.timer1);
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
        [weakself selectDevicesOfGroup];
    }];

//    HTTP_GroupManager * gmanager = [HTTP_GroupManager shreadInstance];
//    UserInfo * user = [MyDefaultManager userInfo];
//    if (user) {
//        [gmanager selectGroupOfUserWithUid:user.uid Pwd:user.upwd];
//    }
//    gmanager.didGetGroups = ^(NSArray<TH_GroupInfo *> *groups) {
//
//        //查询回的数据中遍历比较
//        for (int i=0; i<groups.count; i++) {
//            TH_GroupInfo * newGroup = groups[i];
//            int index = -1;
//            for (int j=0; j<weakself.groupDatasource.count; j++) {
//                TH_GroupInfo * oldGroup = [weakself.groupDatasource[j] valueForKey:@"group"];
//                //如果新旧数据一样，则替换掉旧数据
//                if ([oldGroup.mac isEqual:newGroup.mac]) {
//                    [weakself.groupDatasource[j] setValue:newGroup forKey:@"group"];
//                    index = j;
//                    break ;
//                }
//            }
//            //有新旧数据的更迭,执行下一个循环
//            if (index >= 0) {
//                continue ;
//            }
//            //没有数据的更换，添加新数据
//            NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
//            [mdic setValue:newGroup forKey:@"group"];
//            [mdic setValue:@(false) forKey:@"flex"];
//            [weakself.groupDatasource addObject:mdic];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself.groupTable reloadData];
//        });
//        [weakself selectDevicesOfGroup];
//
//    };

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
                    //                    [[AFManager shared] selectDataOfDevice:user.uid Mac:dev.mac];
                    //                    HTTP_MemberDataManager* mng = [[HTTP_MemberDataManager alloc]init];
                    //                    [mng.dataSets setValue:group forKey:@"group"];
                    //                    [mng.dataSets setValue:dev forKey:@"device"];
                    //                    [mng selectMemberDataWithMac:dev.mac GMac:group.mac];
                    //                    mng.didGetMemberData = ^(HTTP_MemberDataManager *manager, DeviceInfo *device) {
                    //
                    //                    };
                }
            }
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakself.groupTable reloadData];
    });
}

//- (void)handleDevicesData:(NSArray <DeviceInfo *>*)members CurrentGroup:(TH_GroupInfo *)grou

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

@end
