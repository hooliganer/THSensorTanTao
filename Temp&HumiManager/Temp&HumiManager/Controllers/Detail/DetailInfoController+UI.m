//
//  DetailInfoController+UI.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/13.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController+UI.h"
#import "DetailInfoController+BG.h"
#import "DetailInfoController+BGBLE.h"
#import "ShareFileManager.h"

@implementation DetailInfoController (UI)

- (void)showIsWaner:(bool)is{
    self.warner.size = is ? CGSizeMake(self.bgScroll.width - 40, 50) : CGSizeZero;
    [self.view setNeedsLayout];
}

- (int)motostepByType:(int)type{
    switch (type) {
        case 0:
            return 6;
            break;
        case 1:
            return 8;
            break;
        case 2:
            return 7;
            break;
        case 3:
            return 9;
            break;
            
        default:
            return 6;
            break;
    }
}

- (int)typeByMotostep:(int)moto{
    switch (moto) {
        case 6:
            return 0;
            break;
        case 7:
            return 2;
            break;
        case 8:
            return 1;
            break;
        case 9:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
}

- (void)setupSubviews{

    self.view.backgroundColor = MainColor;

    self.navigationBar.title = @"SENSOR";

    LRWeakSelf(self);
    [self.navigationBar addActionRightImage:[UIImage imageNamed:@"ic_edit"] Block:^{
        if (weakself.editer.hidden) {
            [weakself.editer show];
        } else{
            [weakself.editer dismiss];
        }
    }];
    [self.navigationBar showBackButton:^{
        [weakself.navigationController popViewControllerAnimated:true];
    }];

    self.bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationBar.height, MainScreenWidth, MainScreenHeight - self.navigationBar.height)];
    [self.view addSubview:self.bgScroll];
    [self setupScrollSubviews];
}

- (void)setupScrollSubviews{

    self.warner = [[DetailWarningAlert alloc]initWithFrame:CGRectMake(20, 10, 0, 0)];
    [self.bgScroll addSubview:self.warner];
    [self.warner addTarget:self action:@selector(clickWarner) forControlEvents:UIControlEventTouchUpInside];

    self.topView = [[DetailCellView alloc]initWithFrame:CGRectMake(20, 10, self.bgScroll.width - 40, 120)];
    [self.bgScroll addSubview:self.topView];
    self.topView.imvHead.image = [UIImage imageNamed:@"ic_room_car"];

    self.btmView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, self.bgScroll.width - 40, 420)];
    self.btmView.layer.masksToBounds = true;
    self.btmView.layer.cornerRadius = 10;
    self.btmView.backgroundColor = [UIColor whiteColor];
    [self.bgScroll addSubview:self.btmView];

    [self setupBtmSubviews];

    self.exportBtn = [UIButton_DIYObject buttonWithType:UIButtonTypeSystem];
    self.exportBtn.frame = CGRectMake(20, 10, self.bgScroll.width - 40, 40);
    [self.exportBtn setTitle:@"SHARE"];
    self.exportBtn.labTitle.textColor = [UIColor whiteColor];
    self.exportBtn.backgroundColor = [UIColor colorWithRed:78/255.0 green:200/255.0 blue:94/255.0 alpha:1];
    self.exportBtn.layer.masksToBounds = true;
    self.exportBtn.layer.cornerRadius = Fit_Y(8.0);
    [self.bgScroll addSubview:self.exportBtn];
    [self.exportBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.editer = [[DetailEditAlert alloc]init];
    self.editer.switcher.isOn = true;
    [self.editer.btnSave addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.editer.btnCancel addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    self.editer.tfName.text = self.curDevInfo.nickName?self.curDevInfo.nickName:self.curDevInfo.bleInfo.peripheral.name;
    [self.view insertSubview:self.editer aboveSubview:self.bgScroll];

    
}

- (void)setupBtmSubviews{

    self.segmentView = [[DetailChooseSegment alloc]initWithFrame:CGRectMake(0, 0, self.btmView.width, self.btmView.height * 0.2)];
    self.segmentView.backgroundColor = [UIColor colorWithRed:20/255.0 green:104/255.0 blue:127/255.0 alpha:1];
    [self.btmView addSubview:self.segmentView];
    NSString * timeStr = [NSString stringWithFormat:@"%02d:00--%02d:00",[[NSDate nowDateWithSecond:-3600] nHour],[NSDate currentHour]];
    self.segmentView.labCenter.text = timeStr;
    [self.segmentView.labCenter sizeToFit];
    self.segmentView.delegate = self;
    self.segmentView.date = [NSDate date];

    self.typeView = [[DetailTypeChooseView alloc]initWithFrame:CGRectMake(0, self.segmentView.bottomY + 5, self.btmView.width, self.btmView.height * 0.1)];
    self.typeView.delegate = self;
    [self.btmView addSubview:self.typeView];

    self.temperatureView = [[DetailTempView alloc]initWithFrame:CGRectMake(20, self.btmView.height * 0.3 + 10, self.btmView.width - 40, self.btmView.height * 0.7 - 10)];
    [self.btmView addSubview:self.temperatureView];

    self.humidityView = [[DetailHumidityView alloc]initWithFrame:CGRectMake(20, self.btmView.height * 0.3 + 10, self.btmView.width - 40, self.btmView.height * 0.7 - 10)];
    self.humidityView.hidden = true;
    [self.btmView addSubview:self.humidityView];

    self.warnView = [[DetailWarningView alloc]initWithFrame:CGRectMake(20, self.btmView.height * 0.3 +10, self.btmView.width - 40, self.btmView.height * 0.7 - 10)];
    self.warnView.hidden = true;
    [self.btmView addSubview:self.warnView];

}

#pragma mark - 事件
/**
 点击编辑view里的按钮

 @param sender 按钮
 */
- (void)clickEditButton:(UIButton *)sender{
    
    [self.editer dismiss];
    //Save
    if (sender.tag == 20){
        //网络
        if (self.devType == 0) {
            [self setInternetDevName];
            [self setInternetDevType];
            [self setInternetWarnSet];
        }
        //蓝牙
        else if (self.devType == 1){
            [self saveLocalInfo];
//            [self saveLocalWarnSetRecord];
        }
        
        
//        [self setDevName];
//        [self setDevType];
//        [self setDevIsAlert];
//        [self setDevLimitValue];
    }
}

- (void)clickWarner{
    self.warner.size = CGSizeZero;
    [self.view setNeedsLayout];
}

- (void)clickShare:(UIButton *)sender{
    
    if (self.currentDatas.count == 0) {
        [My_AlertView showInfo:@"There is no records to share !" Block:nil];
        return ;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"Choose a format" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString * time = self.segmentView.labCenter.text;
    NSMutableString * mstr = [[NSMutableString alloc]init];
    for (int i = 0;i<self.currentDatas.count;i++) {
        DeviceInfo *dd = self.currentDatas[i];
        [mstr appendFormat:@"%d %.1f˚C %d%% %@ \n",i,dd.temeratureBySData,dd.humidityBySData,time];
    }
    
    NSString * name = [NSString stringWithFormat:@"History %@",self.segmentView.labCenter.text];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"CSV" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ShareFileManager shared] shareCSVName:name Substance:mstr InController:self];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"TXT" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ShareFileManager shared] shareTXTName:name Substance:mstr InController:self];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - Delegate

- (void)typeChooseView:(DetailTypeChooseView *)chooseView ChooseType:(int)type{
    
    self.temperatureView.hidden = !(type == 0);
    self.humidityView.hidden = !(type == 1);
    self.warnView.hidden = !(type == 2);
    
    if (self.devType == 0) {
        switch (type) {
            case 1:
            {
                [self selectInternetHumidity];
            }
                break;
            case 2:
                [self selectInternetWarnRecord];
                break;
                
            default:
                [self selectInternetTemparature];
                break;
        }
    } else if (self.devType == 1){
        switch (type) {
            case 1:
            {
                [self readLocalHumidityRecord];
            }
                break;
            case 2:
                break;
                
            default:
            {
                [self readLocalTemparatureRecord];
            }
                break;
        }
    }
    
}

- (void)segmentView:(DetailChooseSegment *)segment chooseLR:(bool)isLeft{
    
    NSDate * oldDate = segment.date;
    NSDate * newDate;
    switch (segment.type) {
        case 1://day
        {
            newDate = [oldDate dateWithDays:isLeft?-1:1];
        }
            break;
        case 2://week
        {
            newDate = [oldDate dateWithDays:isLeft?-7:7];
        }
            break;
            
        default://hour
        {
            newDate = [oldDate dateWithSeconds:isLeft?-3600:3600];
        }
            break;
    }
    if (!isLeft) {
        NSTimeInterval newInterval = [newDate timeIntervalSince1970];
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        if (newInterval > nowInterval) {
            return ;
        }
    }
    segment.date = newDate;
    
//    [self selectInternetHistoryRecord];
    
    if (self.devType == 0) {
        switch (self.typeView.type) {
            case 1:
            {
                [self selectInternetHumidity];
            }
                break;
            case 2:
            {
                [self selectInternetWarnRecord];
            }
                break;
                
            default:
            {
                [self selectInternetTemparature];
            }
                break;
        }
    } else if (self.devType == 1){
        switch (self.typeView.type) {
            case 1:
            {
                [self readLocalHumidityRecord];
            }
                break;
            case 2:
            {

            }
                break;
                
            default:
            {
                [self readLocalTemparatureRecord];
            }
                break;
        }
        
    }
    
}

- (void)segmentView:(DetailChooseSegment *)segment chooseIndex:(NSInteger)index{
    
    if (self.devType == 0) {
        switch (self.typeView.type) {
            case 1:
            {
                [self selectInternetHumidity];
            }
                break;
            case 2:
            {
                [self selectInternetWarnRecord];
            }
                break;
                
            default:
            {
                [self selectInternetTemparature];
            }
                break;
        }
    } else if (self.devType == 1){
        switch (self.typeView.type) {
            case 1:
            {
                [self readLocalHumidityRecord];
            }
                break;
            case 2:
            {

            }
                break;
                
            default:
            {
                [self readLocalTemparatureRecord];
            }
                break;
        }
    }
}

@end
