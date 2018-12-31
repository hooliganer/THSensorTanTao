//
//  DetailEditAlert.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/19.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailEditAlert.h"


@interface DetailEditAlert ()

@property (nonatomic,strong)UILabel *labName;
@property (nonatomic,strong)UILabel *labImage;
@property (nonatomic,strong)UILabel *labAlert;

@property (nonatomic,strong)UIButton *btnBaby;
@property (nonatomic,strong)UIButton *btnBar;
@property (nonatomic,strong)UIButton *btnCar;
@property (nonatomic,strong)UIButton *btnWC;




@end

@implementation DetailEditAlert

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, StatusBarHeight + 44, MainScreenWidth, MainScreenHeight - (StatusBarHeight + 44));
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.hidden = true;
        self.alpha = 0;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = Fit_X(15.0);


    self.labName.frame = CGRectMake(distance, distance, self.frame.size.width*0.18, Fit_Y(50.0));

    self.tfName.frame = CGRectMake(_labName.frame.origin.x + _labName.frame.size.width + distance, _labName.frame.origin.y, self.frame.size.width - (_labName.frame.origin.x + _labName.frame.size.width + distance) - distance, Fit_Y(50.0));

    self.labImage.frame = CGRectMake(distance, _tfName.frame.origin.y + _tfName.frame.size.height + distance, _labName.frame.size.width, _labName.frame.size.height);

    CGFloat wBtn = (self.frame.size.width - distance*4.5 - _labImage.bounds.size.width)/4.0;
    self.btnWC.frame = CGRectMake(_labImage.frame.origin.x + _labImage.frame.size.width + distance, _labImage.frame.origin.y, wBtn, wBtn);

    self.btnCar.frame = CGRectMake(_btnWC.frame.origin.x + _btnWC.frame.size.width + distance/2.0, _labImage.frame.origin.y, wBtn, wBtn);

    self.btnBar.frame = CGRectMake(_btnCar.frame.origin.x + _btnCar.frame.size.width + distance/2.0, _labImage.frame.origin.y, wBtn, wBtn);

    self.btnBaby.frame = CGRectMake(_btnBar.frame.origin.x + _btnBar.frame.size.width + distance/2.0, _labImage.frame.origin.y, wBtn, wBtn);

    self.labAlert.frame = CGRectMake(distance, _btnWC.frame.origin.y + _btnWC.frame.size.height + distance, _labName.frame.size.width, _labName.frame.size.height);

    CGFloat wSwitch = self.frame.size.width/6.5;
    CGFloat hSwitch = _labAlert.frame.size.height*0.6;
    self.switcher.frame = CGRectMake(self.frame.size.width - wSwitch - distance, _labAlert.center.y - hSwitch/2.0, wSwitch, hSwitch);

    self.limitTemp.frame = CGRectMake(_labAlert.frame.origin.x + _labAlert.frame.size.width + distance, _labAlert.frame.origin.y + _labAlert.frame.size.height + distance, self.frame.size.width - (_labAlert.frame.origin.x + _labAlert.frame.size.width + distance) - distance, Fit_Y(40.0));

    self.limitHumi.frame  = CGRectMake(_labAlert.frame.origin.x + _labAlert.frame.size.width + distance, _limitTemp.frame.origin.y + _limitTemp.frame.size.height + distance, self.frame.size.width - (_labAlert.frame.origin.x + _labAlert.frame.size.width + distance) - distance, Fit_Y(40.0));

    CGFloat wSave = (self.frame.size.width - distance*3.0)/2.0;
    self.btnSave.frame = CGRectMake(distance, _limitHumi.frame.origin.y + _limitHumi.frame.size.height + distance, wSave, Fit_Y(40.0));
    self.btnSave.layer.cornerRadius = Fit_Y(8.0);

    self.btnCancel.frame = CGRectMake(distance*2.0 + _btnSave.frame.size.width, _limitHumi.frame.origin.y + _limitHumi.frame.size.height + distance, wSave, Fit_Y(40.0));
    self.btnCancel.layer.cornerRadius = Fit_Y(8.0);

}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.btnSave.frame.origin.y + self.btnSave.frame.size.height + Fit_Y(15.0))];
    [[UIColor whiteColor] setFill];
    [path fill];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    [self.tfName resignFirstResponder];
    [self.limitTemp.tfLess_textField resignFirstResponder];
    [self.limitTemp.tfMore_textField resignFirstResponder];
    [self.limitHumi.tfLess_textField resignFirstResponder];
    [self.limitHumi.tfMore_textField resignFirstResponder];
}

- (UITextField *)tfName{
    if (_tfName == nil) {
        _tfName = [[UITextField alloc]init];
        _tfName.borderStyle = UITextBorderStyleRoundedRect;
        _tfName.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_tfName];
    }
    return _tfName;
}

- (UILabel *)labName{
    if (_labName == nil) {
        _labName = [[UILabel alloc]init];
        _labName.text = @"NAME";
        _labName.textAlignment = NSTextAlignmentCenter;
        _labName.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_labName];
    }
    return _labName;
}

- (UILabel *)labImage{
    if (_labImage == nil) {
        _labImage = [[UILabel alloc]init];
        _labImage.text = @"IMAGE";
        _labImage.textAlignment = NSTextAlignmentCenter;
        _labImage.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_labImage];
    }
    return _labImage;
}

- (UILabel *)labAlert{
    if (_labAlert == nil) {
        _labAlert = [[UILabel alloc]init];
        _labAlert.text = @"ALERTS";
        _labAlert.textAlignment = NSTextAlignmentCenter;
        _labAlert.font = [UIFont fitSystemFontOfSize:20.0];
        [self addSubview:_labAlert];
    }
    return _labAlert;
}



- (UIButton *)btnWC{
    if (_btnWC == nil) {
        _btnWC = [[UIButton alloc]init];
        [_btnWC setBackgroundImage:[UIImage imageNamed:@"ic_room_wc_sel"] forState:UIControlStateNormal];
        [_btnWC addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        _btnWC.selected = true;
        _btnWC.tag = 10;
        [self addSubview:_btnWC];
    }
    return _btnWC;
}

- (UIButton *)btnCar{
    if (_btnCar == nil) {
        _btnCar = [[UIButton alloc]init];
        [_btnCar setBackgroundImage:[UIImage imageNamed:@"ic_room_car"] forState:UIControlStateNormal];
        [_btnCar addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        _btnCar.tag = 11;
        [self addSubview:_btnCar];
    }
    return _btnCar;
}

- (UIButton *)btnBar{
    if (_btnBar == nil) {
        _btnBar = [[UIButton alloc]init];
        [_btnBar setBackgroundImage:[UIImage imageNamed:@"ic_room_bar"] forState:UIControlStateNormal];
        [_btnBar addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        _btnBar.tag = 12;
        [self addSubview:_btnBar];
    }
    return _btnBar;
}

- (UIButton *)btnBaby{
    if (_btnBaby == nil) {
        _btnBaby = [[UIButton alloc]init];
        [_btnBaby setBackgroundImage:[UIImage imageNamed:@"ic_room_baby"] forState:UIControlStateNormal];
        [_btnBaby addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        _btnBaby.tag = 13;
        [self addSubview:_btnBaby];
    }
    return _btnBaby;
}

- (MySwitch *)switcher{
    if (_switcher == nil) {
        _switcher = [[MySwitch alloc]init];
        _switcher.thumb.backgroundColor = [UIColor whiteColor];
        _switcher.onColor = MainColor;
        [self addSubview:_switcher];
    }
    return _switcher;
}

- (DetailLimitView *)limitTemp{
    if (_limitTemp == nil) {
        _limitTemp = [[DetailLimitView alloc]init];
        _limitTemp.imvHead.image = [UIImage imageNamed:@"tempar"];
        _limitTemp.labUnit.text = @"˚F";
        [self addSubview:_limitTemp];
    }
    return _limitTemp;
}

- (DetailLimitView *)limitHumi{
    if (_limitHumi == nil) {
        _limitHumi = [[DetailLimitView alloc]init];
        _limitHumi.imvHead.image = [UIImage imageNamed:@"humidity"];
        _limitHumi.labUnit.text = @"%";
        [self addSubview:_limitHumi];
    }
    return _limitHumi;
}

- (UIButton_DIYObject *)btnSave{
    if (_btnSave == nil) {
        _btnSave = [[UIButton_DIYObject alloc]init];
        _btnSave.title = @"Save";
        _btnSave.backgroundColor = MainColor;
        _btnSave.labTitle.textColor = [UIColor whiteColor];
        _btnSave.layer.masksToBounds = true;
        _btnSave.canTouchDown = true;
        [self addSubview:_btnSave];
        _btnSave.tag = 20;
    }
    return _btnSave;
}

- (UIButton_DIYObject *)btnCancel{
    if (_btnCancel == nil) {
        _btnCancel = [[UIButton_DIYObject alloc]init];
        _btnCancel.canTouchDown = true;
        _btnCancel.title = @"Cancel";
        _btnCancel.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _btnCancel.labTitle.textColor = [UIColor whiteColor];
        _btnCancel.layer.masksToBounds = true;
        [self addSubview:_btnCancel];
        _btnCancel.tag = 21;
    }
    return _btnCancel;
}






#pragma mark - set method
- (void)setType:(int)type{
    _type = type;

    [self.btnWC setBackgroundImage:[UIImage imageNamed:(type==0)?@"ic_room_wc_sel":@"ic_room_wc"] forState:UIControlStateNormal];
    [self.btnCar setBackgroundImage:[UIImage imageNamed:(type==1)?@"ic_room_car_sel":@"ic_room_car"] forState:UIControlStateNormal];
    [self.btnBar setBackgroundImage:[UIImage imageNamed:(type==2)?@"ic_room_bar_sel":@"ic_room_bar"] forState:UIControlStateNormal];
    [self.btnBaby setBackgroundImage:[UIImage imageNamed:(type==3)?@"ic_room_baby_sel":@"ic_room_baby"] forState:UIControlStateNormal];

    self.btnWC.selected = type==0;
    self.btnCar.selected = type==1;
    self.btnBar.selected = type==2;
    self.btnBaby.selected = type==3;

}


#pragma mark - events
- (void)clickImage:(UIButton *)sender{

    if (sender.selected) {
        return ;
    }

//    [self.btnWC setBackgroundImage:[UIImage imageNamed:(sender.tag==self.btnWC.tag)?@"ic_room_wc_sel":@"ic_room_wc"] forState:UIControlStateNormal];
//    [self.btnCar setBackgroundImage:[UIImage imageNamed:(sender.tag==self.btnCar.tag)?@"ic_room_car_sel":@"ic_room_car"] forState:UIControlStateNormal];
//    [self.btnBar setBackgroundImage:[UIImage imageNamed:(sender.tag==self.btnBar.tag)?@"ic_room_bar_sel":@"ic_room_bar"] forState:UIControlStateNormal];
//    [self.btnBaby setBackgroundImage:[UIImage imageNamed:(sender.tag==self.btnBaby.tag)?@"ic_room_baby_sel":@"ic_room_baby"] forState:UIControlStateNormal];
//
//    self.btnWC.selected = sender.tag==self.btnWC.tag;
//    self.btnCar.selected = sender.tag==self.btnCar.tag;
//    self.btnBaby.selected = sender.tag==self.btnBaby.tag;
//    self.btnBar.selected = sender.tag==self.btnBar.tag;

    self.type = (int)sender.tag - 10;
}




#pragma mark - outside method
- (void)show{
    self.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = true;
    }];
    [self.tfName resignFirstResponder];
    [self.limitTemp.tfLess_textField resignFirstResponder];
    [self.limitTemp.tfMore_textField resignFirstResponder];
    [self.limitHumi.tfLess_textField resignFirstResponder];
    [self.limitHumi.tfMore_textField resignFirstResponder];
}

@end
