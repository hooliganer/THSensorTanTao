//
//  MainListController+Extension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/11/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController.h"
#import "MyScrollView.h"
#import "BLEManager.h"

typedef NS_OPTIONS(NSInteger, MainListTag) {
    MainListTag_MainCollection = 100 ,
};

@interface MainListController ()

@property (nonatomic,strong)UIScrollView * bgScroll;

@property (nonatomic,strong)UITableView * groupTable;
@property (nonatomic,strong)UITableView * bleTable;

@property (nonatomic,strong)NSMutableArray <NSMutableDictionary *>* groupDatasource;
@property (nonatomic,strong)NSMutableArray <NSMutableDictionary *>* bleDatasource;

@property (nonatomic,strong)UITableView * mainTable;

@property (nonatomic,strong)dispatch_source_t timer1;


//@property (nonatomic,strong)NSMutableArray <NSObject *>* datasource;

@end
