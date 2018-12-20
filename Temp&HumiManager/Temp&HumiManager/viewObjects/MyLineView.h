//
//  MyLineView.h
//  TestAll
//
//  Created by terry on 2018/5/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, MyLineType) {
    MyLineType_Beeline , ///<直线
    MyLineType_Curveline , ///<曲线
    MyLineType_BeeCircleLine ,///<直线带圆圈
};

@interface MyLineView : UIView

@property (nonatomic,assign)MyLineType lineType;///<曲线样式

@property (nonatomic,strong)UIColor *bgLineColor;
@property (nonatomic,assign)CGFloat bgLineWidth;
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;

@property (nonatomic,assign)int yCount;///<y轴线的个数
@property (nonatomic,assign)int xCount;///<x轴线的个数,必须和 xValues 数量相同

@property (nonatomic,strong)UIFont *xyFont;

@property (nonatomic,assign)CGFloat btmHeight;
@property (nonatomic,assign)CGFloat leftWidth;
@property (nonatomic,assign)CGFloat topHeight;
@property (nonatomic,assign)CGFloat rightWidth;

@property (nonatomic,copy)NSArray <NSNumber *> *values;///<数值,纵向用到，必须和 xPers个数相同
@property (nonatomic,copy)NSArray <NSString *> *xValues;///<横坐标显示的，数量必须和xCount+1相等
@property (nonatomic,copy)NSArray <NSNumber *> *xPers;///<横坐标对应的百分比，必须和 values个数相同

- (void)cleanAll;

@end
