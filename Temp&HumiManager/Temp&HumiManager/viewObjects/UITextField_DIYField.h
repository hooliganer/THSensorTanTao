//
//  UITextField_DIYField.h
//  Hoologaner
//
//  Created by terry on 2018/3/4.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, TextFieldStyle) {
    TextFieldStyle_BottomLine = 1,
    TextFieldStyle_BorderLine ,
};

@interface UITextField_DIYField : UITextField

@property (nonatomic,assign)TextFieldStyle style;///<UITextField的样式
@property (nonatomic,strong)UIColor *tintsColor;

@end
