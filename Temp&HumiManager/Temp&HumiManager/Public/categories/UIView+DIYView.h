//
//  UIView+DIYView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DIYView)

@property (nonatomic)CGSize size;
@property (nonatomic)CGPoint origin;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat cy;
@property (nonatomic,assign)CGFloat cx;

@property (nonatomic,assign,readonly)CGFloat bottomY;
@property (nonatomic,assign,readonly)CGFloat rightX;

@end
