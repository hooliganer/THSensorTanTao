//
//  DetailInfoController+UI.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/13.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController+UI.h"


@implementation DetailInfoController (UI)

- (void)setupSubviews{

    self.view.backgroundColor = MainColor;

    self.navigationBar.title = @"SENSOR";

    LRWeakSelf(self);
    [self.navigationBar addActionRightImage:[UIImage imageNamed:@"ic_edit"] Block:^{
//        if (weakself.editAlert.hidden) {
//            [weakself.editAlert show];
//        } else{
//            [weakself.editAlert dismiss];
//        }
    }];
    [self.navigationBar showBackButton:^{
        [weakself.navigationController popViewControllerAnimated:true];
    }];

    self.bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationBar.height, MainScreenWidth, MainScreenHeight - self.navigationBar.height)];
    [self.view addSubview:self.bgScroll];
    [self setupScrollSubviews];
}

- (void)setupScrollSubviews{

    self.warner = [[DetailWarningAlert alloc]initWithFrame:CGRectMake(20, 10, self.bgScroll.width - 40, 50)];
    [self.bgScroll addSubview:self.warner];

    self.topView = [[DetailCellView alloc]initWithFrame:CGRectMake(20, 10, self.bgScroll.width - 40, 120)];
    [self.bgScroll addSubview:self.topView];
    self.topView.imvHead.image = [UIImage imageNamed:@"ic_room_car"];

    self.btmView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, self.bgScroll.width - 40, 420)];
    self.btmView.layer.masksToBounds = true;
    self.btmView.layer.cornerRadius = 10;
    self.btmView.backgroundColor = [UIColor whiteColor];
    [self.bgScroll addSubview:self.btmView];

    [self setupBtmSubviews];

    self.exportBtn = [[UIButton_DIYObject alloc]initWithFrame:CGRectMake(20, 10, self.bgScroll.width - 40, 40)];
    [self.exportBtn setTitle:@"SHARE"];
    self.exportBtn.labTitle.textColor = [UIColor whiteColor];
    self.exportBtn.backgroundColor = [UIColor colorWithRed:78/255.0 green:200/255.0 blue:94/255.0 alpha:1];
    self.exportBtn.layer.masksToBounds = true;
    self.exportBtn.layer.cornerRadius = Fit_Y(8.0);
    [self.bgScroll addSubview:self.exportBtn];
    
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

    self.typeView = [[DetailTypeChooseView alloc]initWithFrame:CGRectMake(0, self.segmentView.bottomY, self.btmView.width, self.btmView.height * 0.1)];
    self.typeView.delegate = self;
    [self.btmView addSubview:self.typeView];

    self.temperatureView = [[DetailTempView alloc]initWithFrame:CGRectMake(0, self.btmView.height * 0.3, self.btmView.width, self.btmView.height * 0.7)];
    [self.btmView addSubview:self.temperatureView];

    self.humidityView = [[DetailHumidityView alloc]initWithFrame:CGRectMake(0, self.btmView.height * 0.3, self.btmView.width, self.btmView.height * 0.7)];
    self.humidityView.hidden = true;
    [self.btmView addSubview:self.humidityView];

    self.warnView = [[DetailWarningView alloc]initWithFrame:CGRectMake(0, self.btmView.height * 0.3, self.btmView.width, self.btmView.height * 0.7)];
    self.warnView.hidden = true;
    [self.btmView addSubview:self.warnView];

}

#pragma mark - 事件


#pragma mark - Delegate

- (void)typeChooseView:(DetailTypeChooseView *)chooseView ChooseType:(int)type{
    self.temperatureView.hidden = !(type == 0);
    self.humidityView.hidden = !(type == 1);
    self.warnView.hidden = !(type == 2);
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
}

- (void)segmentView:(DetailChooseSegment *)segment chooseIndex:(NSInteger)index{
    
}

@end
