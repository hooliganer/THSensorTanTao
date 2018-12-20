//
//  UIButton_DIYObject.h
//  MedicalTreatmentProject
//
//  Created by 谭滔 on 2017/11/17.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, INIT_STYLE) {
    INIT_STYLE_ScanLogo = 1,//扫描图标
    INIT_STYLE_Left ,//向左的尖括号
    INIT_STYLE_Right ,//向右的尖括号
    INIT_STYLE_Add ,//➕加号
    INIT_STYLE_BlueTooth ,//蓝牙
    INIT_STYLE_Triangle ,//向左的三角形
};

typedef NS_OPTIONS(int, SHOW_STYLE) {
    SHOW_STYLE_Boder = 1 ,
};

@interface UIButton_DIYObject : UIButton

@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,strong)UIColor *tintsColor;

@property (nonatomic,assign)float imageScale;
@property (nonatomic,assign)CGFloat originalScale;

@property (nonatomic,assign)bool canTouchDown;

@property (nonatomic,strong)NSIndexPath *indexPath;///<用于重用视图时区分是哪个

- (instancetype)initWithFrame:(CGRect)frame Style:(INIT_STYLE)style;

- (void)setSizeWithTitle:(NSString *)title;

- (void)showStyle:(SHOW_STYLE)style;



@end
