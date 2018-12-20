//
//  MyLineView.m
//  TestAll
//
//  Created by terry on 2018/5/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyLineView.h"


@interface MyLineCircleView : UIView

@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,strong)UIColor *centerColor;

@end

@interface MyLineView ()

@property (nonatomic,strong)NSMutableArray <UILabel *> *xLabels;
@property (nonatomic,strong)NSMutableArray <UILabel *> *yLabels;
@property (nonatomic,strong)NSMutableArray <MyLineCircleView *> *circleViews;

@end

@implementation MyLineView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    [self drawXLine];
    [self drawYLine];
    [self reCreateYLabel];
    [self reCreateXLabel];
    [self drawValueLine];
}

#pragma mark ----- inside method
/*!
 * 画横线
 */
- (void)drawXLine{

    //每条横线间距
    CGFloat unitH = (self.frame.size.height - self.btmHeight - self.bgLineWidth - self.topHeight)/floor(self.yCount);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.bgLineWidth;
    [self.bgLineColor setStroke];
    for (int i = 0; i<self.yCount; i++) {
        CGFloat y = self.bgLineWidth / 2.0 + i*unitH + self.topHeight;
        [path moveToPoint:CGPointMake(self.leftWidth, y)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - self.rightWidth, y)];
    }
    [path moveToPoint:CGPointMake(self.leftWidth, self.frame.size.height - self.btmHeight - self.bgLineWidth/2.0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.rightWidth, self.frame.size.height - self.btmHeight - self.bgLineWidth/2.0)];
    [path stroke];
}

/* 画纵线 */
- (void)drawYLine{
    //每条纵线间距
    CGFloat unitW = (self.frame.size.width - self.leftWidth - self.bgLineWidth - self.rightWidth)/floor(self.xCount);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.bgLineWidth;
    [self.bgLineColor setStroke];
    for (int i = 0; i<self.xCount; i++) {
        CGFloat x = self.frame.size.width - self.bgLineWidth / 2.0 - i*unitW - self.rightWidth;
        [path moveToPoint:CGPointMake(x, self.topHeight)];
        [path addLineToPoint:CGPointMake(x, self.frame.size.height - self.btmHeight)];
    }
    [path moveToPoint:CGPointMake(self.leftWidth + self.bgLineWidth/2.0, self.topHeight)];
    [path addLineToPoint:CGPointMake(self.leftWidth + self.bgLineWidth/2.0, self.frame.size.height - self.btmHeight)];
    [path stroke];
}

/*!
 * 创建纵坐标值
 */
- (void)reCreateYLabel{

    //移除旧的纵坐标值
    for (UILabel *lab in self.yLabels) {
        if (lab) {
            [lab removeFromSuperview];
        }
    }
    [self.yLabels removeAllObjects];

    if (self.yCount == 0 || self.values.count == 0) {
        return ;
    }

    //取得最值
    CGFloat maxY = [[self.values maxNumber] floatValue];
    CGFloat minY = [[self.values minNumber] floatValue];

    //纵坐标单元格长度
    CGFloat unitH = (self.frame.size.height - self.btmHeight - self.bgLineWidth - self.topHeight)/floor(self.yCount);
    //纵坐标单元格数值
    CGFloat unitValue = (maxY - minY)/floor(self.yCount);
    if (maxY == minY) {
        unitValue = maxY;
    }

    for (int i=0; i<self.yCount+1; i++) {
        NSString *str = [NSString stringWithFormat:@"%.1f",i*unitValue + minY];
        if (i == self.yCount){
            str = [NSString stringWithFormat:@"%.1f",maxY];
        }
        UILabel *lab = [[UILabel alloc]init];
        lab.textColor = self.bgLineColor;
        lab.text = str;
        lab.font = self.xyFont;
        [lab sizeToFit];
        lab.center = CGPointMake(self.leftWidth/2.f, self.frame.size.height - self.btmHeight - i*unitH);
        [self addSubview:lab];
        [self.yLabels addObject:lab];
    }
}

/*!
 * 创建横坐标值
 */
- (void)reCreateXLabel{

    //移除旧的横坐标值
    for (UILabel *lab in self.xLabels) {
        if (lab) {
            [lab removeFromSuperview];
        }
    }
    [self.xLabels removeAllObjects];

//    NSLog(@"%@ %d",self.xValues,self.xCount);
    if (self.xCount == 0 || self.xValues.count == 0 || (self.xValues.count != (self.xCount+1))) {
        return ;
    }

    //横坐标单元格长度
    CGFloat unitW = (self.frame.size.width - self.leftWidth - self.bgLineWidth - self.rightWidth)/floor(self.xCount);

    for (int i=0; i<self.xValues.count; i++) {
        UILabel *lab = [[UILabel alloc]init];
        lab.textColor = self.bgLineColor;
        lab.text = self.xValues[i];
        lab.font = self.xyFont;
        [lab sizeToFit];
        lab.center = CGPointMake(self.leftWidth + self.bgLineWidth/2.0 + i*unitW, self.frame.size.height - self.btmHeight/2.0);
        [self addSubview:lab];
        [self.xLabels addObject:lab];
    }
}

/*!
 * 画数值线
 */
- (void)drawValueLine{

    if (self.values.count < 1 || (self.values.count != self.xPers.count)) {
        return ;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [self.lineColor set];
    [path setLineWidth:self.lineWidth];

    CGFloat maxY = [[self.values maxNumber] floatValue];
    CGFloat minY = [[self.values minNumber] floatValue];

    [self cleanAllCircles];

    for (int i=0; i<self.values.count; i++) {

//        NSLog(@"%@",self.values);
//        NSLog(@"maxY:%f minY:%f",maxY,minY);
        CGFloat yvalue = [self.values[i] floatValue];

        CGFloat percentY = (yvalue - minY)/(maxY - minY);
        if (maxY == minY) {
            percentY = maxY==0?0:1;
        }
        CGFloat percentX = [self.xPers[i] floatValue];
//        NSLog(@"px : %f  py : %f",percentX,percentY);

        CGFloat y = self.topHeight + (self.frame.size.height - self.btmHeight - self.topHeight) * (1-percentY);
        CGFloat x = self.leftWidth + self.bgLineWidth/2.0 + (self.frame.size.width - self.leftWidth - self.rightWidth - self.bgLineWidth) * percentX;

//        NSLog(@"%f %f",x,y);

        if (i == 0) {
            [path moveToPoint:CGPointMake(x, y)];
            switch (self.lineType) {
                case MyLineType_BeeCircleLine:
                    [self createACircleWithWidth:self.lineWidth*4.0 X:x Y:y];
                    break;

                default:
                    break;
            }
        } else{

            CGFloat yvalue1 = [self.values[i-1] floatValue];

            CGFloat percentY1 = (yvalue1 - minY)/(maxY - minY);
            CGFloat percentX1 = [self.xPers[i-1] floatValue];

            CGFloat y1 = self.topHeight + (self.frame.size.height - self.btmHeight - self.topHeight) * (1-percentY1);
            CGFloat x1 = self.leftWidth + self.bgLineWidth/2.0 + (self.frame.size.width - self.leftWidth - self.rightWidth - self.bgLineWidth) * percentX1;

            switch (self.lineType) {
                case MyLineType_Beeline:
                    [path addLineToPoint:CGPointMake(x, y)];
                    break;
                case MyLineType_Curveline:
                    [path addCurveToPoint:CGPointMake(x, y)
                            controlPoint1:[self controlPoint1WithEndPoint:CGPointMake(x, y) StartPoint:CGPointMake(x1, y1)]
                            controlPoint2:[self controlPoint2WithEndPoint:CGPointMake(x, y) StartPoint:CGPointMake(x1, y1)]];
                    break;
                case MyLineType_BeeCircleLine:
                    [path addLineToPoint:CGPointMake(x, y)];
                    [self createACircleWithWidth:self.lineWidth*4.0 X:x Y:y];
                    break;

                default:
                    break;
            }
        }
    }
    [path stroke];
}


- (void)cleanAll{

    //移除旧的纵坐标值
    for (UILabel *lab in self.yLabels) {
        if (lab) {
            [lab removeFromSuperview];
        }
    }
    [self.yLabels removeAllObjects];

    //移除旧的x坐标值
    for (UILabel *lab in self.xLabels) {
        if (lab) {
            [lab removeFromSuperview];
        }
    }
    [self.xLabels removeAllObjects];

    self.values = nil;
    self.xValues = nil;
    self.xPers = nil;

    [self cleanAllCircles];

    [self setNeedsDisplay];

}

- (void)cleanAllCircles{
    for (MyLineCircleView *mlcv in self.circleViews) {
        [mlcv removeFromSuperview];
    }
    [self.circleViews removeAllObjects];
}




#pragma mark ----- lazy load
- (UIColor *)bgLineColor{
    if (_bgLineColor == nil) {
        _bgLineColor = [UIColor grayColor];
    }
    return _bgLineColor;
}

- (UIColor *)lineColor{
    if (_lineColor == nil) {
        _lineColor = [UIColor redColor];
    }
    return _lineColor;
}

- (CGFloat)lineWidth{
    if (_lineWidth == 0) {
        _lineWidth = 1.0;
    }
    return _lineWidth;
}

- (CGFloat)bgLineWidth{
    if (_bgLineWidth == 0) {
        _bgLineWidth = 1.0;
    }
    return _bgLineWidth;
}

- (UIFont *)xyFont{
    if (_xyFont == nil) {
        _xyFont = [UIFont systemFontOfSize:20.0];
    }
    return _xyFont;
}

- (NSMutableArray <UILabel *> *)xLabels{
    if (_xLabels == nil) {
        _xLabels = [NSMutableArray array];
    }
    return _xLabels;
}

- (NSMutableArray <UILabel *> *)yLabels{
    if (_yLabels == nil) {
        _yLabels = [NSMutableArray array];
    }
    return _yLabels;
}

- (NSMutableArray <MyLineCircleView *> *)circleViews{
    if (_circleViews == nil) {
        _circleViews = [NSMutableArray array];
    }
    return _circleViews;
}



- (void)createACircleWithWidth:(CGFloat)w X:(CGFloat)x Y:(CGFloat)y{

    MyLineCircleView *circle = [[MyLineCircleView alloc]initWithFrame:CGRectMake(x - w/2.0, y - w/2.0, w, w)];
    circle.lineColor = self.lineColor;
    circle.lineWidth = self.lineWidth;
    circle.centerColor = [UIColor whiteColor];
    circle.backgroundColor = [UIColor clearColor];
    [self addSubview:circle];
    [self.circleViews addObject:circle];
}

/* 贝塞尔曲线的控制点1 */
- (CGPoint)controlPoint1WithEndPoint:(CGPoint)epoint StartPoint:(CGPoint)spoint{

    return CGPointMake(spoint.x + (epoint.x - spoint.x)/2.f, spoint.y);
}

/* 贝塞尔曲线的控制点2 */
- (CGPoint)controlPoint2WithEndPoint:(CGPoint)epoint StartPoint:(CGPoint)spoint{
    return CGPointMake(spoint.x + (epoint.x - spoint.x)/2.f, epoint.y);
}

@end





@implementation MyLineCircleView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.lineWidth/2.0, self.lineWidth/2.0, self.frame.size.width - self.lineWidth, self.frame.size.height - self.lineWidth) cornerRadius:(self.frame.size.height - self.lineWidth)/2.0];
    [path setLineWidth:self.lineWidth];
    [self.lineColor setStroke];
    [path stroke];

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.lineWidth, self.lineWidth, self.frame.size.width - self.lineWidth*2.0, self.frame.size.height - self.lineWidth*2.0) cornerRadius:(self.frame.size.height - self.lineWidth*2.0)/2.0];
    [self.centerColor setFill];
    [path1 fill];

}

@end


