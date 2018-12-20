//
//  MainListController+Tableview.h
//  Temp&HumiManager
//
//  Created by terry on 2018/11/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainListController.h"

@interface MainListController (Tableview)
<UITableViewDelegate,UITableViewDataSource>

- (void)setupMainTable;

@end
