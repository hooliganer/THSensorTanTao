//
//  DetailMainScroll.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/25.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailMainScroll.h"

@implementation DetailMainScroll

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    self.warning = !_warning;
//}

- (instancetype)init{
    if (self = [super init]) {
        self.delaysContentTouches = false;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = Fit_X(20.f);

    if (_warning) {
        self.warnAlert.frame = CGRectMake(distance, distance, MainScreenWidth - distance*2.f, Fit_Y(40.0));
    } else {
        self.warnAlert.frame = CGRectZero;
    }

    self.cellView.frame = CGRectMake(distance, _warnAlert.frame.origin.y + _warnAlert.frame.size.height + distance, MainScreenWidth - distance*2.f, Fit_Y(110.0));

    CGFloat yBtm = _cellView.frame.origin.y + _cellView.frame.size.height + distance;
    self.btmView.frame = CGRectMake(distance, yBtm, _cellView.frame.size.width, Fit_Y(440.0));
    self.btmView.layer.cornerRadius = Fit_Y(10.f);

    self.chooseSeg.frame = CGRectMake(0, 0, _btmView.frame.size.width, _btmView.frame.size.height*0.2);

    self.typeView.frame = CGRectMake(distance, _chooseSeg.frame.origin.y +_chooseSeg.frame.size.height + distance/2.0, _btmView.frame.size.width - distance*2.f, Fit_Y(_btmView.frame.size.height*0.1));

    self.tempView.frame = CGRectMake(distance, _typeView.frame.origin.y + _typeView.frame.size.height + distance/2.f, _typeView.frame.size.width, _btmView.frame.size.height - _typeView.frame.origin.y - _typeView.frame.size.height - distance);

    self.humiView.frame = CGRectMake(distance, _typeView.frame.origin.y + _typeView.frame.size.height + distance/2.f, _typeView.frame.size.width, _btmView.frame.size.height - _typeView.frame.origin.y - _typeView.frame.size.height - distance);

    self.warnView.frame = CGRectMake(distance, _typeView.frame.origin.y + _typeView.frame.size.height + distance/2.f, _typeView.frame.size.width, _btmView.frame.size.height - _typeView.frame.origin.y - _typeView.frame.size.height - distance);

    CGFloat yExp = _btmView.frame.origin.y + _btmView.frame.size.height;
    self.btnExport.frame = CGRectMake(distance, yExp + distance/2.0, MainScreenWidth - distance*2.0, Fit_Y(40.0));

    self.contentSize = CGSizeMake(self.frame.size.width, _btnExport.frame.origin.y + _btnExport.frame.size.height + distance/2.0);

}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    return true;
}


- (DetailWarningAlert *)warnAlert{
    if (_warnAlert == nil) {
        _warnAlert = [[DetailWarningAlert alloc]init];
        _warnAlert.backgroundColor = [UIColor colorWithRed:6/255.0 green:42/255.0 blue:51/255.0 alpha:1];
        _warnAlert.layer.masksToBounds = true;
        _warnAlert.layer.cornerRadius = Fit_Y(8.f);
        [_warnAlert addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_warnAlert];
    }
    return _warnAlert;
}

- (DetailCellView *)cellView{
    if (_cellView == nil) {
        _cellView = [[DetailCellView alloc]init];
        _cellView.backgroundColor = [UIColor whiteColor];
        _cellView.layer.masksToBounds = true;
        _cellView.layer.cornerRadius = Fit_Y(8.f);
        [self addSubview:_cellView];
    }
    return _cellView;
}

- (UIView *)btmView{
    if (_btmView == nil) {
        _btmView = [[UIView alloc]init];
        _btmView.layer.masksToBounds = true;
        _btmView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_btmView];
    }
    return _btmView;
}

- (DetailChooseSegment *)chooseSeg{
    if (_chooseSeg == nil) {
        _chooseSeg = [[DetailChooseSegment alloc]init];
        [self.btmView addSubview:_chooseSeg];
    }
    return _chooseSeg;
}

- (DetailTempView *)tempView{
    if (_tempView == nil) {
        _tempView = [[DetailTempView alloc]init];
        [self.btmView addSubview:_tempView];
    }
    return _tempView;
}

- (DetailHumidityView *)humiView{
    if (_humiView == nil) {
        _humiView = [[DetailHumidityView alloc]init];
        [self.btmView addSubview:_humiView];
        _humiView.hidden = true;
    }
    return _humiView;
}

- (DetailTypeChooseView *)typeView{
    if (_typeView == nil) {
        _typeView = [[DetailTypeChooseView alloc]init];
        [self.btmView addSubview:_typeView];
    }
    return _typeView;
}

- (DetailWarningView *)warnView{
    if (_warnView == nil) {
        _warnView = [[DetailWarningView alloc]init];
        _warnView.hidden = true;
        [self.btmView addSubview:_warnView];
    }
    return _warnView;
}

- (UIButton_DIYObject *)btnExport{
    if (_btnExport == nil) {
        _btnExport = [[UIButton_DIYObject alloc]init];
        [_btnExport setTitle:@"EXPORT"];
        _btnExport.labTitle.textColor = [UIColor whiteColor];
        _btnExport.backgroundColor = [UIColor colorWithRed:78/255.0 green:200/255.0 blue:94/255.0 alpha:1];
        _btnExport.layer.masksToBounds = true;
        _btnExport.layer.cornerRadius = Fit_Y(8.0);
        [self addSubview:_btnExport];
    }
    return _btnExport;
}


- (void)setWarning:(bool)warning{
    if (warning == _warning) {
        return ;
    }
    _warning = warning;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)clickButton:(UIButton *)sender{
    self.warning = false;
}

@end
