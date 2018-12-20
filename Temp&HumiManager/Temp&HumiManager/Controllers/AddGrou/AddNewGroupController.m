//
//  AddNewGroupController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/6/22.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AddNewGroupController.h"
#import "HTTP_GroupManager.h"

@interface AddNewGroupController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UILabel *labNoData;

@end

@implementation AddNewGroupController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = MainColor;

    self.navigationBar.title = @"Add Group";
    LRWeakSelf(self);
    [self.navigationBar showBackButton:^{
        [weakself.navigationController popViewControllerAnimated:true];
    }];

    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, MainScreenWidth, MainScreenHeight) style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableview];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.datasArray.count == 0) {
        [self.view insertSubview:self.labNoData atIndex:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)labNoData{
    if (_labNoData == nil) {
        _labNoData = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - self.navigationBar.frame.size.height)];
        _labNoData.textColor = [UIColor whiteColor];
        _labNoData.text = @"No Gate-Deviece Nearby !";
        if (@available(iOS 8.2, *)) {
            _labNoData.font = [UIFont fitSystemFontOfSize:30.0 weight:UIFontWeightBold];
        } else {
            _labNoData.font = [UIFont fitSystemFontOfSize:30.0];
        }
        _labNoData.textAlignment = NSTextAlignmentCenter;
    }
    return _labNoData;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * reuseIdentifer = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifer];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }

    MyPeripheral *peri = [self.datasArray objectAtIndex:indexPath.row];
    cell.textLabel.text = peri.peripheral.name?peri.peripheral.name:@"(nil name)";//@"test";
    cell.detailTextLabel.text = peri.macAddress;//@"test-mac";

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyPeripheral *peri = [self.datasArray objectAtIndex:indexPath.row];

    TH_NormalView *view = [[TH_NormalView alloc]initWithFrame:CGRectMake(0, 0, Fit_X(350), Fit_Y(180.0))];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = true;
    view.layer.cornerRadius = Fit_Y(8.0);
    view.labTitle.text = @"CREATE GROUP";

    UITextField *labMac = [[UITextField alloc]init];
    labMac.text = peri.macAddress;
    labMac.font = [UIFont fitSystemFontOfSize:20.0];
    labMac.textColor = [UIColor blackColor];
    labMac.backgroundColor = [UIColor clearColor];
    CGFloat disX = Fit_X(10.0);
    CGFloat disY = Fit_Y(10.0);
    CGFloat wMid = view.frame.size.width - disX*2.0;
    labMac.frame = CGRectMake(disX, Fit_Y(50.0) + disY, wMid, Fit_Y(50.0));
    labMac.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:labMac];
    labMac.tag = 1000;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"OK" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor mainGrayColor];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = Fit_Y(8.0);
    [view addSubview:btn];
    btn.frame = CGRectMake(disX, labMac.frame.origin.y + labMac.frame.size.height + disY, wMid, Fit_Y(50.0));
    [btn addTarget:self action:@selector(clickOKCreate:) forControlEvents:UIControlEventTouchUpInside];

    My_AlertView *alert = [[My_AlertView alloc]init];
    alert.centerView = view;
    alert.animType = My_AlertAnimateType_Fade;
    alert.touchDismiss = true;
    [alert showBlock:nil];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit_Y(80.0);
}

/*!
 * 确定添加分组
 */
- (void)clickOKCreate:(UIButton *)sender{

    My_AlertView* alert = (My_AlertView *)sender.superview;
    UITextField* tfMac = [alert viewWithTag:1000];
    NSString* mac = tfMac.text;

    LRWeakSelf(alert);
    LRWeakSelf(self);
    MyIndicatorView *indi = [[MyIndicatorView alloc]init];
    indi.labText.text = @"Adding…";
    [indi showBlock:^(MyIndicatorView *indicator) {

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), queue, ^{

            UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
            HTTP_GroupManager *manager = [HTTP_GroupManager shreadInstance];
            [manager linkGroupWithMac:mac Uid:[NSString stringWithFormat:@"%d",user.uid] Pwd:@"123456"];
            manager.didLinkDevice = ^(bool success, NSString *info) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator dismiss];
                    if (success) {
                        [weakalert dismiss];
                    }
                    [weakself showAlertTipTitle:@"Tips" Message:info DismissTime:1.5];
                });
            };
            manager.didGetGroupsFail = ^(NSString *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator dismiss];
                    [weakself showAlertTipTitle:@"Tips" Message:info DismissTime:1.5];
                });
            };

        });

    }];
}


@end
