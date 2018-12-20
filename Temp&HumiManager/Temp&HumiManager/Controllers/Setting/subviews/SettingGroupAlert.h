//
//  SettingGroupAlert.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TH_GroupInfo.h"


@interface SettingGroupAlertCell : UITableViewCell

@property (nonatomic,strong)UILabel *labTitle;

@end




@interface SettingGroupAlert : UITableView

@property (nonatomic,strong)NSMutableArray <TH_GroupInfo *>* datasArray;
@property (nonatomic,copy)void(^didSelectRow)(SettingGroupAlert *sgAlert,NSIndexPath *indexPath);

- (void)dismiss;

@end
