//
//  MainViewController+Delegate.m
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController+Delegate.h"
#import "MainViewController+MainExtention.h"

#import "MainTableViewCell.h"
#import "MainTableViewHeader.h"

@implementation MainViewController (Delegate)

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * reuseIdentifer = @"CellID";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnLink addTarget:self action:@selector(clickLinkButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.logo = [UIImage imageNamed:@"ic_room_car"];

    cell.indexPath = indexPath;

    if (indexPath.row % 2 == 0) {
        cell.showLink = false;
    } else {
        cell.showLink = true;
    }

    MainTableObject * mto = [self.dataSources objectAtIndex:indexPath.section];
    NSMutableDictionary * mdic = [mto.devices objectAtIndex:indexPath.row];
    NSMutableDictionary * warning = [mdic valueForKey:@"warning"];
    cell.tempWarning = [[warning valueForKey:@"temp"] boolValue];
    cell.humiWarning = [[warning valueForKey:@"humi"] boolValue];

    if (mto.type == DataType_Ble) {

        BlueToothInfo * bti = [mdic valueForKey:@"ble"];

        cell.isble = true;
        cell.iswifi = false;

        cell.labTitle.text = bti.peripheral.name;

        NSString * powerTxt = ([bti powerBle]==-1000)?@"--%":[NSString stringWithFormat:@"%d%%",[bti powerBle]];
        NSString * tempTxt = ([bti temperatureBle]==-1000)?@"--%":[NSString stringWithFormat:@"%.1f˚C",[bti temperatureBle]];
        NSString * humiTxt = ([bti humidityBle]==-1000)?@"--%":[NSString stringWithFormat:@"%d%%",[bti humidityBle]];

        cell.labPower.text = powerTxt;
        cell.labTemp.text = tempTxt;
        cell.labHumi.text = humiTxt;

    } else if(mto.type == DataType_Wifi){

        DeviceInfo * di = [mdic valueForKey:@"wifi"];
        BlueToothInfo * bti = [mdic valueForKey:@"ble"];

        cell.isble = false;
        cell.iswifi = true;

        cell.labTitle.text = di.showName;

        NSString * powerTxt = ([bti powerBle]==-1000)?@"--%":[NSString stringWithFormat:@"%d%%",[bti powerBle]];
        NSString * tempTxt = ([bti temperatureBle]==-1000)?@"--%":[NSString stringWithFormat:@"%.1f˚C",[bti temperatureBle]];
        NSString * humiTxt = ([bti humidityBle]==-1000)?@"--%":[NSString stringWithFormat:@"%d%%",[bti humidityBle]];

        cell.labPower.text = powerTxt;
        cell.labTemp.text = tempTxt;
        cell.labHumi.text = humiTxt;

    } else {

//        NSLog(@"%@",mto.devices);
        DeviceInfo * di = [mdic valueForKey:@"wifi"];

        cell.isble = false;
        cell.iswifi = true;
        //        cell.tempWarning = mto.tpWarning;
        //        cell.humiWarning = mto.hmWarning;
        cell.labTitle.text = di.showName;

        NSString * powerTxt = ([di powerBySData]==-1000)?@"--%":[NSString stringWithFormat:@"%d%%",[di powerBySData]];
        NSString * tempTxt = ([di temeratureBySData]==-1000)?@"--%":[NSString stringWithFormat:@"%.1f˚C",[di temeratureBySData]];
        NSString * humiTxt = ([di humidityBySData]==-1000)?@"--%":[NSString stringWithFormat:@"%d%%",[di humidityBySData]];

        cell.labPower.text = powerTxt;
        cell.labTemp.text = tempTxt;
        cell.labHumi.text = humiTxt;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MainTableObject * mto = self.dataSources[section];
    MainTableViewHeader * view = [[MainTableViewHeader alloc]init];
    view.labTitle.text = mto.group.name;
//    view.labTitle.textColor = mto.flex?[UIColor redColor]:[UIColor blackColor];
    view.section = section;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
    [view addGestureRecognizer:tap];

    return view;

//    MainTableObject * mto = nil;
//    if (section < self.dataSources.count) {
//        mto = [self.dataSources objectAtIndex:section];
//    } else {
//        return nil;
//    }
//
//    if (mto.type == DataType_Default) {
//
//        MainTableViewHeader * view = [[MainTableViewHeader alloc]init];
//        view.labTitle.text = mto.groupInfo.name;
//        view.section = section;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
//        [view addGestureRecognizer:tap];
//
//        return view;
//
//    } else{
//        return nil;
//    }
//
//    //组
//    if (section < self.groupDatas.count) {
//        TH_GroupInfo * go = self.groupDatas[section];
//        MainTableViewHeader * view = [[MainTableViewHeader alloc]init];
//        view.labTitle.text = go.name;
//        view.section = section;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
//        [view addGestureRecognizer:tap];
//        return view;
//    }
//    //关注
//    else if (section < (self.groupDatas.count + self.bleDatas.count)) {
//        return nil;
//    }
//    //蓝牙
//    else{
//        return nil;
//    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [[UIView alloc]init];
    return footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    MainTableObject * mto = [self.dataSources objectAtIndex:section];
    if (mto.type == DataType_Default) {
        if (mto.flex) {
            return mto.devices.count;
        } else {
            return 0;
        }
    } else {
        return self.dataSources[section].devices.count;
    }

//    if (section >= self.dataSources.count) {
//        return 0;
//    }
//
//    MainTableObject * mto = [self.dataSources objectAtIndex:section];
//    if (mto.type == DataType_Default) {
//        if (mto.flex) {
//            NSArray <DeviceInfo *>* devices = mto.groupInfo.devices;
//            return devices.count;
//        } else{
//            return 0;
//        }
//    } else {
//        return 1;
//    }

//    //组
//    if (section < self.groupDatas.count) {
//        TH_GroupInfo * go = self.groupDatas[section];
//        if (go.flex) {
//            return go.devices.count;
//        } else {
//            return 0;
//        }
//
//    }
//    //关注
//    else if (section < (self.groupDatas.count + self.wifiDatas.count)) {
//        return 1;
//    }
//    //蓝牙
//    else{
//        return 1;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        return tableView.frame.size.height/5.0;
    } else {
        return tableView.frame.size.height/5.0+Fit_Y(25.0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    MainTableObject * mto = [self.dataSources objectAtIndex:section];
    if (mto.type == DataType_Default) {
        return Fit_Y(40.0);
    } else {
        return 0;
    }
//    MainTableObject * mto = nil;
//    if (section < self.dataSources.count) {
//        mto = [self.dataSources objectAtIndex:section];
//    } else {
//        return 0;
//    }
//    if (mto.type == DataType_Default) {
//        return Fit_Y(40.0);
//    } else {
//        return 0;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Fit_Y(20.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return 0;
//}



- (void)clickLinkButton:(UIButton *)sender{
    MainTableViewCell * cell = (MainTableViewCell *)sender.superview.superview;
    NSLog(@"%ld",(long)cell.indexPath.row);
}

- (void)tapHeader:(UIGestureRecognizer *)gesture{

    MainTableViewHeader * view = (MainTableViewHeader * )gesture.view;

    NSLock * lock = [[NSLock alloc]init];
    [lock lock];
    bool flex = !self.dataSources[view.section].flex;
    self.dataSources[view.section].flex = flex;
    [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:view.section] withRowAnimation:UITableViewRowAnimationFade];
    [lock unlock];

//    NSInteger section = view.section;
//    //组
//    if (section < self.groupDatas.count) {
//        TH_GroupInfo * go = self.groupDatas[section];
//        go.flex = !go.flex;
//        [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

@end
