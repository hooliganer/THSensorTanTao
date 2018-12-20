//
//  LoginController.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "LoginController.h"

#import "UITextField_DIYField.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackgroundGradientColors:@[[UIColor colorWithHexString:@"1e90ff" Alpha:1],
                                        [UIColor colorWithHexString:@"afeeee" Alpha:1]]];
    
    CGFloat distance = Fit_X(20.f);
    UITextField_DIYField *tfName = [[UITextField_DIYField alloc]initWithFrame:CGRectMake(distance, 64+distance, MainScreenWidth - distance*2.f, Fit_Y(60.f))];
    tfName.style = TextFieldStyle_BorderLine;
    tfName.textAlignment = NSTextAlignmentCenter;
    tfName.tintsColor = [UIColor whiteColor];
    tfName.placeholder = @"账户";

    [self.view addSubview:tfName];

    UITextField_DIYField *tfPwd = [[UITextField_DIYField alloc]initWithFrame:CGRectMake(distance, tfName.frame.origin.y + tfName.frame.size.height + distance, MainScreenWidth - distance*2.f, Fit_Y(60.f))];
    tfPwd.placeholder = @"密码";
    tfPwd.textAlignment = NSTextAlignmentCenter;
    tfPwd.tintsColor = [UIColor whiteColor];
    tfPwd.style = TextFieldStyle_BorderLine;
    [self.view addSubview:tfPwd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
