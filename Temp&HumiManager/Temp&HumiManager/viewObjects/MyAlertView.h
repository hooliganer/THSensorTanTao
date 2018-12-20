//
//  MyAlertView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/23.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TH_LableImvView.h"

@interface MyAlertView : UIView

@property (nonatomic,strong,readonly)UIView *tempView;

+ (MyAlertView *)shreadInstance;

- (void)dismiss;

/*!
 * 显示带两个textfield的框
 */
- (void)showTH_TFAlertWithPlaceHolder1:(NSString *)plhd1 PlaceHolder2:(NSString *)plhd2 Title:(NSString *)title DetailInfo:(NSString *)detailIfno Confirm:(NSString *)confirm ConfirmBlcok:(void(^)(MyAlertView *alertview,UITextField *textField1,UITextField *textField2,UILabel *labTips))block;

- (void)showTitle:(NSString *)title Message:(NSString *)msg DissTime:(NSTimeInterval)time;

- (void)showWarnTitle:(NSString *)title confirm:(NSString *)confirm image1s:(NSArray <UIImage *>*)image1s image2s:(NSArray <UIImage *>*)image2s text1s:(NSArray <NSString *>*)text1s text1s:(NSArray <NSString *>*)text2s confirmBlock:(void(^)(MyAlertView *alertView))block;

- (void)showTHLITitle:(NSString *)title confirm:(NSString *)confirm confirmBlock:(void(^)(MyAlertView *alertView))block THLIViews:(TH_LableImvView *)firstView,... NS_REQUIRES_NIL_TERMINATION;

- (void)showTHLITitle:(NSString *)title confirm:(NSString *)confirm confirmBlock:(void(^)(MyAlertView *alertView))block THLIViewArray:(NSArray<TH_LableImvView *>*)views;

@end
