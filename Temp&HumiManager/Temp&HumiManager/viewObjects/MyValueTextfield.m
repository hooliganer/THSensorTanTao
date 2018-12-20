//
//  MyValueTextfield.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyValueTextfield.h"

#define LineWidth Fit_X(2.f)

@interface MyValueTextfield ()

@property (nonatomic,strong,readwrite)UITextField *textField;
@property (nonatomic,strong,readwrite)UILabel *labValue;

@end

@implementation MyValueTextfield

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];


    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(LineWidth/2.f, LineWidth/2.f, self.frame.size.width - LineWidth, self.frame.size.height - LineWidth) cornerRadius:self.frame.size.height*0.1];
    [self.tintsColor setStroke];
    [path1 setLineWidth:LineWidth];
    [path1 stroke];
    [path1 closePath];

    CGRect recter = _oppisite?CGRectMake(LineWidth, LineWidth, self.frame.size.width * 0.4 - LineWidth, self.frame.size.height - LineWidth * 2.f):CGRectMake(self.frame.size.width*0.6, LineWidth, self.frame.size.width * 0.4 - LineWidth, self.frame.size.height - LineWidth * 2.f);
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:recter];
    [self.tintsColor setFill];
    [path2 fill];

}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGRect rectTF = _oppisite?CGRectMake(self.frame.size.width*0.4, LineWidth, self.frame.size.width * 0.6, self.frame.size.height - LineWidth*2.f):CGRectMake(LineWidth, LineWidth, self.frame.size.width * 0.6, self.frame.size.height - LineWidth*2.f);
    self.textField.frame = rectTF;

    CGRect rectVue = _oppisite?CGRectMake(LineWidth, 0, self.frame.size.width * 0.4, self.frame.size.height):CGRectMake(LineWidth + self.frame.size.width *0.6, 0, self.frame.size.width * 0.4, self.frame.size.height);
    self.labValue.frame = rectVue;
}

- (UIColor *)tintsColor{
    if (_tintsColor == nil) {
        _tintsColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    }
    return _tintsColor;
}

- (UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UILabel *)labValue{
    if (_labValue == nil) {
        _labValue = [[UILabel alloc]init];
        _labValue.font = [UIFont fitSystemFontOfSize:20.f];
        _labValue.textAlignment = NSTextAlignmentCenter;
        _labValue.textColor = [UIColor whiteColor];
        [self addSubview:_labValue];
    }
    return _labValue;
}



@end
