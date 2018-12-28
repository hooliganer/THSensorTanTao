//
//  THLineView.m
//  TestOC
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 tantao. All rights reserved.
//

#import "THLineView.h"

@interface THLineView ()

@property (nonatomic,strong)CALayer * bgLineLayer;
@property (nonatomic,strong)CALayer * lineLayer;

@end

@implementation THLineView

#pragma mark - 重写
- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

#pragma mark - 懒加载


#pragma mark - 外部方法
- (void)reDrawWithX:(float)x Y:(float)y Values:(nullable NSArray<NSNumber *> *)values{
    
    [self.bgLineLayer removeFromSuperlayer];
    [self.lineLayer removeFromSuperlayer];
    
    [self drawX:x Y:y];
    
    [self drawValues:values];
    
}



#pragma mark - 私有方法

- (void)drawValues:(NSArray<NSNumber *> *)values{
    
    if (values.count <= 1) {
        return ;
    }
    
    //每个点横间距
    CGFloat unitW = self.frame.size.width/(values.count - 1.0);//(self.frame.size.width - self.bgLineWidth*values.count)/(values.count - 1.0);
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    CGMutablePathRef path =  CGPathCreateMutable();
//    CGPathRef path = CGPathCreateWithRoundedRect(self.frame, 1, 2, nil);
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[self.lineColor CGColor]];
    layer.lineWidth = self.lineWidth ;
    CGPoint tempPoint = CGPointZero;
    for (int i = 0; i<values.count; i++) {
        
        CGFloat x = unitW * i;//self.lineWidth/2.0 + (unitW + self.lineWidth)*i;
        CGFloat y = [values[i] floatValue];
        y = y > 1 ? 1 : y;
        y = y < 0 ? 0 : y;
        y = (1 - y) * self.frame.size.height;
        
        if (i == 0) {
            CGPathMoveToPoint(path, nil, x, y);
        } else {
            switch (self.type) {
                case THLineType_Curveline:
                {
                    CGPoint p1 = [self controlPoint1WithStartPoint:tempPoint EndPoint:CGPointMake(x, y)];
                    CGPoint p2 = [self controlPoint2WithStartPoint:tempPoint EndPoint:CGPointMake(x, y)];
                    CGPathAddCurveToPoint(path, nil, p1.x, p1.y, p2.x, p2.y, x, y);
                }
                    break;
                    
                default:
                {
                    CGPathAddLineToPoint(path, nil, x, y);
                }
                    break;
            }
        }
        tempPoint = CGPointMake(x, y);
    }
    [layer setPath:path];
    
    //动画
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.duration = 1;
    [layer addAnimation:anim forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    CGPathRelease(path);
    
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer insertSublayer:layer atIndex:1];
    self.lineLayer = layer;
    
}

- (void)drawX:(float)x Y:(float)y{
    
    if (x <= 1 || y <= 1) {
        return ;
    }
    //每条纵线间距
    CGFloat unitW = (self.frame.size.width - self.bgLineWidth*x)/(x - 1.0);
    //每条横线间距
    CGFloat unitH = (self.frame.size.height - self.bgLineWidth*y)/(y - 1.0);
    /*
     *画实线
     */
    CAShapeLayer * layer = [CAShapeLayer layer];
    CGMutablePathRef path =  CGPathCreateMutable();
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setStrokeColor:[self.bgLineColor CGColor]];
    layer.lineWidth = self.bgLineWidth ;
    for (int i = 0; i<x; i++) {
        CGFloat x1 = self.bgLineWidth/2.0 + (unitW + self.bgLineWidth)*i;
        CGPathMoveToPoint(path, nil, x1, 0);
        CGPathAddLineToPoint(path, nil, x1, self.frame.size.height);
    }
    for (int i = 0; i<y; i++) {
        CGFloat y1 = self.bgLineWidth/2.0 + (unitH + self.bgLineWidth)*i;
        CGPathMoveToPoint(path, nil, 0, y1);
        CGPathAddLineToPoint(path, nil, self.frame.size.width, y1);
    }
    [layer setPath:path];
    CGPathRelease(path);
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer insertSublayer:layer atIndex:0];
    self.bgLineLayer = layer;
}


/* 贝塞尔曲线的控制点1 */
- (CGPoint)controlPoint1WithStartPoint:(CGPoint)spoint EndPoint:(CGPoint)epoint{
    
    return CGPointMake(spoint.x + (epoint.x - spoint.x)/2.f, spoint.y);
}

/* 贝塞尔曲线的控制点2 */
- (CGPoint)controlPoint2WithStartPoint:(CGPoint)spoint EndPoint:(CGPoint)epoint{
    return CGPointMake(spoint.x + (epoint.x - spoint.x)/2.f, epoint.y);
}

@end

