//
//  SettingController+SettingBG.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/24.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingController+SettingBG.h"
#import "SettingController+SettingExtension.h"
#import "BLEManager.h"
#import "AddNewGroupController.h"
#import "THBlueToothManager.h"

@implementation SettingController (SettingBG)

/*!
 * 根据一些本地信息设置UI状态
 */
- (void)setLocalInfo{

    APPGlobalObject *gobc = [[MyArchiverManager sharedInstance] readGlobalObject];
    if (gobc) {
        self.tfWifi.text = gobc.wifiName;
        self.tfPwd.text = gobc.wifiPwd;

        if (!gobc.unitType) {
            self.btn_C.selected = true;
            [self.btn_C setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];

            self.btn_F.selected = false;
            [self.btn_F setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        } else{

            self.btn_C.selected = false;
            [self.btn_C setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];

            self.btn_F.selected = true;
            [self.btn_F setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];
        }

//        self.btn_wfi.selected = gobc.isWifiType;
//        [self.btn_wfi setBackgroundImage:[UIImage imageNamed:gobc.isWifiType?@"cycn_circle":@"gray_circle"] forState:UIControlStateNormal];
//
//        self.btn_ble.selected = !gobc.isWifiType;
//        [self.btn_ble setBackgroundImage:[UIImage imageNamed:gobc.isWifiType?@"gray_circle":@"cycn_circle"] forState:UIControlStateNormal];

//        self.groupView.hidden = !gobc.isWifiType;

        self.tfSecond.textField.text = [NSString stringWithFormat:@"%d",gobc.closeSec];
        self.tfMinute.textField.text = [NSString stringWithFormat:@"%d",gobc.closeMin];
    }
}

/*!
 * 查询关注的组
 */
- (void)selectGroups{
//    __weak typeof(self) weakself = self;
    LRWeakSelf(self);
    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
    HTTP_GroupManager *manager = [HTTP_GroupManager shreadInstance];
    [manager selectGroupOfUserWithUid:user.uid Pwd:user.upwd];
    manager.didGetGroups = ^(NSArray<TH_GroupInfo *> *groups) {

        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself.chooseGroup.alertTable.datasArray addObjectsFromArray:groups];
//            [weakself.chooseGroup.alertTable reloadData];
            [weakself.groupTable.datasArray addObjectsFromArray:groups];
            [weakself.groupTable reloadData];
        });
    };
}

/*!
 * 设置点击分组列表的回调（）
 */
- (void)didSelectGroup{

    LRWeakSelf(self);
    self.groupTable.didSelectRow = ^(SettingGroupAlert *sgAlert, NSIndexPath *indexPath) {

        if (indexPath.row == sgAlert.datasArray.count) {

            [weakself executeShowAddNewGroupView];
        } else {
//            TH_GroupInfo *gp = [sgAlert.datasArray objectAtIndex:indexPath.row];
//            weakself.chooseGroup.labText.text = gp.name;
//            [weakself.chooseGroup.labText sizeToFit];
//            [sgAlert dismiss];
        }

    };
}

- (void)executeSetWifiWithDevice:(MyPeripheral *)info{

    LRWeakSelf(self);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
        MyIndicatorView *indicator = [[MyIndicatorView alloc]init];
        LRWeakSelf(indicator);
        indicator.labText.text = [NSString stringWithFormat:@"Connecting '%@'..",info.peripheral.name];
        [indicator.labText sizeToFit];
        [indicator showBlock:^(MyIndicatorView *indicator) {
            
            dispatch_queue_t golbalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_async(golbalQueue, ^{
                //连接设备
                [[BLEManager shareInstance] connectCBPeripheral:info.peripheral Block:^(bool success, NSString *info, CBPeripheral *peripheral) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //连接成功
                        if (success) {
                            indicator.labText.text = @"Setting WIFI..";
                            [indicator.labText sizeToFit];
                            //请求设置配网信息
                            [weakself startSetWifiWithIndicator:indicator Peripheral:peripheral];
                        } else {
                            [indicator dismiss];
                            [weakself showAlertTipTitle:@"Tip" Message:@"Connect Fail !" DismissTime:1.5];
                        }
                    });
                    
                }];
            });
        }];
        //超时处理
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakindicator) {
                [weakindicator dismiss];
                [weakself showAlertTipTitle:@"Tip" Message:@"Setting WIFI Fail !" DismissTime:1.5];
            }
        });
    });


}

/*!
 * 判断条件，执行配网
 */
- (void)executeSetWifi{

    //获得所有是网关的设备
    NSArray <MyPeripheral *>* gatewaies = [self getGatewayDevices];

    //没有网关设备
    if (gatewaies.count == 0) {
        [self showAlertWithTitle:@"Tip" Message:@"No Searched Gateway Device !" DismissTime:1.5];
        return ;
    }

    //获得距离最近的设备
    MyPeripheral *minPeri = [gatewaies firstObject];
    for (MyPeripheral *peri in gatewaies) {
        if ([minPeri distanceByRSSI] > [peri distanceByRSSI]) {
            minPeri = peri;
        }
    }

    if (minPeri.peripheral != nil) {

        LRWeakSelf(self);
        //显示加载框
        MyIndicatorView *indicator = [[MyIndicatorView alloc]init];
        LRWeakSelf(indicator);
        indicator.labText.text = [NSString stringWithFormat:@"Connecting '%@'..",minPeri.peripheral.name];
        [indicator.labText sizeToFit];
        [indicator showBlock:^(MyIndicatorView *indicator) {

            async_bgqueue(^{
                //连接设备
                [[BLEManager shareInstance] connectCBPeripheral:minPeri.peripheral Block:^(bool success, NSString *info, CBPeripheral *peripheral) {

                    dispatch_async(dispatch_get_main_queue(), ^{
                        //连接成功
                        if (success) {
                            indicator.labText.text = @"Setting WIFI..";
                            [indicator.labText sizeToFit];
                            //请求设置配网信息
                            [weakself startSetWifiWithIndicator:indicator Peripheral:peripheral];
                        } else {
                            [indicator dismiss];
                            [weakself showAlertTipTitle:@"Tip" Message:@"Connect Fail !" DismissTime:1.5];
                        }
                    });

                }];
            });
        }];
        //超时处理
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakindicator) {
                [weakindicator dismiss];
                [weakself showAlertTipTitle:@"Tip" Message:@"Setting WIFI Fail !" DismissTime:1.5];
            }
        });

    }
}


#pragma mark ----- inside method
/*!
 * 显示添加视图，并执行添加分组等系列操作的判断
 */
- (void)executeShowAddNewGroupView{

    //@"ff4d53d52d6f63a2d204d4f3c2d8c3";

    //获取附近网关设备
    NSMutableArray <MyPeripheral *>* gates = [self getGatewayDevices];
//    MyPeripheral *peri = [[MyPeripheral alloc]init];
//    [gates addObject:peri];
//    [gates addObject:peri];

    AddNewGroupController *add = [[AddNewGroupController alloc]init];
    add.datasArray = gates;
    [self.navigationController pushViewController:add animated:true];

}

- (void)didSearchBleWithNotification:(NSNotification *)notification{

    MyPeripheral* peripheral = (MyPeripheral*)notification.object;
    bool is = false;
    for (MyPeripheral *pp in self.peripherals.reverseObjectEnumerator) {
        if ([pp isEqualToPeripheral:peripheral]) {
            NSInteger index = [self.peripherals indexOfObject:pp];
            [self.peripherals replaceObjectAtIndex:index withObject:peripheral];
            is = true;
            break ;
        }
    }
    if (!is) {
        [self.peripherals addObject:peripheral];
    }
}

/*!
 * 蓝牙请求设置配网信息（与上方判断配网方法相关）
 * @param indicator 上方的加载弹窗
 * @param peripheral 对应的蓝牙设备
 */
- (void)startSetWifiWithIndicator:(MyIndicatorView *)indicator Peripheral:(CBPeripheral *)peripheral{

    LRWeakSelf(self);
    BLEManager *bleManager = [BLEManager shareInstance];

    __block NSString * wifiName;
    __block NSString * wifipwd;
    dispatch_async(dispatch_get_main_queue(), ^{
        wifiName = self.tfWifi.text;
        wifipwd = self.tfPwd.text;
    });

    /*
     三种回调
     */

    bleManager.didResponse = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {
        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
        NSLog(@"result : %@",result);
        if ([result containsString:@"SN$OK"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator dismiss];
                [weakself showAlertTipTitle:@"Tip" Message:@"Configure WIFI Successful !" DismissTime:1.5];
            });
        }
    };
    bleManager.didRequest = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {

    };
    bleManager.didUnknownCharacter = ^(BLEManager *manager, CBPeripheral *peripheral, CBCharacteristic *characteristic) {

        NSString *result = [[NSString alloc] initWithData:characteristic.value  encoding:NSUTF8StringEncoding];
        NSLog(@"result : %@",result);
        if ([result containsString:@"SN$OK"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator dismiss];
                [weakself showAlertTipTitle:@"Tip" Message:@"Configure WIFI Successful !" DismissTime:1.5];
            });
        }
    };

    //发送请求配网
    async_bgqueue(^{
        NSData *data = [[NSString stringWithFormat:@"ID$%@",wifiName] dataUsingEncoding:NSUTF8StringEncoding];
        [bleManager queryWithData:data CBPeripheral:peripheral];
        [NSThread sleepForTimeInterval:0.1];

        data = [[NSString stringWithFormat:@"PW$%@",wifipwd] dataUsingEncoding:NSUTF8StringEncoding];
        [bleManager queryWithData:data CBPeripheral:peripheral];
        [NSThread sleepForTimeInterval:0.1];

        data = [[NSString stringWithFormat:@"SN$"] dataUsingEncoding:NSUTF8StringEncoding];
        [bleManager queryWithData:data CBPeripheral:peripheral];
        [NSThread sleepForTimeInterval:0.1];
    });

}

/*!
 * 判断蓝牙设备是否是网关
 * @param peripheral 蓝牙设备
 */
- (bool)isGatewayDevice:(MyPeripheral *)peripheral{
    NSString *manuStr = [peripheral manuString];//
    NSRange range = [manuStr rangeOfString:@"4d53"];
    if (range.length > 0 && (range.location+28) >= manuStr.length) {
        NSString* valueStr = [manuStr substringWithRange:NSMakeRange(range.location+4, 24)];
        NSString* typeStr = [valueStr substringWithRange:NSMakeRange(12, 2)];
        int type = [typeStr toDecimalByHex];
        if (type == 4) {
            return true;
        } else {
            return false;
        }
    }
    return false;
}

/*!
 * 从当前的所有搜索到的蓝牙设备中筛选获得所有网关设备
 */
- (NSMutableArray <MyPeripheral *>*)getGatewayDevices{

    BLEManager* manager = [BLEManager shareInstance];
//    LRLog(@"--%@",manager.discoveredPeripherals);

    NSMutableArray <MyPeripheral *>* newPeris = [NSMutableArray arrayWithArray:manager.discoveredPeripherals];
    return newPeris;
//    NSMutableArray <MyPeripheral *>* gatewaies = [NSMutableArray array];
//    for (MyPeripheral *peri in newPeris) {
//        if ([self isGatewayDevice:peri]) {
//            [gatewaies addObject:peri];
//        }
//    }
//    return gatewaies;
}

@end
