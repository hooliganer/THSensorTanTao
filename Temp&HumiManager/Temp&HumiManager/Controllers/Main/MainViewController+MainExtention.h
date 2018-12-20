//
//  MainViewController+MainExtention.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceInfo.h"
#import "MainCollectionObject.h"
//#import "BLEManager.h"
#import "MyGroupCollection.h"

#import "MainTableObject.h"

typedef NS_OPTIONS(NSInteger, MainViewTag) {
    MainViewTag_MainCollection = 100 ,
};

@interface MainViewController ()

//@property (nonatomic,strong)NSMutableArray<MainCollectionObject *> *datasArray;
//@property (nonatomic,strong)UICollectionView *mainCollection;
@property (nonatomic,strong)MyGroupCollection *mainCollection;
@property (nonatomic,strong)UITableView *mainTable;
@property (nonatomic,strong)dispatch_source_t selectTimer;///<查询网络所有设备,7s一次
@property (nonatomic,strong)dispatch_source_t warningTimer;///<报警判断,3s一次

@property (nonatomic,strong)NSMutableArray <MainTableObject *>* dataSources;
@property (nonatomic,strong)NSMutableArray <BlueToothInfo *>* bleDatas;
@property (nonatomic,strong)NSMutableArray <TH_GroupInfo *>* groupDatas;
@property (nonatomic,strong)NSMutableArray <DeviceInfo *>* wifiDatas;

@property (nonatomic,strong)NSMutableArray <NSMutableArray <NSDictionary <NSString *,NSNumber *>*>*>* warnings;

//@property (nonatomic,strong)BLEManager *bleManager;


@end
