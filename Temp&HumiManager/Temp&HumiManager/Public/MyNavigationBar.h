//
//  MyNavigationBar.h
//  MedicalTreatmentProject
//
//  Created by 谭滔 on 2017/8/17.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, Navigation_Action_Type) {
    Navigation_Action_Type_Add ,//加号
};

@protocol MyNavigationBarDelegate <NSObject>

@optional

/**
 * 点击了按钮，从右往左数第几个
 */
- (void)didSelectNavigationButtonNumber:(NSInteger)number;

@end

@interface MyNavigationBar : UIView

@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIColor *tintColor;
@property (nonatomic,strong,readonly)UIView *btmLine;

@property (nonatomic,weak)id<MyNavigationBarDelegate>delegate;


- (instancetype)initWithTitle:(NSString *)title;

/**
 * 显示返回的尖括号按钮
 */
- (void)showBackButton:(void(^)(void))clickBlock;

/**
 * 右侧添加按钮
 */
- (void)addActionRightWithType:(Navigation_Action_Type)type Block:(void(^)(void))block;
/**
 * 左侧添加按钮
 */
- (void)addActionLeftWithType:(Navigation_Action_Type)type Block:(void(^)(void))block;

- (void)addActionLeftTitle:(NSString *)title Block:(void(^)(void))block;
- (void)addActionLeftImage:(UIImage *)image Block:(void(^)(void))block;

- (void)addActionRightTitle:(NSString *)title Block:(void(^)(void))block;
- (void)addActionRightImage:(UIImage *)image Block:(void(^)(void))block;

- (void)removeRightActionWithIndex:(NSInteger)index;
- (void)removeLeftActionWithIndex:(NSInteger)index;

@end
