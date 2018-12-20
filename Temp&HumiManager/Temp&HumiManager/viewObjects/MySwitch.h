//
//  MySwitch.h
//  TestSwift
//
//  Created by terry on 2018/3/20.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySwitch : UIControl

@property (nonatomic,strong)UIImageView *thumb;
@property (nonatomic,strong)UIColor *onColor;
@property (nonatomic,strong)UIColor *offColor;
@property (nonatomic,assign)bool isOn;

@end
