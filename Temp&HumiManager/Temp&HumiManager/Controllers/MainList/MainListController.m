//
//  MainListController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/11/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController.h"
#import "MainListController+Extension.h"
#import "MainListController+UI.h"
#import "MainListController+BG.h"
#import "MyPeripheral.h"
#import "AFManager.h"

@interface MainListController ()


@end

@implementation MainListController

#pragma mark - 重写方法

- (void)viewDidLoad {
    [super viewDidLoad];

    self.groupDatasource = [NSMutableArray array];
    
    self.bleDatasource = [NSMutableArray array];

//    NSMutableDictionary * group = [NSMutableDictionary dictionary];
//    [group setValue:@"组名" forKey:@"gname"];
//    [group setValue:@(false) forKey:@"flex"];
//    [group setValue:@[@(1)] forKey:@"devices"];
//    [self.groupDatasource addObject:group];
//
//    NSMutableDictionary * group1 = [NSMutableDictionary dictionary];
//    [group1 setValue:@"asdf" forKey:@"gname"];
//    [group1 setValue:@(false) forKey:@"flex"];
//    [group1 setValue:@[@(22),@"33",@"",@"",@""] forKey:@"devices"];
//    [self.groupDatasource addObject:group1];


//    testObject * ble = [[testObject alloc]init];
//    ble.name = @"假蓝牙";
//    [self.datasource addObject:ble];

    [self setupSubviews];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self startBlueToothScan];

    [self selectGroupData];
//    [self startTimer];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    

}

#pragma mark - 内部调用方法


@end
