//
//  SettingGroupAlert.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingGroupAlert.h"

@interface SettingGroupAlert ()
<UITableViewDelegate,UITableViewDataSource>

@end


@implementation SettingGroupAlert

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSMutableArray<TH_GroupInfo *> *)datasArray{
    if (_datasArray == nil) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * reuseIdentifer = @"CellID";
    SettingGroupAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (cell == nil) {
        cell = [[SettingGroupAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
    }

    if (indexPath.row == self.datasArray.count) {
        cell.textLabel.text = nil;
        cell.labTitle.text = @"Add New Group";
        [cell.labTitle sizeToFit];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        TH_GroupInfo *gp = [self.datasArray objectAtIndex:indexPath.row];
        cell.textLabel.text = gp.name;
        cell.labTitle.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectRow) {
        self.didSelectRow(self, indexPath);
    }
}

@end


@implementation SettingGroupAlertCell

- (void)layoutSubviews{
    [super layoutSubviews];

    self.labTitle.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        [self.contentView addSubview:_labTitle];
    }
    return _labTitle;
}

@end
