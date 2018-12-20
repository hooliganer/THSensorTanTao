//
//  My_AlertView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/6/22.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "My_AlertView+My_AlertExtension.h"


/*!
 * 基于UIView的视图弹窗，通过在 keywindow 加入此view呈现
 */
@interface My_AlertView : UIView

@property (nonatomic,strong)UIView *centerView;///< 中心显示视图
@property (nonatomic,assign)My_AlertAnimateType animType;
@property (nonatomic,assign)bool touchDismiss;///< 触摸其他区域自动dismiss

- (void)showBlock:(void(^)(My_AlertView *alertView))block;
- (void)dismiss;

@end
