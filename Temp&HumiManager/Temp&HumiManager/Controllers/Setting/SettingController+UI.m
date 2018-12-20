//
//  SettingController+UI.m
//  Temp&HumiManager
//
//  Created by terry on 2018/12/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingController+UI.h"
#import "SettingController+SettingExtension.h"
#import "SettingController+SettingBG.h"

#import "THBLEController.h"

@implementation SettingController (UI)

- (void)setupSubviews{

    self.mainScroll = [[MyScrollView alloc]initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, MainScreenWidth, MainScreenHeight - self.navigationBar.frame.size.height)];
    [self.view insertSubview:self.mainScroll atIndex:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    [self.mainScroll addGestureRecognizer:tap];

    [self setwifiView];

}

- (void)setwifiView{

    self.wifiView = [[SettingCardView alloc]initWithFrame:CGRectMake(10, 10, self.mainScroll.frame.size.width - 20, 0)];
    [self.mainScroll addSubview:self.wifiView];
    self.wifiView.title = @"WIFI";

    [self settfWifi];

    [self.wifiView addSubview:self.tfPwd];

    UILabel *labName = [[UILabel alloc]init];
    labName.text = @"Name";
    labName.tag = 1;
    labName.textAlignment = NSTextAlignmentRight;
    labName.font = [UIFont fitSystemFontOfSize:20.0];
    [self.wifiView addSubview:labName];

    UILabel *labPwd = [[UILabel alloc]init];
    labPwd.text = @"Password";
    labPwd.textAlignment = NSTextAlignmentRight;
    labPwd.tag = 2;
    labPwd.font = [UIFont fitSystemFontOfSize:20.f];
    [self.wifiView addSubview:labPwd];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = AuxiBlackColor;
    [btn setTitle:@"Configure Wifi" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.wifiView addSubview:btn];
    btn.tag = 3;
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = Fit_Y(8.0);
    [btn addTarget:self action:@selector(clickSetWifi) forControlEvents:UIControlEventTouchUpInside];

}

- (void)settfWifi{

    self.tfWifi = [[UITextField_DIYField alloc]init];
    self.tfWifi.style = TextFieldStyle_BorderLine;
    self.tfWifi.placeholder = @"Input The Wifi Name";
    self.tfWifi.tintsColor = [UIColor lightGrayColor];
    [self.wifiView addSubview:self.tfWifi];
    self.tfWifi.tag = 100;
    self.tfWifi.delegate = self;

    self.wifiTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.mainScroll addSubview:self.wifiTable];
    self.wifiTable.dataSource = self;

    UITapGestureRecognizer *gesWifi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTextfield:)];
    [self.tfWifi addGestureRecognizer:gesWifi];
}



#pragma mark - 事件区域

/*!
 * 点击设置Wi-Fi按钮
 */
- (void)clickSetWifi{

    LRWeakSelf(self);
    THBLEController * thb = [[THBLEController alloc]init];
    [self.navigationController pushViewController:thb animated:true];
    thb.didSelectBlueTooth = ^(MyPeripheral *periInfo) {

        [weakself executeSetWifiWithDevice:periInfo];
    };

}

/**
 点击背景区域

 @param gesture 手势
 */
- (void)tapGesture:(UIGestureRecognizer *)gesture{

    [self.tfWifi resignFirstResponder];
    [self.tfPwd resignFirstResponder];
    [self.tfSecond.textField resignFirstResponder];
    [self.tfMinute.textField resignFirstResponder];

}

- (void)tapTextfield:(UIGestureRecognizer *)gesture{
    if (gesture.view.tag == 100) {

        self.tfWifi.selected = !self.tfWifi.selected;

        CGFloat x;
        CGFloat y;
        CGFloat w;
        CGFloat h;
        x = self.wifiView.frame.origin.x + self.tfWifi.frame.origin.x;
        y = self.wifiView.frame.origin.y + self.tfWifi.frame.origin.y + self.tfWifi.height;
        w = self.tfWifi.frame.size.width;
        h = self.tfWifi.selected ? 100 : 0;
        self.wifiTable.frame = CGRectMake(x, y, w, h);

    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        return false;
    }
    return true;
}

#pragma mark - tableview delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString * identifer = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
