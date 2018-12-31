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

#import "BLEManager.h"


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
        
        self.devType = 1;
        [self handleBluetoothDeviceInfo];
        
    } else if ([self.deviceInfo isKindOfClass:[DeviceInfo class]]){
        self.devType = 0;
        [self handleInterDeviceInfo];
        [self startBLE];

    } else if ([self.deviceInfo isKindOfClass:[NSDictionary class]]){
        self.devType = 3;
        [self handleDictionaryDeviceInfo];
        [self startBLE];
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if (self.devType == 1) {
        MyPeripheral * peri = (MyPeripheral *)self.deviceInfo;
        [[BLEManager shareInstance] cancelConnectCBPeripheral:peri.peripheral];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];


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
    
    [self readLocalTemparatureRecord];
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
    
    //查网络基本信息
    [self selectInternetInfo];
    

    //查询网络温湿度数据
    LRWeakSelf(self);
    [self selectInternetTHData:^(NSArray<DeviceInfo *> *datas) {
        
        weakself.currentDatas = datas.mutableCopy;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            float max = [[datas valueForKeyPath:@"@max.temeratureBySData"] floatValue];
            float min = [[datas valueForKeyPath:@"@min.temeratureBySData"] floatValue];
            float avg = [[datas valueForKeyPath:@"@avg.temeratureBySData"] floatValue];
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
            [weakself.temperatureView.liner reDrawWithX:10 Y:10 Values:tps];
            
            NSString * unit = [MyDefaultManager unit];
            NSString * last = [NSString stringWithFormat:@"%.1f%@",datas.firstObject.temeratureBySData,unit]
            ;
            NSString * high = [NSString stringWithFormat:@"%.1f%@",max,unit]
            ;
            NSString * low = [NSString stringWithFormat:@"%.1f%@",min,unit]
            ;
            NSString * avgstr = [NSString stringWithFormat:@"%.1f%@",avg,unit]
            ;
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:datas.firstObject.utime];
            NSString * time1 = [NSString stringWithFormat:@"%02d/%02d/%d",[date nDay],[date nMonth],[date nYear]];
            NSString * time2 = [NSString stringWithFormat:@"%02d:%02d:%02d",[date nHour],[date nMinute],[date nSecond]];
            
            [weakself.temperatureView.tempInfoView setHigh:high Low:low Avg:avgstr Last:last Time1:time1 Time2:time2];
        });
    }];
    
    [self selectCurrentInternetTHData];
}

- (void)handleDictionaryDeviceInfo{
    [self readLocalInfo];
}

@end
