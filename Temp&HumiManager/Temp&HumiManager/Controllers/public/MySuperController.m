//
//  MySuperController.m
//  Hoologaner
//
//  Created by terry on 2018/1/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MySuperController.h"

#import "UIImage+DIYImage.h"

@interface MySuperController ()

@end

@implementation MySuperController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.backgroundColor = AuxiliaryColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}


#pragma mark - lazy load
- (MyNavigationBar *)navigationBar{
    if (_navigationBar == nil) {
        _navigationBar = [[MyNavigationBar alloc]init];
        [self.view addSubview:_navigationBar];
        _navigationBar.backgroundColor = [UIColor cyanColor];
        _navigationBar.tintColor = [UIColor whiteColor];
        self.contentFrame = CGRectMake(0, _navigationBar.frame.size.height, MainScreenWidth, MainScreenHeight-_navigationBar.frame.size.height);
    }
    return _navigationBar;
}



/*!
 * 弹出一个alertcontroller，带完成回调
 * @parma interval 自动消失的时间
 */
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)msg DismissTime:(NSTimeInterval)interval Completion:(void (^)(void))completion{
    UIAlertController *alerc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alerc animated:true completion:^{

    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alerc dismissViewControllerAnimated:true completion:completion];
    });
}

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)msg DismissTime:(NSTimeInterval)interval{
    UIAlertController *alerc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alerc animated:true completion:^{

    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alerc dismissViewControllerAnimated:true completion:nil];
    });
}

- (void)showAlertTipTitle:(NSString *)title Message:(NSString *)msg DismissTime:(NSTimeInterval)interval{
    [My_AlertView showInfo:msg Block:^(My_AlertView *infoAlert) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [infoAlert dismiss];
        });
    }];
}

- (void)showNavigationBarEffect{
    UIVisualEffectView *ev1 ;//= [[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, 0, _navigationBar.frame.size.width, _navigationBar.frame.size.height)];
    if (@available(iOS 10.0, *)) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        ev1 = [[UIVisualEffectView alloc] initWithEffect:effect];
    } else {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        ev1 = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    ev1.frame = CGRectMake(0, 0, _navigationBar.frame.size.width, _navigationBar.frame.size.height);

    [_navigationBar insertSubview:ev1 atIndex:0];
}





- (void)setBackgroundGradientColors:(NSArray<UIColor *> *)colors{

    if (colors.count == 0) {
        return ;
    }
    NSMutableArray *newColors = [NSMutableArray array];
    for (int i=0; i<colors.count; i++) {
        UIColor *color = colors[i];
        [newColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *glayer = [CAGradientLayer layer];
    glayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    glayer.colors = newColors;
    glayer.startPoint = CGPointMake(0, 0);
    glayer.endPoint = CGPointMake(0, 1);
    [self.view.layer insertSublayer:glayer atIndex:0];
}


@end
