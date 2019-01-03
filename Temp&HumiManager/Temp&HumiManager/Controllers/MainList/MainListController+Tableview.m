//
//  MainListController+Tableview.m
//  Temp&HumiManager
//
//  Created by terry on 2018/11/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController+Tableview.h"
#import "MainListController+Extension.h"
#import "MainListController+BG.h"
#import "MainTableViewCell.h"
#import "MainTableViewHeader.h"
#import "TH_GroupInfo.h"
#import "DetailInfoController.h"
#import "BlueToothInfo.h"
#import "DeviceDB+CoreDataClass.h"

@implementation MainListController (Tableview)


#pragma mark - cell
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * reuseIdentifer = @"CellID";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    cell.logo = [UIImage imageNamed:@"ic_room_car"];
    cell.tempWarning = false;
    cell.humiWarning = false;

    if (tableView.tag == 1000) {

        NSMutableDictionary * mdic = self.groupDatasource[indexPath.section];
        NSArray * devs = mdic[@"devices"];
        NSMutableDictionary * mdic1 = devs[indexPath.row];
        DeviceInfo * device = mdic1[@"device"];
        NSMutableDictionary * warn = mdic1[@"warn"];
        cell.labTitle.text = device.showName;

        cell.iswifi = true;
        cell.isble = false;
        
        cell.logo = [UIImage imageNamed:[device imageNameWithMototype]];
        
        float temp = [device temeratureBySData];
        NSString * tpstr = temp == -1000 ? @"--" : [NSString stringWithFormat:@"%.1f%@",[device temeratureBySData],[MyDefaultManager unit]];
        cell.labTemp.text = tpstr;
        
        int humi = [device humidityBySData];
        NSString * hmstr = humi == -1000 ? @"--" : [NSString stringWithFormat:@"%d%%",[device humidityBySData]];
        cell.labHumi.text = hmstr;
        
        int power = [device powerBySData];
        NSString * pwstr = power == -1000 ? @"--" : [NSString stringWithFormat:@"%d%%",[device powerBySData]];
        cell.labPower.text = pwstr;
        
        cell.tempWarning = [warn[@"tempWarn"] boolValue];
        cell.humiWarning = [warn[@"humiWarn"] boolValue];
        
    }
    else if (tableView.tag == 2000){

        [self handleBLECell:cell IndexPath:indexPath];
        
    }


    return cell;


}

#pragma mark - 每组行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag == 1000) {
        NSMutableDictionary * dic = self.groupDatasource[section];
        bool flex = [dic[@"flex"] boolValue];
        if (flex) {
            NSArray * devs = dic[@"devices"];
            return devs.count;
        }
        return 0;
    }
    else if (tableView.tag == 2000){
        return self.bleDatasource.count;
    }
    else {
        return 0;
    }

}

#pragma mark - 组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (tableView.tag == 1000) {

        TH_GroupInfo * group = self.groupDatasource[section][@"group"];
        NSString * name = group.name ? group.name : @"no name";

        MainTableViewHeader * header = [[MainTableViewHeader alloc]init];
        header.labTitle.text = name;
        header.section = section;

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
        [header addGestureRecognizer:tap];

        return header;
    }

    return nil;

//    NSObject * object = self.groupDatasource[section];
//
//    NSString * name = @"no name";
//    if ([object isKindOfClass:[NSDictionary class]]) {
//        NSDictionary * dic = (NSDictionary *)object;
//        name = [dic valueForKey:@"gname"];
//    } else {
//        return nil;
//    }
//
//    MainTableViewHeader * header = [[MainTableViewHeader alloc]init];
//    header.labTitle.text = name;
//    header.section = section;
//
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
//    [header addGestureRecognizer:tap];
//
//    return header;

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

#pragma mark - 组尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [[UIView alloc]init];
    return footer;
}

#pragma mark - 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1000) {
        return self.groupDatasource.count;
    }
    else if (tableView.tag == 2000){
        return 1;
    }
    return 0;
}

#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 140;
}

#pragma mark - 组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (tableView.tag == 1000) {
        return 40;
    }
    return 0;

}

#pragma mark - 组尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;
}

#pragma mark - 选择某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1000) {
        [self handleSelectInternetDeviceWithIndexPath:indexPath];
    }
    else if (tableView.tag == 2000) {
        [self handleSelcectBLEDeviceWithIndexPath:indexPath];
    }

}

#pragma mark - 其他事件区域
- (void)tapHeader:(UIGestureRecognizer *)gesture{

    MainTableViewHeader * header = (MainTableViewHeader * )gesture.view;

    NSLock * lock = [[NSLock alloc]init];
    [lock lock];

    NSMutableDictionary * dic = self.groupDatasource[header.section];
    bool flex = [dic[@"flex"] boolValue];
    [dic setValue:@(!flex) forKey:@"flex"];

    [self.groupTable reloadSections:[NSIndexSet indexSetWithIndex:header.section] withRowAnimation:UITableViewRowAnimationFade];

    [lock unlock];

}

#pragma mark - 私有方法

/**
 处理蓝牙的cell

 @param cell 该cell
 @param indexPath 下标
 */
- (void)handleBLECell:(MainTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * mdic = self.bleDatasource[indexPath.row];
    MyPeripheral * peripheral = mdic[@"ble"];
    DeviceDB * device = mdic[@"device"];
    
    cell.iswifi = false;
    cell.isble = true;
    
    if (device) {
        cell.labTitle.text = device.dbName;
    } else {
        cell.labTitle.text = peripheral.peripheral.name ? peripheral.peripheral.name : peripheral.peripheral.identifier.UUIDString;
    }
    
    if (peripheral) {
        NSString * powerTxt = ([peripheral powerBle] == -1000)?@"--%":[NSString stringWithFormat:@"%d%%",[peripheral powerBle]];
        NSString * tempTxt = ([peripheral temperatureBle] == -1000)?@"--˚C":[NSString stringWithFormat:@"%.1f%@",[peripheral temperatureBle],[MyDefaultManager unit]];
        NSString * humiTxt = ([peripheral humidityBle] == -1000)?@"--%":[NSString stringWithFormat:@"%d%%",[peripheral humidityBle]];
        cell.labPower.text = powerTxt;
        cell.labTemp.text = tempTxt;
        cell.labHumi.text = humiTxt;
    } else {
        cell.labPower.text = @"--%";
        cell.labTemp.text = [NSString stringWithFormat:@"--%@",[MyDefaultManager unit]];
        cell.labHumi.text = @"--%";
    }
    
    NSMutableDictionary * warn = mdic[@"warn"];
    cell.tempWarning = [warn[@"tempWarn"] boolValue];
    cell.humiWarning = [warn[@"humiWarn"] boolValue];
    
    if (mdic[@"fakeble"]) {
        cell.labTemp.text = [NSString stringWithFormat:@"%.1f%@",[mdic[@"fakeble"][@"temp"] floatValue],[MyDefaultManager unit]];
        cell.labHumi.text = [NSString stringWithFormat:@"%d%%",[mdic[@"fakeble"][@"humi"] intValue]];
    }
}

/**
 处理点击网络设备的操作

 @param indexPath 点击第几个
 */
- (void)handleSelectInternetDeviceWithIndexPath:(NSIndexPath *)indexPath{
    
    LRWeakSelf(self);
    NSMutableDictionary * mdic = self.groupDatasource[indexPath.section];
    NSArray * devs = mdic[@"devices"];
    DeviceInfo * device = devs[indexPath.row][@"device"];
    NSMutableDictionary * warn = devs[indexPath.row][@"warn"];
    if ([warn[@"tempWarn"] boolValue] || [warn[@"humiWarn"] boolValue]) {
        
        float tpmin = [warn[@"tempMin"] floatValue];
        float tpmax = [warn[@"tempMax"] floatValue];
        int hmmin = [warn[@"humiMin"] intValue];
        int hmmax = [warn[@"humiMax"] intValue];
        bool tpwarn = [warn[@"tempWarn"] boolValue];
        bool hmwarn = [warn[@"humiWarn"] boolValue];
        
        NSString * tpText = @"No Warning";
        if (tpwarn) {
            NSString * unit = [MyDefaultManager unit];
            if (device.temeratureBySData <= tpmin) {
                tpText = [NSString stringWithFormat:@"%.1f%@    <=    %.1f%@",device.temeratureBySData,unit,tpmin,unit];
            } else{
                tpText = [NSString stringWithFormat:@"%.1f%@    >=    %.1f%@",device.temeratureBySData,unit,tpmax,unit];
            }
        }
        NSString * hmText = @"No Warning";
        if (hmwarn) {
            NSString * unit1 = @"%";
            if (device.humidityBySData <= hmmin) {
                hmText = [NSString stringWithFormat:@"%d%@    <=    %d%@",device.humidityBySData,unit1,hmmin,unit1];
            } else{
                hmText = [NSString stringWithFormat:@"%d%@    >=    %d%@",device.humidityBySData,unit1,hmmax,unit1];
            }
        }
        
        [My_AlertView showConfrimAlertWithTempText:tpText HumiText:hmText Completion:^(My_AlertView *alert) {
            
            NSMutableDictionary * sec = weakself.groupDatasource[indexPath.section];
            NSMutableArray * rows = sec[@"devices"];
            NSMutableDictionary * row = rows[indexPath.row];
            [row[@"warn"] setValue:@(false) forKey:@"humiWarn"];
            [row[@"warn"] setValue:@(false) forKey:@"tempWarn"];
            
            [weakself.groupTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [weakself saveWarnConfirmWithMac:device.mac];
            
            DetailInfoController * dvc = [[DetailInfoController alloc]init];
            dvc.deviceInfo = device;
            [weakself.navigationController pushViewController:dvc animated:true];
        }];
    } else {
        DetailInfoController * dvc = [[DetailInfoController alloc]init];
        dvc.deviceInfo = device;
        [self.navigationController pushViewController:dvc animated:true];
    }
}

/**
 处理点击蓝牙设备的操作

 @param indexPath 第几个
 */
- (void)handleSelcectBLEDeviceWithIndexPath:(NSIndexPath *)indexPath{
    
//    [self handleFakeBLEDevice:indexPath];
//    return ;
    
    LRWeakSelf(self);
    NSMutableDictionary * mdic = self.bleDatasource[indexPath.row];
    NSMutableDictionary * warn = mdic[@"warn"];
    MyPeripheral * ble = mdic[@"ble"];

//    DetailInfoController * dvc = [[DetailInfoController alloc]init];
//    dvc.deviceInfo = ble;
//    [weakself.navigationController pushViewController:dvc animated:true];
//    
//    return ;
    
    //有报警，先弹报警窗
    if ([warn[@"tempWarn"] boolValue] || [warn[@"humiWarn"] boolValue]) {
        
        float tpmin = [warn[@"tempMin"] floatValue];
        float tpmax = [warn[@"tempMax"] floatValue];
        int hmmin = [warn[@"humiMin"] intValue];
        int hmmax = [warn[@"humiMax"] intValue];
        bool tpwarn = [warn[@"tempWarn"] boolValue];
        bool hmwarn = [warn[@"humiWarn"] boolValue];
        
        float temp = ble.temperatureBle;
        int humi = ble.humidityBle;
        NSString * mac = ble.macAddress;
        
        NSString * tpText = @"No Warning";
        if (tpwarn) {
            NSString * unit = [MyDefaultManager unit];
            if (temp <= tpmin) {
                tpText = [NSString stringWithFormat:@"%.1f%@    <=    %.1f%@",temp,unit,tpmin,unit];
            } else{
                tpText = [NSString stringWithFormat:@"%.1f%@    >=    %.1f%@",temp,unit,tpmax,unit];
            }
        }
        NSString * hmText = @"No Warning";
        if (hmwarn) {
            NSString * unit1 = @"%";
            if (humi <= hmmin) {
                hmText = [NSString stringWithFormat:@"%d%@    <=    %d%@",humi,unit1,hmmin,unit1];
            } else{
                hmText = [NSString stringWithFormat:@"%d%@    >=    %d%@",humi,unit1,hmmax,unit1];
            }
        }
        
        //show确认报警
        [My_AlertView showConfrimAlertWithTempText:tpText HumiText:hmText Completion:^(My_AlertView *alert) {
            
            [warn setValue:@(false) forKey:@"tempWarn"];
            [warn setValue:@(false) forKey:@"humiWarn"];
            [self.bleTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakself saveWarnConfirmWithMac:mac];
            
            //show连接提示
            [My_AlertView showLoadingWithText:@"Connect Blue Tooth…" Block:^(My_AlertView *loading, UILabel *infoLab) {

                //连接蓝牙
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
                dispatch_async(queue, ^{
                    [[BLEManager shareInstance] connectCBPeripheral:ble.peripheral OverTime:30 Queue:queue Result:^(bool success, NSString *info, CBPeripheral *peripheral) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [loading dismiss];
                            if (success) {
                                DetailInfoController * dvc = [[DetailInfoController alloc]init];
                                dvc.deviceInfo = ble;
                                [weakself.navigationController pushViewController:dvc animated:true];
                            } else {
                                [My_AlertView showInfo:info Block:nil];
                            }
                        });
                        
                    }];
                });
            }];

            
        }];
    }
    else {
        
        //show连接提示
        [My_AlertView showLoadingWithText:@"Connect Blue Tooth…" Block:^(My_AlertView *loading, UILabel *infoLab) {
            
            //连接蓝牙
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_async(queue, ^{
                [[BLEManager shareInstance] connectCBPeripheral:ble.peripheral OverTime:30 Queue:queue Result:^(bool success, NSString *info, CBPeripheral *peripheral) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [loading dismiss];
                        if (success) {
                            DetailInfoController * dvc = [[DetailInfoController alloc]init];
                            dvc.deviceInfo = ble;
                            [weakself.navigationController pushViewController:dvc animated:true];
                        } else {
                            [My_AlertView showInfo:info Block:nil];
                        }
                    });
                    
                }];
            });
        }];

    }
    
}

/**
 处理假的点击蓝牙设备的操作

 @param indexPath 第几个
 */
- (void)handleFakeBLEDevice:(NSIndexPath *)indexPath{
    
    LRWeakSelf(self);
    NSMutableDictionary * mdic = self.bleDatasource[indexPath.row];
    NSMutableDictionary * warn = mdic[@"warn"];
    NSMutableDictionary * ble = mdic[@"fakeble"];
    
    //有报警，先弹报警窗
    if ([warn[@"tempWarn"] boolValue] || [warn[@"humiWarn"] boolValue]) {
        
        float tpmin = [warn[@"tempMin"] floatValue];
        float tpmax = [warn[@"tempMax"] floatValue];
        int hmmin = [warn[@"humiMin"] intValue];
        int hmmax = [warn[@"humiMax"] intValue];
        bool tpwarn = [warn[@"tempWarn"] boolValue];
        bool hmwarn = [warn[@"humiWarn"] boolValue];
        float temp = [ble[@"temp"] floatValue];
        int humi = [ble[@"humi"] intValue];
        NSString * mac = ble[@"mac"];
        
        NSString * tpText = @"No Warning";
        if (tpwarn) {
            NSString * unit = [MyDefaultManager unit];
            if (temp <= tpmin) {
                tpText = [NSString stringWithFormat:@"%.1f%@    <=    %.1f%@",temp,unit,tpmin,unit];
            } else{
                tpText = [NSString stringWithFormat:@"%.1f%@    >=    %.1f%@",temp,unit,tpmax,unit];
            }
        }
        NSString * hmText = @"No Warning";
        if (hmwarn) {
            NSString * unit1 = @"%";
            if (humi <= hmmin) {
                hmText = [NSString stringWithFormat:@"%d%@    <=    %d%@",humi,unit1,hmmin,unit1];
            } else{
                hmText = [NSString stringWithFormat:@"%d%@    >=    %d%@",humi,unit1,hmmax,unit1];
            }
        }
        
        //show 确认报警
        [My_AlertView showConfrimAlertWithTempText:tpText HumiText:hmText Completion:^(My_AlertView *alert) {
            
            //置为不报警
            [warn setValue:@(false) forKey:@"tempWarn"];
            [warn setValue:@(false) forKey:@"humiWarn"];
            [self.bleTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakself saveWarnConfirmWithMac:mac];
            
            //show 连接蓝牙的弹窗
            [My_AlertView showLoadingWithText:@"Connect Blue Tooth…" Block:^(My_AlertView *loading, UILabel *infoLab) {
                
                //假装连接成功，推送到下一个界面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [loading dismiss];
                    DetailInfoController * dvc = [[DetailInfoController alloc]init];
                    dvc.deviceInfo = mdic[@"fakeble"];
                    [weakself.navigationController pushViewController:dvc animated:true];
                });

            }];
        }];
    } else {
        
        //show连接蓝牙
        [My_AlertView showLoadingWithText:@"Connect Blue Tooth…" Block:^(My_AlertView *loading, UILabel *infoLab) {
            
            //假装连接成功，推送
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [loading dismiss];
                DetailInfoController * dvc = [[DetailInfoController alloc]init];
                dvc.deviceInfo = mdic[@"fakeble"];
                [weakself.navigationController pushViewController:dvc animated:true];
            });
            return ;
        }];
        
    }
}


@end
