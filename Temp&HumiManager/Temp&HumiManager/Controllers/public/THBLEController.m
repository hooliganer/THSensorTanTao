//
//  THBLEController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "THBLEController.h"

@interface THBLEController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * mainTable;
@property (nonatomic,strong)NSMutableArray <MyPeripheral *>* datasource;

@end

@implementation THBLEController

- (void)viewDidLoad {
    [super viewDidLoad];

    LRWeakSelf(self);
    [self.navigationBar showBackButton:^{
        [weakself.navigationController popViewControllerAnimated:true];
    }];

    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, MainScreenWidth, MainScreenHeight - self.navigationBar.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTable];
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetBleDevice:) name:NotiName_ToBLEController object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


}

#pragma mark - 事件
- (void)didGetBleDevice:(NSNotification *)notificaion{

    NSMutableArray * marr = [BLEManager shareInstance].discoveredPeripherals;
    self.datasource = [NSMutableArray arrayWithArray:marr];
    LRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [weakself.mainTable reloadData];
    });

}

#pragma mark - TableView Delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * identifer = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }

    cell.textLabel.text = self.datasource[indexPath.row].peripheral.name;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectBlueTooth) {
        self.didSelectBlueTooth(self.datasource[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:true];
}

@end
