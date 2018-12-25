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
#import "DetailInfoController+Extension.h"
#import "DetailInfoController+DetailInfoBG.h"
#import "DetailInfoController+DetailInfoUI.h"
#import "DetailInfoController+DetailInfo.h"

#import "FMDB_DeviceInfo.h"
#import "MyPeripheral.h"

@interface DetailInfoController ()
<DetailTypeChooseViewDelegate,
DetailChooseSegmentDelegate>


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
        MyPeripheral * device = self.deviceInfo;
//        NSLog(@"%@",device.peripheral.name);
        self.topView.labTitle.text = device.peripheral.name ? device.peripheral.name : @"(null)";
        self.topView.isBle = true;
    } else if ([self.deviceInfo isKindOfClass:[DeviceInfo class]]){
        DeviceInfo * device = self.deviceInfo;
//        NSLog(@"%@",device.showName);
        self.topView.labTitle.text = device.showName;
        self.topView.isWifi = true;
        
        float temp = [device temeratureBySData];
        NSString * tpstr = temp == -1000 ? @"--" : [NSString stringWithFormat:@"%.1f˚C",[device temeratureBySData]];
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
    }
    
    [self selectInternetInfo];

    return ;

    if (self.curDevInfo) {

        [self setLocalInfo];

        [self setDeviceInfo];

        if (self.curDevInfo.isBle) {

            //查询蓝牙数据
            [self selecetBLEDevData];
            //请求查询蓝牙历史数据
            [self selecetHistoryDataIsStart:true];
            //监听蓝牙返回数据
            [self notifyValueForCharacteristic];
        }

        if (!self.curDevInfo.isWifi) {
            [self linkDev];
        }
    }

    [self startTimer];
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


#pragma mark ----- lazy load
- (DetailMainScroll *)mainScroll{
    if (_mainScroll == nil) {
        _mainScroll = [[DetailMainScroll alloc]init];
        _mainScroll.typeView.delegate = self;
        _mainScroll.chooseSeg.delegate = self;
        _mainScroll.chooseSeg.btn5.hidden = true;
        [self.view addSubview:_mainScroll];
    }
    return _mainScroll;
}

- (DetailEditAlert *)editAlert{
    if (_editAlert == nil) {
        _editAlert = [[DetailEditAlert alloc]init];
        [_editAlert.btnSave addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
        [_editAlert.btnCancel addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
        _editAlert.tfName.text = self.curDevInfo.nickName?self.curDevInfo.nickName:self.curDevInfo.bleInfo.peripheral.name;
        _editAlert.type = [self getEditAlertTypeWithDType:self.curDevInfo.motostep];
        [self.view insertSubview:_editAlert aboveSubview:self.mainScroll];
    }
    return _editAlert;
}

- (dispatch_source_t)historyTimer{
    if (_historyTimer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        _historyTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_historyTimer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_historyTimer, ^{
            [self readLocalHistory];
        });
        dispatch_resume(_historyTimer);
    }
    return _historyTimer;
}

- (dispatch_source_t)selectTimer{
    if (_selectTimer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        _selectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_selectTimer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_selectTimer, ^{
            [self selecetBLEDevData];
        });
        dispatch_resume(_selectTimer);
    }
    return _selectTimer;
}



#pragma mark - events
- (void)clickEditButton:(UIButton_DIYObject *)sender{
    [self.editAlert dismiss];
    //Save
    if (sender.tag == 20)
    {
        [self setDevName];
        [self setDevType];
        [self setDevIsAlert];
        [self setDevLimitValue];
    }
    //Cancel
    else if (sender.tag == 21)
    {

    }
}

#pragma mark ----- <DetailTypeChooseViewDelegate>
- (void)typeChooseView:(DetailTypeChooseView *)chooseView ChooseType:(int)type{
    self.mainScroll.tempView.hidden = !(type==0);
    self.mainScroll.humiView.hidden = !(type==1);
    self.mainScroll.warnView.hidden = !(type==2);
}

#pragma mark ----- <DetailChooseSegmentDelegate>
- (void)segmentView:(DetailChooseSegment *)segment chooseLR:(bool)isLeft{

//    LRLog(@"%@",self.histories);
    
    switch (segment.type) {
        case 0://按小时显示
        {
            switch (self.mainScroll.typeView.type) {
                case 0://温度
                {
                    [self refershHourTempLineView:isLeft];
                    [self refershHistoryUI];
                }
                    break;
                case 1://湿度
                {
                    [self refershHourHumiLineView:isLeft];
                    [self refershHistoryUI];
                }
                    break;
                case 2://报警
                {
                    [self refershWarnUI];
                }
                    break;

                default:
                    break;
            }

            
        }
            break;
        case 1://按天显示
        {
            switch (self.mainScroll.typeView.type) {
                case 0:
                {
                    [self refershDayTempLineView:isLeft];
                }
                    break;
                case 1:
                {
                    [self refershDayHumiLineView:isLeft];
                }
                    break;
                case 2://报警
                {
                    [self refershWarnUI];
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 2://周
        {
            switch (self.mainScroll.typeView.type) {
                case 0:
                {
                    [self refershWeekTempLineView:isLeft];
                }
                    break;
                case 1:
                {
                    [self refershWeekHumiLineView:isLeft];
                }
                    break;
                case 2://报警
                {
                    [self refershWarnUI];
                }
                    break;

                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
}

- (void)segmentView:(DetailChooseSegment *)segment chooseIndex:(NSInteger)index{

    segment.date = [NSDate zoneDate];
    NSDate *nowDate = segment.date;

    switch (self.mainScroll.chooseSeg.type) {
        case 0:
            self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%02d:00--%02d:00",[nowDate hourWithNumber:-1],[nowDate hour]];
            break;
        case 1:
            self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d",[NSString englishMonth:[nowDate month] IsAb:true],[nowDate day],[nowDate year]];
            break;
        case 2:
        {
            NSDate *lastWkDate = [nowDate dateWithDays:-7];
            self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d - %@ %02d %d",[NSString englishMonth:[lastWkDate month] IsAb:true],[lastWkDate day],[lastWkDate year],[NSString englishMonth:[nowDate month] IsAb:true],[nowDate day],[nowDate year]];
        }
            break;

        default:
            break;
    }
    [self.mainScroll.chooseSeg.labCenter sizeToFit];
}

#pragma mark - inside method

- (int)getEditAlertTypeWithDType:(int)dtype{

    switch (dtype) {
        case 6:
            return 0;
            break;
        case 7:
            return 1;
            break;
        case 8:
            return 2;
            break;
        case 9:
            return 3;
            break;

        default:
            return 0;
            break;
    }
}

@end
