//
//  MainViewController+BGer.h
//  Temp&HumiManager
//
//  Created by terry on 2018/9/10.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (BGer)

/*!
 * 搜索蓝牙设备，刷新蓝牙数据
 */
- (void)startBLEData;


/*!
 * 开启定时器查询
 */
- (void)setupTimer;

@end
