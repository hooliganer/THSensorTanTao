//
//  SettingController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SettingController.h"
#import "SettingController+UI.h"
#import "SettingController+SettingBG.h"
#import "SettingController+SettingExtension.h"



@interface SettingController ()



@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = MainColor;
    self.automaticallyAdjustsScrollViewInsets = false;

    self.navigationBar.title = @"SETTING";
    LRWeakSelf(self);
    [self.navigationBar showBackButton:^{
        [weakself.navigationController popViewControllerAnimated:true];
    }];

    //添加键盘通知
    [self addNotifications];

    [self setupSubviews];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiName_ToBleSetControler object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setLocalInfo];

    [self selectGroups];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    APPGlobalObject *gobc = [[APPGlobalObject alloc]init];
    gobc.wifiName = self.tfWifi.text;
    gobc.wifiPwd = self.tfPwd.text;
    gobc.unitType = self.btn_F.selected;
    gobc.closeSec = [self.tfSecond.textField.text intValue];
    gobc.closeMin = [self.tfMinute.textField.text intValue];
//    gobc.isWifiType = self.btn_wfi.selected;
    [[MyArchiverManager sharedInstance] saveGlobalObject:gobc];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];


    CGFloat distance = Fit_X(20.0);
    CGFloat width = MainScreenWidth - distance*2.0;
    CGFloat top = self.wifiView.topHeight;
    CGFloat h_tf = Fit_Y(50.0);

    self.tfWifi.frame = CGRectMake(width/3.f + distance/2.f, top + distance, width*(2.f/3.f) - distance*2.f, h_tf);

    self.tfPwd.frame = CGRectMake(width/3.f + distance/2.f, _tfWifi.frame.origin.y + _tfWifi.frame.size.height + distance, width*(2.f/3.f) - distance*2.f, h_tf);

    UILabel *labName = [self.wifiView viewWithTag:1];
    if (labName) {
        labName.frame = CGRectMake(0, _tfWifi.frame.origin.y, width/3.f - distance/2.f, _tfWifi.frame.size.height);
    }

    UILabel *labPwd = [self.wifiView viewWithTag:2];
    if (labPwd) {
        labPwd.frame = CGRectMake(0, _tfPwd.frame.origin.y, width/3.f - distance/2.f, _tfPwd.frame.size.height);
    }

    UIButton *btnWifi = [self.wifiView viewWithTag:3];
    btnWifi.frame = CGRectMake(distance, _tfPwd.frame.origin.y + _tfPwd.frame.size.height + distance, width - distance*2.0, h_tf);

    self.wifiView.frame = CGRectMake(distance, distance, width, btnWifi.frame.origin.y + btnWifi.frame.size.height + distance);

    //=====
    UILabel *labTemp = [self.unitView viewWithTag:1];
    if (labTemp) {
        labTemp.frame = CGRectMake(0, distance + top, width/3.f - distance/2.f, _tfPwd.frame.size.height);
    }

    CGFloat wbtn = Fit_X(30.f);
    self.btn_C.frame = CGRectMake(width/2.f, labTemp.center.y - wbtn/2.f, wbtn, wbtn);

    self.btn_F.frame = CGRectMake(width*0.75, labTemp.center.y - wbtn/2.f, wbtn, wbtn);

    UILabel *labC = [self.unitView viewWithTag:4];
    if (labC) {
        labC.center = CGPointMake(_btn_C.frame.origin.x + _btn_C.frame.size.width + labC.bounds.size.width/2.f + distance, _btn_C.center.y);
    }

    UILabel *labF = [self.unitView viewWithTag:5];
    if (labF) {
        labF.center = CGPointMake(_btn_F.frame.origin.x + _btn_F.frame.size.width + labF.bounds.size.width/2.f + distance, _btn_F.center.y);
    }

    self.unitView.frame = CGRectMake(distance, _wifiView.frame.origin.y + _wifiView.frame.size.height + distance, MainScreenWidth - distance*2.f, labTemp.center.y + labTemp.bounds.size.height/2.f + distance);

//    //=====
//    UILabel *labTime = [self.alertView viewWithTag:1];
//    if (labTime) {
//        labTime.center = CGPointMake(distance + labTime.bounds.size.width/2.f, top + distance + labTime.bounds.size.height/2.f);
//    }

//    CGFloat wtime = (width - distance*3.f)/2.f;
//    self.tfSecond.frame = CGRectMake(distance, labTime.frame.origin.y + labTime.frame.size.height + distance, wtime, Fit_Y(50.f));

//    self.tfMinute.frame = CGRectMake(width/2.f + distance/2.f, _tfSecond.frame.origin.y, wtime, Fit_Y(50.f));
//
//    self.alertView.frame = CGRectMake(distance, _unitView.frame.origin.y + _unitView.frame.size.height + distance, MainScreenWidth - distance*2.f, _tfMinute.frame.origin.y + _tfMinute.frame.size.height + distance);

    //=====
//    UILabel *labMode = [self.modeView viewWithTag:11];
//    if (labMode) {
//        labMode.frame = CGRectMake(0, distance + top, width/3.f - distance/2.f, _tfPwd.frame.size.height);
//    }
//
//    CGFloat wbtn1 = Fit_X(30.0);
//    self.btn_wfi.frame = CGRectMake(width/2.f, labMode.center.y - wbtn1/2.f, wbtn1, wbtn1);
//
//    self.btn_ble.frame = CGRectMake(width*0.75, labMode.center.y - wbtn1/2.f, wbtn1, wbtn1);
//
//    UILabel *labwf = [self.modeView viewWithTag:14];
//    if (labwf) {
//        labwf.center = CGPointMake(_btn_wfi.frame.origin.x + _btn_wfi.frame.size.width + labwf.bounds.size.width/2.0 + distance, _btn_wfi.center.y);
//    }
//
//    UILabel *labbl = [self.modeView viewWithTag:15];
//    if (labbl) {
//        labbl.center = CGPointMake(_btn_ble.frame.origin.x + _btn_ble.frame.size.width + labbl.bounds.size.width/2.0 + distance, _btn_ble.center.y);
//    }
//
//    self.modeView.frame = CGRectMake(distance, _alertView.frame.origin.y + _alertView.frame.size.height + distance, width, labMode.center.y + labMode.bounds.size.height/2.0 + distance);

    //=====
//    self.chooseGroup.frame = CGRectMake(distance, self.groupView.topHeight + distance, width - distance*2.0, self.groupView.topHeight);

//    self.groupView.frame = CGRectMake(distance, self.alertView.frame.origin.y + self.alertView.frame.size.height + distance, width, Fit_Y(200.0));
//
//    self.groupTable.frame = CGRectMake(distance, self.groupView.topHeight, self.groupView.frame.size.width - distance*2.0, self.groupView.frame.size.height - self.groupView.topHeight);

//    if (self.btn_wfi.selected) {
//
//        [self.groupView setNeedsDisplay];
//    } else {
//        self.groupView.frame = CGRectMake(distance, _modeView.frame.origin.y + _modeView.frame.size.height + distance, 0, 0);
//    }

//    self.mainScroll.contentSize = CGSizeMake(MainScreenWidth, self.groupView.frame.origin.y + self.groupView.frame.size.height + top);

}



#pragma mark - lazy load
- (NSMutableArray<MyPeripheral *> *)peripherals{
    if (_peripherals == nil) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}


- (SettingCardView *)unitView{
    if (_unitView == nil) {
        _unitView = [[SettingCardView alloc]init];
        _unitView.title = @"UNIT";

        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"Temparature";
        lab.textAlignment = NSTextAlignmentRight;
        lab.tag = 1;
        lab.font = [UIFont fitSystemFontOfSize:20.f];
        [_unitView addSubview:lab];

        UILabel *lab1 = [[UILabel alloc]init];
        lab1.text = @"˚C";
        lab1.textAlignment = NSTextAlignmentRight;
        lab1.tag = 4;
        lab1.font = [UIFont fitSystemFontOfSize:20.f];
        [_unitView addSubview:lab1];
        [lab1 sizeToFit];

        UILabel *lab2 = [[UILabel alloc]init];
        lab2.text = @"˚F";
        lab2.textAlignment = NSTextAlignmentRight;
        lab2.tag = 5;
        lab2.font = [UIFont fitSystemFontOfSize:20.f];
        [_unitView addSubview:lab2];
        [lab2 sizeToFit];

        [_unitView addSubview:self.btn_C];
        [_unitView addSubview:self.btn_F];

        [self.mainScroll addSubview:_unitView];
    }
    return _unitView;
}


- (UITextField_DIYField *)tfPwd{
    if (_tfPwd == nil) {
        _tfPwd = [[UITextField_DIYField alloc]init];
        _tfPwd.style = TextFieldStyle_BorderLine;
        _tfPwd.placeholder = @"Input The Wifi Password";
        _tfPwd.tintsColor = [UIColor lightGrayColor];
    }
    return _tfPwd;
}


- (UIButton *)btn_C{
    if (_btn_C == nil) {
        _btn_C = [[UIButton alloc]init];
        [_btn_C setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];
        [_btn_C addTarget:self action:@selector(clickSelectCircle:) forControlEvents:UIControlEventTouchUpInside];
        _btn_C.tag = 2;
        _btn_C.selected = true;
    }
    return _btn_C;
}

- (UIButton *)btn_F{
    if (_btn_F == nil) {
        _btn_F = [[UIButton alloc]init];
        [_btn_F setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        [_btn_F addTarget:self action:@selector(clickSelectCircle:) forControlEvents:UIControlEventTouchUpInside];
        _btn_F.tag = 3;
        _btn_F.selected = true;
    }
    return _btn_F;
}

- (MyValueTextfield *)tfSecond{
    if (_tfSecond == nil) {
        _tfSecond = [[MyValueTextfield alloc]init];
        _tfSecond.labValue.text = @"S";
    }
    return _tfSecond;
}

- (MyValueTextfield *)tfMinute{
    if (_tfMinute == nil) {
        _tfMinute = [[MyValueTextfield alloc]init];
        _tfMinute.labValue.text = @"M";
    }
    return _tfMinute;
}


#pragma mark ----- Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    CGPoint pit = [touch locationInView:self.groupTable.superview];
    CGRect rect = self.groupTable.frame;

    if (CGRectContainsPoint(rect, pit)) {
        return false;
    }
    return true;
}

#pragma mark - 事件

/*!
 * 点击温度选择圈
 */
- (void)clickSelectCircle:(UIButton *)sender{

    switch (sender.tag) {
        case 2:
        {
            self.btn_C.selected = true;
            [self.btn_C setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];

            self.btn_F.selected = false;
            [self.btn_F setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
        }
            break;

        case 3:
        {
            self.btn_C.selected = false;
            [self.btn_C setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];

            self.btn_F.selected = true;
            [self.btn_F setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];
        }
            break;
//        case 12:
//        {
////            self.btn_wfi.selected = true;
////            [self.btn_wfi setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];
////
////            self.btn_ble.selected = false;
////            [self.btn_ble setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
//
////            self.groupView.hidden = false;
////            [self.view layoutIfNeeded];
////            [self.view setNeedsLayout];
//        }
//            break;
//
//        case 13:
//        {
////            self.btn_wfi.selected = false;
////            [self.btn_wfi setBackgroundImage:[UIImage imageNamed:@"gray_circle"] forState:UIControlStateNormal];
////
////            self.btn_ble.selected = true;
////            [self.btn_ble setBackgroundImage:[UIImage imageNamed:@"cycn_circle"] forState:UIControlStateNormal];
//
//            self.groupView.hidden = true;
//            [self.view layoutIfNeeded];
//            [self.view setNeedsLayout];
//        }
//            break;

        default:
            break;
    }
}



- (void)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 1001:
        {
//            sender.selected = !sender.selected;
//            if (sender.selected) {
//                UIView *superview = sender.superview.superview.superview;
//                CGFloat w = self.chooseGroup.alertTable.frame.size.width;
//                CGFloat h = self.chooseGroup.alertTable.frame.size.height;
//                CGFloat x = sender.superview.superview.frame.origin.x + sender.superview.frame.origin.x + sender.superview.frame.size.width - w;
//                CGFloat y = sender.superview.superview.frame.origin.y + sender.superview.frame.origin.y - h;
//                self.chooseGroup.alertTable.frame = CGRectMake(x, y, w, h);
//                [superview addSubview:self.chooseGroup.alertTable];
//            } else {
//                [self.chooseGroup.alertTable removeFromSuperview];
//            }

        }
            break;

        default:
            break;
    }
}


/**
 * 键盘显示事件
 */
- (void)keyboardWillShow:(NSNotification *)notification {

//    if (self.tfSecond.textField.editing || self.tfMinute.textField.editing) {
//
//        //获取键盘高度，在不同设备上，以及中英文下是不同的
//        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//
//        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//        CGFloat offset = (self.alertView.frame.origin.y+self.alertView.frame.size.height + 10.f) - (self.view.frame.size.height - kbHeight);
//
//        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//        //将视图上移计算好的偏移
//        if(offset > 0) {
//            [UIView animateWithDuration:duration animations:^{
//                self.alertView.center = CGPointMake(self.alertView.center.x, self.view.frame.size.height - kbHeight-self.alertView.bounds.size.height/2.f-5.f);
//            }];
//        }
//    }
}

/**键盘消失事件*/
- (void) keyboardWillHide:(NSNotification *)notify {
////    NSLog(@" ----> %@",notify);
//    // 键盘动画时间
//    NSTimeInterval duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    CGFloat distance = Fit_X(20.f);
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        self.alertView.center = CGPointMake(MainScreenWidth/2.f, _unitView.frame.origin.y + _unitView.frame.size.height + distance + _alertView.frame.size.height/2.f);
//    }];

}

#pragma mark - 键盘通知
- (void)addNotifications{

    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //注册接受蓝牙的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSearchBleWithNotification:) name:NotiName_ToBleSetControler object:nil];
}



#pragma mark - inside method


@end
