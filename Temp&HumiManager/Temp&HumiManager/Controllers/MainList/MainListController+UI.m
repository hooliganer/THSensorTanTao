//
//  MainListController+UI.m
//  Temp&HumiManager
//
//  Created by terry on 2018/11/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController+UI.h"
#import "MainListController+BG.h"
#import "MainListController+Extension.h"
#import "MainListController+Tableview.h"
#import "SettingController.h"

@implementation MainListController (UI)

- (void)setupSubviews{

    [self setupNavigation];

    self.bgScroll = [[MyScrollView alloc]initWithFrame:CGRectMake(0, self.navigationBar.height, MainScreenWidth, MainScreenHeight - self.navigationBar.height)];
    [self.view addSubview:self.bgScroll];

    self.groupTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.bgScroll.width, 0) style:UITableViewStylePlain];
    self.groupTable.dataSource = self;
    self.groupTable.delegate = self;
    self.groupTable.tag = 1000;
    self.groupTable.backgroundColor = [UIColor clearColor];
    [self.bgScroll addSubview:self.groupTable];
    [self.groupTable addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    self.groupTable.scrollEnabled = false;

    self.bleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.bgScroll.width, 10) style:UITableViewStylePlain];
    self.bleTable.dataSource = self;
    self.bleTable.delegate = self;
    self.bleTable.tag = 2000;
    self.bleTable.backgroundColor = [UIColor clearColor];
    [self.bgScroll addSubview:self.bleTable];
    [self.bleTable addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    self.bleTable.scrollEnabled = false;

    //禁用每行设置预估行高，防止reload的时候闪动
    if (@available(iOS 11.0, *)) {

        self.bleTable.estimatedRowHeight = 0;
        self.bleTable.estimatedSectionFooterHeight = 0;
        self.bleTable.estimatedSectionHeaderHeight = 0;

        self.groupTable.estimatedRowHeight = 0;
        self.groupTable.estimatedSectionFooterHeight = 0;
        self.groupTable.estimatedSectionHeaderHeight = 0;
    }

}

- (void)setupNavigation{

    self.view.backgroundColor = MainColor;

    self.navigationBar.title = @"SENSOR";

    LRWeakSelf(self);
    [self.navigationBar addActionLeftImage:[UIImage imageNamed:@"ic_setting.png"] Block:^{
        SettingController *set = [[SettingController alloc]init];
        [weakself.navigationController pushViewController:set animated:true];
    }];

    [self.navigationBar addActionRightImage:[UIImage imageNamed:@"ic_reflash.png"] Block:^{

        [weakself.groupDatasource removeAllObjects];
        [weakself.bleDatasource removeAllObjects];

        [weakself.groupTable reloadData];
        [weakself.bleTable reloadData];

        [weakself selectGroupData];
        [weakself selectLocalDevices];
    }];
}

#pragma mark - 事件

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"contentSize"] && [object isKindOfClass:[UITableView class]]) {
        UITableView * table = (UITableView *)object;
        CGRect frame = table.frame;
        frame.size = table.contentSize;
        if (table.tag == 1000) {
            frame.origin.y = 10;
        }
        [UIView animateWithDuration:0.3 animations:^{
            table.frame = frame;
        }];

        self.bleTable.y = self.groupTable.bottomY;

        self.bgScroll.contentSize = CGSizeMake(self.bgScroll.contentSize.width, self.bleTable.bottomY + 10);
    }
}

@end
