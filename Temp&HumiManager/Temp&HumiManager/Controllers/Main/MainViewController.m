//
//  MainViewController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewController+MainBG.h"
#import "MainViewController+MainExtention.h"
#import "MainViewController+Delegate.h"
#import "MainViewController+BGer.h"

#import "MainCollectionCell.h"
#import "LoginController.h"
#import "SettingController.h"
#import "DetailInfoController.h"

#import "BLE_Manager.h"

@interface MainViewController ()
<MyGroupCollectionDelegate,
BLE_ManagerDelegate>

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initsData];

}

- (void)initsData{

    self.view.backgroundColor = MainColor;

    self.navigationBar.title = @"SENSOR";

    LRWeakSelf(self);
    [self.navigationBar addActionLeftImage:[UIImage imageNamed:@"ic_setting.png"] Block:^{
        SettingController *set = [[SettingController alloc]init];
        [weakself.navigationController pushViewController:set animated:true];
    }];

    [self.navigationBar addActionRightImage:[UIImage imageNamed:@"ic_reflash.png"] Block:^{
        [weakself.mainCollection.objects removeAllObjects];
        [weakself.mainCollection reloadData];
        [weakself selectAllDevices];
    }];

    [self mainTable];

    self.dataSources = [NSMutableArray array];
    self.bleDatas = [NSMutableArray array];
    self.groupDatas = [NSMutableArray array];
    self.wifiDatas = [NSMutableArray array];

    [self setupTimer];
    [self startBLEData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - lazy load
- (UITableView *)mainTable{
    if (_mainTable == nil) {
        _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + 44.0, MainScreenWidth, MainScreenHeight - (StatusBarHeight + 44.0)) style:UITableViewStylePlain];
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tag = MainViewTag_MainCollection;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.estimatedRowHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedSectionFooterHeight = 0;

        [self.view addSubview:_mainTable];
    }
    return _mainTable;
}

#pragma mark - delegate
- (void)collection:(MyGroupCollection *)collection didClickLinkAtIndexPath:(NSIndexPath *)indexPath{

    MyGroupCollectionObject *gcoSec = [collection.objects objectAtIndex:indexPath.section];
    MainCollectionObject *mco = [gcoSec.infos objectAtIndex:indexPath.row];

    [self linkDeviceWithMac:mco.mac Name:mco.nickName?mco.nickName:mco.bleInfo.peripheral.name];

}

- (void)collection:(MyGroupCollection *)collection didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MyGroupCollectionObject *mgco = [collection.objects objectAtIndex:indexPath.section];
    MainCollectionObject *mco = [mgco.infos objectAtIndex:indexPath.row];

    if (mco.tempWarning || mco.humiWarning) {
        [self showWarningViewWithIndexPath:indexPath];
        return ;
    }

//    //蓝牙状态
//    if (mco.isBle) {
//
//        MyIndicatorView *indicator = [[MyIndicatorView alloc]init];
//        indicator.labText.text = @"Connecting..";
//        [indicator.labText sizeToFit];
//
//        LRWeakSelf(self);
//        LRWeakSelf(indicator);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (weakindicator) {
//                [weakindicator dismiss];
//                [weakself showAlertWithTitle:@"Tips" Message:@"Over Time !" DismissTime:2];
//            }
//        });
//        [indicator showBlock:^(MyIndicatorView *indicator) {
//            async_bgqueue(^{

//                BLEManager *manager = [BLEManager shareInstance];
//                [manager connectCBPeripheral:mco.bleInfo.peripheral Block:^(bool success, NSString *info, CBPeripheral *peripheral) {
//
//                    if (success) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [indicator dismiss];
//                            DetailInfoController *detail = [[DetailInfoController alloc]init];
//                            detail.curDevInfo = mco;
//                            [weakself.navigationController pushViewController:detail animated:true];
//                        });
//                    } else {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [indicator dismiss];
//                            [weakself showAlertWithTitle:@"Tips" Message:info DismissTime:3];
//                        });
//                    }
//
//                }];
//            });
//        }];

//    } else if (mco.isWifi){
//        DetailInfoController *detail = [[DetailInfoController alloc]init];
//        detail.curDevInfo = mco;
//        [self.navigationController pushViewController:detail animated:true];
//    } else {
//        LRLog(@"noting??");
//    }
}

#pragma mark ------ <BLE_ManagerDelegate>
- (void)manager:(BLE_Manager *)manager CBManagerPoweredOff:(CBCentralManager *)cbmanager{

    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Please Check Bluetooth State !" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:false completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:false completion:nil];

    NSMutableArray <MyGroupCollectionObject*>* objects = self.mainCollection.objects;
    for (MyGroupCollectionObject *mgco in objects.reverseObjectEnumerator) {
        for (MainCollectionObject *mco in mgco.infos.reverseObjectEnumerator) {
            mco.isBle = false;
            NSInteger index = [mgco.infos indexOfObject:mco];
            [mgco.infos replaceObjectAtIndex:index withObject:mco];
        }
        NSInteger index = [objects indexOfObject:mgco];
        [objects replaceObjectAtIndex:index withObject:mgco];
    }
    [self.mainCollection reloadData];
}

#pragma mark - inside method
/*!
 * 根据设备的类型返回
 */
- (CellImvType)getUICellTypeWithDevType:(int)type{

    switch (type) {
        case 6:
            return CellImvType_WC;
            break;
        case 7:
            return CellImvType_Bar;
            break;
        case 8:
            return CellImvType_Bed;
            break;
        case 9:
            return CellImvType_Baby;
            break;

        default:
            return CellImvType_Car;
            break;
    }
}

@end
