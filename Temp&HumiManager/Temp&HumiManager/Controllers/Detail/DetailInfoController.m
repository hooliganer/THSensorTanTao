//
//  DetailInfoController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"
#import "DetailInfoController+UI.h"
#import "DetailInfoController+BG.h"
#import "DetailInfoController+BGBLE.h"
#import "DetailInfoController+Extension.h"
#import "DetailInfoController+DetailInfoBG.h"
#import "DetailInfoController+DetailInfoUI.h"
#import "DetailInfoController+DetailInfo.h"

#import "FMDB_DeviceInfo.h"
#import "MyPeripheral.h"

@interface DetailInfoController ()


@end

@implementation DetailInfoController

#pragma amrk ----- override method
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"\nDetailInfoController didReceiveMemoryWarning\n");
}

- (void)dealloc{
    NSLog(@"\nDetailInfoController dealloc\n");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self.deviceInfo isKindOfClass:[MyPeripheral class]]) {
        
        self.devType = 0;
        [self handleInterDeviceInfo];
        
    } else if ([self.deviceInfo isKindOfClass:[DeviceInfo class]]){
        self.devType = 1;
        [self handleInterDeviceInfo];

    } else if ([self.deviceInfo isKindOfClass:[NSDictionary class]]){
        self.devType = 1;
        [self handleDictionaryDeviceInfo];
        [self startBLE];
    }
    

    return ;

//    if (self.curDevInfo) {
//
//        [self setLocalInfo];
//
//        [self setDeviceInfo];
//
//        if (self.curDevInfo.isBle) {
//
//            //查询蓝牙数据
//            [self selecetBLEDevData];
//            //请求查询蓝牙历史数据
//            [self selecetHistoryDataIsStart:true];
//            //监听蓝牙返回数据
//            [self notifyValueForCharacteristic];
//        }
//
//        if (!self.curDevInfo.isWifi) {
//            [self linkDev];
//        }
//    }
//
//    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if (self.curDevInfo.bleInfo.peripheral) {

        //停止历史数据请求
        [self selecetHistoryDataIsStart:false];
        async_bgqueue(^{
            BLEManager *manager = [BLEManager shareInstance];
            [manager disConnectCBPeripheral:self.curDevInfo.bleInfo.peripheral];
        });
    }

    if (self.selectTimer) {
        dispatch_source_cancel(self.selectTimer);
        self.selectTimer = nil;
    }

    if (self.historyTimer) {
        self.historyTimer = nil;
        dispatch_source_cancel(self.historyTimer);
    }

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

//    self.mainScroll.frame = CGRectMake(0, 64.0, MainScreenWidth, MainScreenHeight - 64.0);

    self.topView.y = self.warner.bottomY + 10;

    self.btmView.y = self.topView.bottomY + 10;

    self.exportBtn.y = self.btmView.bottomY + 10;

    self.bgScroll.contentHeight = self.exportBtn.bottomY + 10;

}






#pragma mark - inside method

/**
 处理蓝牙设备信息
 */
- (void)handleBluetoothDeviceInfo{
    MyPeripheral * device = self.deviceInfo;
    self.topView.labTitle.text = device.peripheral.name ? device.peripheral.name : @"(null)";
    self.topView.isBle = true;
    [self readLocalInfo];
}

- (void)handleDictionaryDeviceInfo{
    [self readLocalInfo];
}

/**
 处理网络设备信息
 */
- (void)handleInterDeviceInfo{
    
    DeviceInfo * device = self.deviceInfo;
    //        NSLog(@"%@",device.showName);
    self.topView.labTitle.text = device.showName;
    self.topView.isWifi = true;
    self.topView.imvHead.image = [UIImage imageNamed:[device imageNameWithMototype]];
    
    self.editer.tfName.text = device.showName;
    self.editer.type = [self typeByMotostep:device.motostep];
    self.editer.limitTemp.labUnit.text = [MyDefaultManager unit];
    
    float temp = [device temeratureBySData];
    NSString * tpstr = temp == -1000 ? @"--" : [NSString stringWithFormat:@"%.1f%@",[device temeratureBySData],[MyDefaultManager unit]];
    self.topView.labTempar.text = tpstr;
    [self.topView.labTempar sizeToFit];
    
    int humi = [device humidityBySData];
    NSString * hmstr = humi == -1000 ? @"--" : [NSString stringWithFormat:@"%d%%",[device humidityBySData]];
    self.topView.labHumi.text = hmstr;
    [self.topView.labHumi sizeToFit];
    
    int power = [device powerBySData];
    NSString * pwstr = power == -1000 ? @"--" : [NSString stringWithFormat:@"%d%%",[device powerBySData]];
    self.topView.labPower.text = pwstr;
    [self.topView.labPower sizeToFit];
    
    [self selectInternetInfo];
}

@end
