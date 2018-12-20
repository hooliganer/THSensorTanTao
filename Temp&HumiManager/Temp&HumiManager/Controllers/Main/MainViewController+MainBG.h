//
//  MainViewController+MainBG.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController.h"
#import "MyGroupCollectionObject.h"

@interface MainViewController (MainBG)

- (void)selectAllDevices;

///*!
// * 搜索蓝牙设备
// */
//- (void)searchBLEDevices;

//- (void)startTimer;
- (void)linkDeviceWithMac:(NSString *)mac Name:(NSString *)name;

///*!
// * 判断具体是什么对象之后得到数据对象
// */
//- (GroupCollectionObject *)cellObjectWithIndexPath:(NSIndexPath *)indexPath;


- (void)showWarningViewWithIndexPath:(NSIndexPath *)indexPath;

@end
