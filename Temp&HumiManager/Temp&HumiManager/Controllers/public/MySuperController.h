//
//  MySuperController.h
//  Hoologaner
//
//  Created by terry on 2018/1/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyIndicatorView.h"
#import "MyNavigationBar.h"


@interface MySuperController : UIViewController

@property (nonatomic,strong)MyNavigationBar *navigationBar;
@property (nonatomic)CGRect contentFrame;

- (void)showNavigationBarEffect;

- (void)setBackgroundGradientColors:(NSArray<UIColor *> *)colors;

/*!
 * 弹出一个alertcontroller，不带完成回调
 * @parma interval 自动消失的时间
 */
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)msg DismissTime:(NSTimeInterval)interval;

/*!
 * 弹出一个alertcontroller，带完成回调
 * @parma interval 自动消失的时间
 */
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)msg DismissTime:(NSTimeInterval)interval Completion: (void(^)(void))completion;

/*!
 * 添加一个视图
 */
- (void)showAlertTipTitle:(NSString *)title Message:(NSString *)msg DismissTime:(NSTimeInterval)interval;


@end
