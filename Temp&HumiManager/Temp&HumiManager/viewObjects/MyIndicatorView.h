//
//  MyIndicatorView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIndicatorView : UIView

@property (nonatomic,strong)UILabel *labText;

- (void)show;

- (void)showBlock:(void(^)(MyIndicatorView *indicator))block;

- (void)dismiss;

@end
