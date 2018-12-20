//
//  DetailInfoController+DetailInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/28.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"

#import "DetailEditAlert.h"

#import "DetailMainScroll.h"

#import "BLEManager.h"

#import "FMDB_HitoryRecord.h"

@interface DetailInfoController ()

@property (nonatomic,strong)DetailMainScroll *mainScroll;
@property (nonatomic,strong)DetailEditAlert *editAlert;

@property (nonatomic,strong)dispatch_source_t selectTimer;///<通用定时器
@property (nonatomic,strong)dispatch_source_t historyTimer;///<查询本地历史数据的定时器

@property (nonatomic,strong)NSMutableArray<FMDB_HitoryRecord *> *histories;///<历史数据
@property (nonatomic,strong)NSMutableArray<FMDB_DeviceWarn *> *warnInfos;///<报警历史数据

@property (nonatomic,strong)BLEManager *bleManager;

@property (nonatomic,assign)bool getBLEHistory;///<是否接收到蓝牙历史数据


@end
