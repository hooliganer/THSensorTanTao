//
//  DetailInfoController+DetailInfoUI.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController+DetailInfoUI.h"
#import "DetailInfoController+DetailInfo.h"
#import "DetailInfoController+DetailInfoBG.h"

@implementation DetailInfoController (DetailInfoUI)

/*!
 * 根据设备的信息，初始化一些UI信息
 */
- (void)setDeviceInfo{

    NSString *unit = [self currentTemperUnit];

    self.mainScroll.cellView.type = [self getUICellTypeWithDevType:self.curDevInfo.motostep];
    self.mainScroll.cellView.labTitle.text = self.curDevInfo.nickName?self.curDevInfo.nickName:self.curDevInfo.bleInfo.peripheral.name;
    self.mainScroll.cellView.isBle = self.curDevInfo.isBle;
    self.mainScroll.cellView.isWifi = self.curDevInfo.isWifi;

    //判断当前设备是什么数据为主
    switch ([self.curDevInfo hasData]) {
        case MCODataType_None:
        {
            self.mainScroll.cellView.labPower.text = @"--";
            self.mainScroll.cellView.labTempar.text = @"--";
            self.mainScroll.cellView.labHumi.text = @"--";
        }
            break;
        case MCODataType_Ble:
        {
            self.mainScroll.cellView.labPower.text = [NSString stringWithFormat:@"%d%%",self.curDevInfo.powerBle];
            self.mainScroll.cellView.labTempar.text = [NSString stringWithFormat:@"%.1f%@",self.curDevInfo.temperatureBle,self.curDevInfo.tempUnit];
            self.mainScroll.cellView.labHumi.text = [NSString stringWithFormat:@"%d%%",self.curDevInfo.humidityBle];
        }
            break;
        case MCODataType_Wifi:
        {
            self.mainScroll.cellView.labPower.text = [NSString stringWithFormat:@"%d%%",self.curDevInfo.powerWifi];
            self.mainScroll.cellView.labTempar.text = [NSString stringWithFormat:@"%.1f%@",self.curDevInfo.temperatureWifi,self.curDevInfo.tempUnit];
            self.mainScroll.cellView.labHumi.text = [NSString stringWithFormat:@"%d%%",self.curDevInfo.humidityWifi];
        }
            break;

        default:
            break;
    }

    [self.mainScroll.cellView.labPower sizeToFit];
    [self.mainScroll.cellView.labTempar sizeToFit];
    [self.mainScroll.cellView.labHumi sizeToFit];

    self.mainScroll.cellView.humiWarning = self.curDevInfo.humiWarning;
    self.mainScroll.warnAlert.labTemp.text = [NSString stringWithFormat:@"--%@",unit];
    [self.mainScroll.warnAlert.labTemp sizeToFit];

    self.mainScroll.chooseSeg.date = [NSDate zoneDate];
    NSDate *nowDate = self.mainScroll.chooseSeg.date;
    switch (self.mainScroll.chooseSeg.type) {
        case 0:
            self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%02d:00--%02d:00",[nowDate hourWithNumber:-1],[nowDate hour]];
            break;
        case 1:
            self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%02d %02d %d",[nowDate month],[nowDate day],[nowDate year]];
            break;

        default:
            break;
    }
    [self.mainScroll.chooseSeg.labCenter sizeToFit];
}

/*!
 * 刷新历史记录view(当前小时、温度类型)
 */
- (void)refershHourTempLineView:(bool)isLeft{

    //获取要显示的新时间
    NSDate * date = [self getDateWithIsLeft:isLeft Interval:3600];

    //显示方向按钮与否
    [self refershDirectionBtnWithDate:date];

    //刷新中间时间文本
    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%02d:00--%02d:00",[date hourWithNumber:-1],[date hour]];
    [self.mainScroll.chooseSeg.labCenter sizeToFit];

    //重新赋予时间
    self.mainScroll.chooseSeg.date = date;

    //把数据源按时间戳升序排序
    NSArray <FMDB_HitoryRecord *>* newHis = [self sortTimeAscendHistories:self.histories];

    //得到整点的时间
    NSDate * intDate = [self.mainScroll.chooseSeg.date intByHour];

    //两个时间端点的时间戳
    NSTimeInterval nextInterval = [intDate timeIntervalSince1970];
    NSTimeInterval lastInterval = nextInterval - 3600;

//    int min = [[NSDate dateWithTimeIntervalSince1970:nextInterval] minute];
//    int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval] hour];
//    int min1 = [[NSDate dateWithTimeIntervalSince1970:lastInterval] minute];
//    int hour1 = [[NSDate dateWithTimeIntervalSince1970:lastInterval] hour];
//    NSLog(@"%02d:%02d - %02d:%02d",hour,min,hour1,min1);

    //筛选获取在两端整点时间内的数据
    NSMutableArray <FMDB_HitoryRecord *>* theHis = [NSMutableArray array];
    //遍历筛选添加
    for (int i=0; i<newHis.count; i++) {
        FMDB_HitoryRecord *history = [newHis objectAtIndex:i];
        if ((history.dateInterval >= lastInterval) && (history.dateInterval <= nextInterval)) {
            [theHis addObject:history];
        }
    }

    //如果没有数据，则置为nil信息，并不往下执行
    if (theHis.count == 0) {
        [self.mainScroll.tempView.lineView cleanAll];
        return ;
    }

    //时间区间内的温度数据集、时间戳集
    NSMutableArray *temps = [NSMutableArray array];
    NSMutableArray *xPers = [NSMutableArray array];

    //整个时间端点内的时间戳长度
    NSTimeInterval allTime = nextInterval - lastInterval;

    //遍历对应的数据源，生成温度、横坐标百分比的数据源
    for (int i=0; i<theHis.count; i++) {
        FMDB_HitoryRecord * history = [theHis objectAtIndex:i];
        [temps addObject:@(history.temperature)];
        float perc = (history.dateInterval - lastInterval)/allTime;
        [xPers addObject:@(perc)];
    }

    //每个单元格的时间长度
    NSTimeInterval unitTime = 3600/floor(self.mainScroll.tempView
                                            .lineView.xCount);
    //获取横坐标的显示值
    NSMutableArray <NSString *>* xValues = [NSMutableArray array];
    //根据横坐标格数生成相应数量的数据
    for (int i=0; i<=self.mainScroll.tempView
         .lineView.xCount; i++) {
        int minute = [[NSDate dateWithTimeIntervalSince1970:nextInterval+i*unitTime] minute];
        int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval+i*unitTime] hour];
        [xValues addObject:[NSString stringWithFormat:@"%02d:%02d",hour,minute]];
    }

    //根据数据进行刷新
    self.mainScroll.tempView.lineView.values = temps;
    self.mainScroll.tempView.lineView.xValues = xValues;
    self.mainScroll.tempView.lineView.xPers = xPers;
    [self.mainScroll.tempView.lineView setNeedsDisplay];

}

/*!
 * 刷新历史记录view(当前天、湿度类型)
 */
- (void)refershDayTempLineView:(bool)isLeft{

    //获取要显示的新时间
    NSDate * date = [self getDateWithIsLeft:isLeft Interval:3600*24];

    //显示方向按钮与否
    [self refershDirectionBtnWithDate:date];

    NSString *monStr = [NSString englishMonth:[date month] IsAb:true];
    //刷新中间时间文本
    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d",monStr,[date day],[date year]];
    [self.mainScroll.chooseSeg.labCenter sizeToFit];

    //重新赋予时间
    self.mainScroll.chooseSeg.date = date;

    //把数据源按时间戳升序排序
    NSArray <FMDB_HitoryRecord *>* newHis = [self sortTimeAscendHistories:self.histories];

    //得到整天的时间
    NSDate * intDate = [self.mainScroll.chooseSeg.date intByDay];

    //两个时间端点的时间戳
    NSTimeInterval nextInterval = [intDate timeIntervalSince1970];
    NSTimeInterval lastInterval = nextInterval - 3600*24;

    //    int min = [[NSDate dateWithTimeIntervalSince1970:nextInterval] minute];
    //    int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval] hour];
    //    int min1 = [[NSDate dateWithTimeIntervalSince1970:lastInterval] minute];
    //    int hour1 = [[NSDate dateWithTimeIntervalSince1970:lastInterval] hour];
    //    NSLog(@"%02d:%02d - %02d:%02d",hour,min,hour1,min1);

    //筛选获取在两端整点时间内的数据
    NSMutableArray <FMDB_HitoryRecord *>* theHis = [NSMutableArray array];
    //遍历筛选添加
    for (int i=0; i<newHis.count; i++) {
        FMDB_HitoryRecord *history = [newHis objectAtIndex:i];
        if ((history.dateInterval >= lastInterval) && (history.dateInterval <= nextInterval)) {
            [theHis addObject:history];
        }
    }

    //如果没有数据，则置为nil信息，并不往下执行
    if (theHis.count == 0) {
        [self.mainScroll.tempView.lineView cleanAll];
        return ;
    }

    //时间区间内的温度数据集、时间戳集
    NSMutableArray *temps = [NSMutableArray array];
    NSMutableArray *xPers = [NSMutableArray array];

    //整个时间端点内的时间戳长度
    NSTimeInterval allTime = nextInterval - lastInterval;

    //遍历对应的数据源，生成温度、横坐标百分比的数据源
    for (int i=0; i<theHis.count; i++) {
        FMDB_HitoryRecord * history = [theHis objectAtIndex:i];
        [temps addObject:@(history.temperature)];
        float perc = (history.dateInterval - lastInterval)/allTime;
        [xPers addObject:@(perc)];
    }

    //每个单元格的时间长度
    NSTimeInterval unitTime = 3600*24/floor(self.mainScroll.tempView
                                         .lineView.xCount);
    //获取横坐标的显示值
    NSMutableArray <NSString *>* xValues = [NSMutableArray array];
    //根据横坐标格数生成相应数量的数据
    for (int i=0; i<=self.mainScroll.tempView
         .lineView.xCount; i++) {
        int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval+i*unitTime] hour];
        [xValues addObject:[NSString stringWithFormat:@"%02d:00",hour]];
    }

    //根据数据进行刷新
    self.mainScroll.tempView.lineView.values = temps;
    self.mainScroll.tempView.lineView.xValues = xValues;
    self.mainScroll.tempView.lineView.xPers = xPers;
    [self.mainScroll.tempView.lineView setNeedsDisplay];

}

/*!
 * 刷新历史记录view(当前周、湿度类型)
 */
- (void)refershWeekTempLineView:(bool)isLeft{

    //获取要显示的新时间
    NSDate * date = [self getDateWithIsLeft:isLeft Interval:3600*24*7];
    NSDate * date1 = [date dateWithDays:-7];

    //显示方向按钮与否
    [self refershDirectionBtnWithDate:date];

    NSString * monStr = [NSString englishMonth:[date month] IsAb:true];
    NSString * monStr1 = [NSString englishMonth:[date1 month] IsAb:true];
    //刷新中间时间文本
    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d - %@ %02d %d",monStr1,[date1 day],[date1 year],monStr,[date day],[date year]];
    [self.mainScroll.chooseSeg.labCenter sizeToFit];

    //重新赋予时间
    self.mainScroll.chooseSeg.date = date;

    //把数据源按时间戳升序排序
    NSArray <FMDB_HitoryRecord *>* newHis = [self sortTimeAscendHistories:self.histories];

//    //得到整天的时间
//    NSDate * intDate = [self.mainScroll.chooseSeg.date intByDay];

    //两个时间端点的时间戳
    NSTimeInterval nextInterval = [date timeIntervalSince1970];
    NSTimeInterval lastInterval = [date1 timeIntervalSince1970];

    //    int min = [[NSDate dateWithTimeIntervalSince1970:nextInterval] minute];
    //    int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval] hour];
    //    int min1 = [[NSDate dateWithTimeIntervalSince1970:lastInterval] minute];
    //    int hour1 = [[NSDate dateWithTimeIntervalSince1970:lastInterval] hour];
    //    NSLog(@"%02d:%02d - %02d:%02d",hour,min,hour1,min1);

    //筛选获取在两端整点时间内的数据
    NSMutableArray <FMDB_HitoryRecord *>* theHis = [NSMutableArray array];
    //遍历筛选添加
    for (int i=0; i<newHis.count; i++) {
        FMDB_HitoryRecord *history = [newHis objectAtIndex:i];
        if ((history.dateInterval >= lastInterval) && (history.dateInterval <= nextInterval)) {
            [theHis addObject:history];
        }
    }

    //如果没有数据，则置为nil信息，并不往下执行
    if (theHis.count == 0) {
        [self.mainScroll.tempView.lineView cleanAll];
        return ;
    }

    //时间区间内的温度数据集、时间戳集
    NSMutableArray * temps = [NSMutableArray array];
    NSMutableArray * xPers = [NSMutableArray array];

    //整个时间端点内的时间戳长度
    NSTimeInterval allTime = nextInterval - lastInterval;

    //遍历对应的数据源，生成温度、横坐标百分比的数据源
    for (int i=0; i<theHis.count; i++) {
        FMDB_HitoryRecord * history = [theHis objectAtIndex:i];
        [temps addObject:@(history.temperature)];
        float perc = (history.dateInterval - lastInterval)/allTime;
        [xPers addObject:@(perc)];
    }

    //每个单元格的时间长度
    NSTimeInterval unitTime = 3600*24*7/floor(self.mainScroll.tempView
                                            .lineView.xCount);
    //获取横坐标的显示值
    NSMutableArray <NSString *>* xValues = [NSMutableArray array];
    //根据横坐标格数生成相应数量的数据
    for (int i=0; i<=self.mainScroll.tempView
         .lineView.xCount; i++) {
        int month = [[NSDate dateWithTimeIntervalSince1970:lastInterval + i*unitTime] month];
        int day = [[NSDate dateWithTimeIntervalSince1970:lastInterval + i*unitTime] day];
        [xValues addObject:[NSString stringWithFormat:@"%02d.%02d",month,day]];
    }

    //根据数据进行刷新
    self.mainScroll.tempView.lineView.values = temps;
    self.mainScroll.tempView.lineView.xValues = xValues;
    self.mainScroll.tempView.lineView.xPers = xPers;
    [self.mainScroll.tempView.lineView setNeedsDisplay];

//    //获取显示的时间
//    NSDate *nowDate = [NSDate zoneDate];
//    if (self.mainScroll.chooseSeg.date == nil) {
//        self.mainScroll.chooseSeg.date = nowDate;
//    }
//    NSDate *date = self.mainScroll.chooseSeg.date;
//
//    //根据方向计算新的后一个时间
//    date = [date dateByAddingTimeInterval:isLeft?(-3600*24*7):(3600*24*7)];
//    //如果新的时间大于当前时间，隐藏后一个按钮
//    if ([date timeIntervalSince1970] >= [nowDate timeIntervalSince1970]) {
//        self.mainScroll.chooseSeg.btn5.hidden = true;
//        return ;
//    }
//    //反之
//    else{
//        self.mainScroll.chooseSeg.btn5.hidden = false;
//    }
//
//    NSDate *nextDate = [date dateByAddingTimeInterval:(-3600*24*7)];
//
//    //刷新中间时间文本
//    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:
//                                                @"%@ %02d %d - %@ %02d %d"
//                                                ,[NSString englishMonth:[nextDate month] IsAb:true]
//                                                ,[nextDate day]
//                                                ,[nextDate year]
//                                                ,[NSString englishMonth:[date month] IsAb:true]
//                                                ,[date day]
//                                                ,[date year]];
//    [self.mainScroll.chooseSeg.labCenter sizeToFit];
//
//    //重新赋予时间
//    self.mainScroll.chooseSeg.date = date;
//
//    //两个时间端点的时间戳
//    NSTimeInterval nextInterval = [self.mainScroll.chooseSeg.date timeIntervalSince1970];
//    NSTimeInterval lastInterval = nextInterval - 3600;
//
//    //时间区间内的温度数据集、时间戳集
//    NSMutableArray *temps = [NSMutableArray array];
//    NSMutableArray *intervals = [NSMutableArray array];
//
//    //遍历所有历史数据添加
//    for (FMDB_HitoryRecord *history in self.histories) {
//        if (history.dateInterval >= lastInterval && history.dateInterval <= nextInterval) {
//            //            NSLog(@"%d %f %f˚C %d%%",history.testID,history.dateInterval,history.temperature,history.humidity);
//            [temps addObject:@(history.temperature)];
//            [intervals addObject:@(history.dateInterval)];
//        }
//    }
//
//    if (temps.count == 0) {
//        return ;
//    }
//
//    //取得之间戳最值
//    NSTimeInterval maxInterval = [[intervals maxNumber] doubleValue];
//    NSTimeInterval minInterval = [[intervals minNumber] doubleValue];
//    //根据横坐标数得到单元时间戳长度
//    NSTimeInterval unitInterval = (maxInterval - minInterval)/floor(self.mainScroll.tempView.lineView.xCount);
//
//    if (maxInterval == minInterval) {
//        unitInterval = maxInterval;
//    }
//
//    //根据每个时间戳 得到所占百分比并进行添加
//    NSMutableArray *xPers = [NSMutableArray array];
//    for (int i=0; i<intervals.count; i++) {
//        NSTimeInterval inter = [intervals[i] doubleValue];
//        CGFloat perc = inter/(maxInterval - minInterval);
//        [xPers addObject:@(perc)];
//    }
//
//    //横坐标值 时:分
//    NSMutableArray *xValues = [NSMutableArray array];
//    for (int i=0; i<self.mainScroll.tempView.lineView.xCount; i++) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:minInterval+i*unitInterval];
//        int hour = [date hour];
//        int min = [date minute];
//        NSString *str = [NSString stringWithFormat:@"%02d:%02d",hour,min];
//        [xValues addObject:str];
//    }
//
//    self.mainScroll.tempView.lineView.values = temps;
//    self.mainScroll.tempView.lineView.xValues = xValues;//@[@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00"];
//    self.mainScroll.tempView.lineView.xPers = xPers;//@[@(0),@(0.2),@(0.7),@(1)];
//    [self.mainScroll.tempView.lineView setNeedsDisplay];

}


/*!
 * 刷新历史记录view(当前小时、温度类型)
 */
- (void)refershHourHumiLineView:(bool)isLeft{

    //获取要显示的新时间
    NSDate * date = [self getDateWithIsLeft:isLeft Interval:3600];

    //显示方向按钮与否
    [self refershDirectionBtnWithDate:date];

    //刷新中间时间文本
    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%02d:00--%02d:00",[date hourWithNumber:-1],[date hour]];
    [self.mainScroll.chooseSeg.labCenter sizeToFit];

    //重新赋予时间
    self.mainScroll.chooseSeg.date = date;

    //把数据源按时间戳升序排序
    NSArray <FMDB_HitoryRecord *>* newHis = [self sortTimeAscendHistories:self.histories];

    //得到整点的时间
    NSDate * intDate = [self.mainScroll.chooseSeg.date intByHour];

    //两个时间端点的时间戳
    NSTimeInterval nextInterval = [intDate timeIntervalSince1970];
    NSTimeInterval lastInterval = nextInterval - 3600;

    //筛选获取在两端整点时间内的数据
    NSMutableArray <FMDB_HitoryRecord *>* theHis = [NSMutableArray array];
    //遍历筛选添加
    for (int i=0; i<newHis.count; i++) {
        FMDB_HitoryRecord *history = [newHis objectAtIndex:i];
        if ((history.dateInterval >= lastInterval) && (history.dateInterval <= nextInterval)) {
            [theHis addObject:history];
        }
    }

    //如果没有数据，则置为nil信息，并不往下执行
    if (theHis.count == 0) {
        [self.mainScroll.humiView.lineView cleanAll];
        return ;
    }

    //时间区间内的温度数据集、时间戳集
    NSMutableArray *humis = [NSMutableArray array];
    NSMutableArray *xPers = [NSMutableArray array];

    //整个时间端点内的时间戳长度
    NSTimeInterval allTime = nextInterval - lastInterval;

    //遍历对应的数据源，生成温度、横坐标百分比的数据源
    for (int i=0; i<theHis.count; i++) {
        FMDB_HitoryRecord * history = [theHis objectAtIndex:i];
        [humis addObject:@(history.humidity)];
        float perc = (history.dateInterval - lastInterval)/allTime;
        [xPers addObject:@(perc)];
    }

    //每个单元格的时间长度
    NSTimeInterval unitTime = 3600/floor(self.mainScroll.humiView
                                         .lineView.xCount);
    //获取横坐标的显示值
    NSMutableArray <NSString *>* xValues = [NSMutableArray array];
    //根据横坐标格数生成相应数量的数据
    for (int i=0; i<=self.mainScroll.humiView
         .lineView.xCount; i++) {
        int minute = [[NSDate dateWithTimeIntervalSince1970:nextInterval+i*unitTime] minute];
        int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval+i*unitTime] hour];
        [xValues addObject:[NSString stringWithFormat:@"%02d:%02d",hour,minute]];
    }

    //根据数据进行刷新
    self.mainScroll.humiView.lineView.values = humis;
    self.mainScroll.humiView.lineView.xValues = xValues;
    self.mainScroll.humiView.lineView.xPers = xPers;
    [self.mainScroll.humiView.lineView setNeedsDisplay];

}

/*!
 * 刷新历史记录view(当前天、湿度类型)
 */
- (void)refershDayHumiLineView:(bool)isLeft{

    //获取要显示的新时间
    NSDate * date = [self getDateWithIsLeft:isLeft Interval:3600*24];

    //显示方向按钮与否
    [self refershDirectionBtnWithDate:date];

    NSString *monStr = [NSString englishMonth:[date month] IsAb:true];
    //刷新中间时间文本
    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d",monStr,[date day],[date year]];
    [self.mainScroll.chooseSeg.labCenter sizeToFit];

    //重新赋予时间
    self.mainScroll.chooseSeg.date = date;

    //把数据源按时间戳升序排序
    NSArray <FMDB_HitoryRecord *>* newHis = [self sortTimeAscendHistories:self.histories];

    //得到整天的时间
    NSDate * intDate = [self.mainScroll.chooseSeg.date intByDay];

    //两个时间端点的时间戳
    NSTimeInterval nextInterval = [intDate timeIntervalSince1970];
    NSTimeInterval lastInterval = nextInterval - 3600*24;

    //筛选获取在两端整点时间内的数据
    NSMutableArray <FMDB_HitoryRecord *>* theHis = [NSMutableArray array];
    //遍历筛选添加
    for (int i=0; i<newHis.count; i++) {
        FMDB_HitoryRecord *history = [newHis objectAtIndex:i];
        if ((history.dateInterval >= lastInterval) && (history.dateInterval <= nextInterval)) {
            [theHis addObject:history];
        }
    }

    //如果没有数据，则置为nil信息，并不往下执行
    if (theHis.count == 0) {
        [self.mainScroll.humiView.lineView cleanAll];
        return ;
    }

    //时间区间内的温度数据集、时间戳集
    NSMutableArray *humis = [NSMutableArray array];
    NSMutableArray *xPers = [NSMutableArray array];

    //整个时间端点内的时间戳长度
    NSTimeInterval allTime = nextInterval - lastInterval;

    //遍历对应的数据源，生成温度、横坐标百分比的数据源
    for (int i=0; i<theHis.count; i++) {
        FMDB_HitoryRecord * history = [theHis objectAtIndex:i];
        [humis addObject:@(history.humidity)];
        float perc = (history.dateInterval - lastInterval)/allTime;
        [xPers addObject:@(perc)];
    }

    //每个单元格的时间长度
    NSTimeInterval unitTime = 3600*24/floor(self.mainScroll.humiView
                                            .lineView.xCount);
    //获取横坐标的显示值
    NSMutableArray <NSString *>* xValues = [NSMutableArray array];
    //根据横坐标格数生成相应数量的数据
    for (int i=0; i<=self.mainScroll.humiView
         .lineView.xCount; i++) {
        int hour = [[NSDate dateWithTimeIntervalSince1970:nextInterval+i*unitTime] hour];
        [xValues addObject:[NSString stringWithFormat:@"%02d:00",hour]];
    }

    //根据数据进行刷新
    self.mainScroll.humiView.lineView.values = humis;
    self.mainScroll.humiView.lineView.xValues = xValues;
    self.mainScroll.humiView.lineView.xPers = xPers;
    [self.mainScroll.humiView.lineView setNeedsDisplay];

}

/*!
 * 刷新历史记录view(当前周、湿度类型)
 */
- (void)refershWeekHumiLineView:(bool)isLeft{

    //获取要显示的新时间
    NSDate * date = [self getDateWithIsLeft:isLeft Interval:3600*24*7];
    NSDate * date1 = [date dateWithDays:-7];

    //显示方向按钮与否
    [self refershDirectionBtnWithDate:date];

    NSString * monStr = [NSString englishMonth:[date month] IsAb:true];
    NSString * monStr1 = [NSString englishMonth:[date1 month] IsAb:true];
    //刷新中间时间文本
    self.mainScroll.chooseSeg.labCenter.text = [NSString stringWithFormat:@"%@ %02d %d - %@ %02d %d",monStr1,[date1 day],[date1 year],monStr,[date day],[date year]];
    [self.mainScroll.chooseSeg.labCenter sizeToFit];

    //重新赋予时间
    self.mainScroll.chooseSeg.date = date;

    //把数据源按时间戳升序排序
    NSArray <FMDB_HitoryRecord *>* newHis = [self sortTimeAscendHistories:self.histories];

    //    //得到整天的时间
    //    NSDate * intDate = [self.mainScroll.chooseSeg.date intByDay];

    //两个时间端点的时间戳
    NSTimeInterval nextInterval = [date timeIntervalSince1970];
    NSTimeInterval lastInterval = [date1 timeIntervalSince1970];

    //筛选获取在两端整点时间内的数据
    NSMutableArray <FMDB_HitoryRecord *>* theHis = [NSMutableArray array];
    //遍历筛选添加
    for (int i=0; i<newHis.count; i++) {
        FMDB_HitoryRecord *history = [newHis objectAtIndex:i];
        if ((history.dateInterval >= lastInterval) && (history.dateInterval <= nextInterval)) {
            [theHis addObject:history];
        }
    }

    //如果没有数据，则置为nil信息，并不往下执行
    if (theHis.count == 0) {
        [self.mainScroll.humiView.lineView cleanAll];
        return ;
    }

    //时间区间内的温度数据集、时间戳集
    NSMutableArray * humis = [NSMutableArray array];
    NSMutableArray * xPers = [NSMutableArray array];

    //整个时间端点内的时间戳长度
    NSTimeInterval allTime = nextInterval - lastInterval;

    //遍历对应的数据源，生成温度、横坐标百分比的数据源
    for (int i=0; i<theHis.count; i++) {
        FMDB_HitoryRecord * history = [theHis objectAtIndex:i];
        [humis addObject:@(history.humidity)];
        float perc = (history.dateInterval - lastInterval)/allTime;
        [xPers addObject:@(perc)];
    }

    //每个单元格的时间长度
    NSTimeInterval unitTime = 3600*24*7/floor(self.mainScroll.humiView
                                              .lineView.xCount);
    //获取横坐标的显示值
    NSMutableArray <NSString *>* xValues = [NSMutableArray array];
    //根据横坐标格数生成相应数量的数据
    for (int i=0; i<=self.mainScroll.humiView
         .lineView.xCount; i++) {
        int month = [[NSDate dateWithTimeIntervalSince1970:lastInterval + i*unitTime] month];
        int day = [[NSDate dateWithTimeIntervalSince1970:lastInterval + i*unitTime] day];
        [xValues addObject:[NSString stringWithFormat:@"%02d.%02d",month,day]];
    }

    //根据数据进行刷新
    self.mainScroll.humiView.lineView.values = humis;
    self.mainScroll.humiView.lineView.xValues = xValues;
    self.mainScroll.humiView.lineView.xPers = xPers;
    [self.mainScroll.humiView.lineView setNeedsDisplay];

}





#pragma mark ----- inside method
/*!
 * 根据方向重新计算后按钮时间
 */
- (NSDate *)getDateWithIsLeft:(bool)isLeft Interval:(NSTimeInterval)interval{

    //获取显示的时间
    if (self.mainScroll.chooseSeg.date == nil) {
        self.mainScroll.chooseSeg.date = [NSDate zoneDate];
    }
    NSDate * date = self.mainScroll.chooseSeg.date;

    //根据方向计算新的后一个时间
    date = [date dateByAddingTimeInterval:isLeft?-interval:interval];

    return date;
}

/*!
 * 根据时间，刷新按钮的显示与否
 */
- (void)refershDirectionBtnWithDate:(NSDate *)date{

    NSDate *nowDate = [NSDate zoneDate];
    //如果新的时间大于当前时间，隐藏后一个按钮
    if ([date timeIntervalSince1970] >= [nowDate timeIntervalSince1970]) {
        self.mainScroll.chooseSeg.btn5.hidden = true;
        return ;
    }
    //反之
    else{
        self.mainScroll.chooseSeg.btn5.hidden = false;
    }
}

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

/*!
 * 升序
 */
- (NSArray <FMDB_HitoryRecord*>*)sortTimeAscendHistories:(NSArray <FMDB_HitoryRecord *>*)histories{
    NSArray * newValues = [histories sortedArrayUsingComparator:^NSComparisonResult(FMDB_HitoryRecord * obj1, FMDB_HitoryRecord * obj2) {
        NSComparisonResult result = (obj1.dateInterval < obj2.dateInterval);
        return result;
    }];
    newValues = [[newValues reverseObjectEnumerator] allObjects];
    return newValues;
}


@end
