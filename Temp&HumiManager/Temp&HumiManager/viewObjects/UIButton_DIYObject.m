//
//  UIButton_DIYObject.m
//  MedicalTreatmentProject
//
//  Created by 谭滔 on 2017/11/17.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "UIButton_DIYObject.h"

#import "UIFont+DIYFont.h"
#import <objc/runtime.h>

@interface UIButton_DIYObject ()

@property (nonatomic,assign)INIT_STYLE currentStyle;
@property (nonatomic,assign)SHOW_STYLE currentShowStyle;

@property(nonatomic,weak)id targetDown;///<目标(也就是谁进行的回调)
@property(nonatomic,assign)SEL actionDown;///<执行的目标的方法
@property(nonatomic,weak)id targetUpinside;///<目标(也就是谁进行的回调)
@property(nonatomic,assign)SEL actionUpinside;///<执行的目标的方法

////target对象执行他的action方法
//[self.target performSelector:self.action withObject:self];

@end

@implementation UIButton_DIYObject

- (instancetype)init{
    if (self = [super init]) {
        _imageScale = 1;
        _tintsColor = [UIColor blackColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageScale = 1;
        _tintsColor = [UIColor blackColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Style:(INIT_STYLE)style{
    if (self=[super initWithFrame:frame]) {
        self.currentStyle=style;
        self.backgroundColor=[UIColor clearColor];
        _imageScale = 1;
        _tintsColor = [UIColor blackColor];

        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    /* SHOW */
    if (_currentShowStyle == SHOW_STYLE_Boder) {
        
        CGFloat lineWidth = 1.f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineWidth/2.f, lineWidth/2.f, self.frame.size.width-lineWidth, self.frame.size.height-lineWidth) cornerRadius:self.frame.size.height/7.f];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
    }
    else{
        
    }
    
    /* INIT */
    if (_currentStyle == INIT_STYLE_ScanLogo) {
        
        CGFloat lineWidth=2.f;
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, _tintsColor.CGColor);
        
        //左上角
        CGContextMoveToPoint(context, lineWidth/2.f, self.frame.size.height/4.f);
        CGContextAddLineToPoint(context, lineWidth/2.f, self.frame.size.height/8.f);
        CGContextAddArcToPoint(context, lineWidth/2.f, lineWidth/2.f, self.frame.size.width/8.f, lineWidth/2.f, self.frame.size.width/8.f);
        CGContextAddLineToPoint(context, self.frame.size.width/4.f, lineWidth/2.f);
        
        //右上角
        CGContextMoveToPoint(context, self.frame.size.width*0.75, lineWidth/2.f);
        CGContextAddLineToPoint(context, self.frame.size.width*0.875, lineWidth/2.f);
        CGContextAddArcToPoint(context, self.frame.size.width-lineWidth/2.f, lineWidth/2.f, self.frame.size.width-lineWidth/2.f, self.frame.size.height/8.f, self.frame.size.width/8.f);
        CGContextAddLineToPoint(context, self.frame.size.width-lineWidth/2.f, self.frame.size.height/4.f);
        
        //右下角
        CGContextMoveToPoint(context, self.frame.size.width-lineWidth/2.f, self.frame.size.height*0.75);
        CGContextAddLineToPoint(context, self.frame.size.width-lineWidth/2.f, self.frame.size.height*0.875);
        CGContextAddArcToPoint(context, self.frame.size.width-lineWidth/2.f, self.frame.size.height-lineWidth/2.f, self.frame.size.width*0.875, self.frame.size.height-lineWidth/2.f, self.frame.size.width/8.f);
        CGContextAddLineToPoint(context, self.frame.size.width*0.75, self.frame.size.height-lineWidth/2.f);
        
        //左下角
        CGContextMoveToPoint(context, self.frame.size.width/4.f, self.frame.size.height-lineWidth/2.f);
        CGContextAddLineToPoint(context, self.frame.size.width*0.125, self.frame.size.height-lineWidth/2.f);
        CGContextAddArcToPoint(context, lineWidth/2.f, self.frame.size.height-lineWidth/2.f, lineWidth/2.f, self.frame.size.height*0.875, self.frame.size.width/8.f);
        CGContextAddLineToPoint(context, lineWidth/2.f, self.frame.size.height*0.75);
        
        CGContextMoveToPoint(context, 0, self.frame.size.height/2.f);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2.f);
        
        CGContextStrokePath(context);
    }
    else if (_currentStyle == INIT_STYLE_Left){
        
        CGFloat lineWidth=3.f;
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, _tintsColor.CGColor);
        CGContextMoveToPoint(context, self.frame.size.width*0.5+self.frame.size.width*0.1*_imageScale, self.frame.size.height*0.5-self.frame.size.height*0.3*_imageScale);
        CGContextAddLineToPoint(context, self.frame.size.width*0.5-self.frame.size.width*0.2*_imageScale, self.frame.size.height*0.5);
        CGContextAddLineToPoint(context, self.frame.size.width*0.5+self.frame.size.width*0.1*_imageScale, self.frame.size.height*0.5+self.frame.size.height*0.3*_imageScale);
        CGContextStrokePath(context);
    }
    else if (_currentStyle == INIT_STYLE_Right){
        
    }
    else if (_currentStyle == INIT_STYLE_Add) {
        
        CGFloat lineWith=(3.f/414.f)*MainScreenWidth;
        CGFloat distance=(5.f/414.f)*MainScreenWidth;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, _tintsColor.CGColor);
        
        UIBezierPath *path1=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.frame.size.width/2.f-lineWith/2.f, distance, lineWith, self.frame.size.height-distance*2.f) cornerRadius:lineWith];
        CGContextAddPath(context, path1.CGPath);
        
        UIBezierPath *path2=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(distance, self.frame.size.height/2.f-lineWith/2.f, self.frame.size.width-distance*2.f, lineWith) cornerRadius:lineWith];
        CGContextAddPath(context, path2.CGPath);
        
        CGContextFillPath(context);
        
    }
    else if (_currentStyle == INIT_STYLE_BlueTooth){
        
        CGFloat x_4=self.frame.size.height/4.f;
        CGFloat y_4=self.frame.size.height/4.f;
        

        CGContextRef context1 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 2.5);
        CGContextSetStrokeColorWithColor(context1, _tintsColor.CGColor);
        CGContextMoveToPoint(context1, x_4, y_4);//起点
        CGContextAddLineToPoint(context1, x_4*3.f, y_4*3.f);
        CGContextAddLineToPoint(context1, x_4*2.f, y_4*4.f-4.f);
        CGContextAddLineToPoint(context1, x_4*2.f, 0+4.f);
        CGContextAddLineToPoint(context1, x_4*3.f, y_4);
        CGContextAddLineToPoint(context1, x_4, y_4*3.f);
        CGContextStrokePath(context1);
        
    }
    else if (_currentStyle == INIT_STYLE_Triangle){

        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        if (self.layer.transform.m21 == -1) {
            width = self.frame.size.height;
            height = self.frame.size.width;
        }
        CGFloat h = height*0.4;
        if (width<height) {
            h = width*0.4;
        }
        CGFloat length = h*(2.f/sqrtf(3.f));
        CGPoint center = CGPointMake(width/2.f, height/2.f);
        CGPoint p1 = CGPointMake(center.x-h/2.f, center.y);
        CGPoint p2 = CGPointMake(center.x+h/2.f, center.y-length/2.f);
        CGPoint p3 = CGPointMake(center.x+h/2.f, center.y+length/2.f);

        CGContextRef context1 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 1.f);
        CGContextSetFillColorWithColor(context1, _tintsColor.CGColor);
        CGContextMoveToPoint(context1, p1.x, p1.y);//起点
        CGContextAddLineToPoint(context1, p2.x, p2.y);
        CGContextAddLineToPoint(context1, p3.x, p3.y);
        CGContextDrawPath(context1, kCGPathFill);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    if (self.originalScale != 0) {
        for (UIView *sview in self.subviews) {
            if (sview.tag == 0 && [sview isKindOfClass:[UIImageView class]]) {
                CGFloat newW = sview.frame.size.width * self.originalScale;
                CGFloat newH = sview.frame.size.height * self.originalScale;
                CGFloat newX = self.frame.size.width/2.0 - newW/2.0;
                CGFloat newY = self.frame.size.height/2.0 - newH/2.0;
                sview.frame = CGRectMake(newX, newY, newW, newH);
            }
        }
    }
    
    self.labTitle.center=CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
}



- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{

    if (!self.canTouchDown) {
        [super addTarget:target action:action forControlEvents:controlEvents];
        return ;
    }

    switch (controlEvents) {

        case UIControlEventTouchUpInside:
            self.targetUpinside = target;
            self.actionUpinside = action;
            [super addTarget:self action:@selector(replaceUpInside) forControlEvents:controlEvents];
            break;

        case UIControlEventTouchDown:
            self.targetDown = target;
            self.actionDown = action;
            [super addTarget:self action:@selector(replaceDown) forControlEvents:controlEvents];
            break;

        default:
            [super addTarget:target action:action forControlEvents:controlEvents];
            break;
    }
}

#pragma mark - inside method
- (void)replaceDown{
    self.alpha = 0.5;
    if ([self.targetDown respondsToSelector:self.actionDown]) {
        [self.targetDown performSelector:self.actionDown withObject:self afterDelay:0.01];
    }
}

- (void)replaceUpInside{
    self.alpha = 1;
    if ([self.targetUpinside respondsToSelector:self.actionUpinside]) {
        [self.targetUpinside performSelector:self.actionUpinside withObject:self afterDelay:0.01];
    }
}


- (void)clickDown{
//    self.alpha = 0.5;
}

- (void)clickUpinside{
//    self.alpha = 1;
}


#pragma mark - lazy load
- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle=[[UILabel alloc]init];
        if (@available(iOS 8.2, *)) {
            _labTitle.font = [UIFont fitSystemFontOfSize:18.f weight:UIFontWeightLight];
        } else {
            _labTitle.font = [UIFont fitSystemFontOfSize:18.f];
        }
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

#pragma mark - set method
- (void)setTitle:(NSString *)title{
    _title=title;
    self.labTitle.text=title;
    [self.labTitle sizeToFit];
    self.labTitle.center=CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.labTitle.textColor = textColor;
}

- (void)setCanTouchDown:(bool)canTouchDown{
    _canTouchDown = canTouchDown;
    if (canTouchDown) {
        [self addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(clickUpinside) forControlEvents:UIControlEventTouchUpInside];
    } else{
        [self removeTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchDown];
        [self removeTarget:self action:@selector(clickUpinside) forControlEvents:UIControlEventTouchDown];
    }

}

#pragma mark - outside method
- (void)setSizeWithTitle:(NSString *)title{
    _title=title;
    self.labTitle.text=title;
    [self.labTitle sizeToFit];
    CGRect oldFrame = self.frame;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, _labTitle.bounds.size.width, _labTitle.bounds.size.height);
    self.labTitle.center=CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
}

- (void)showStyle:(SHOW_STYLE)style{
    self.currentShowStyle = style;
    [self setNeedsDisplay];
}

- (void)setImageScale:(float)imageScale{
    if (imageScale>1) {
        return ;
    }
    _imageScale = imageScale;
    [self setNeedsDisplay];
}

- (void)setOriginalScale:(CGFloat)originalScale{
    if (originalScale <= 0) {
        return ;
    }
    _originalScale = originalScale;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
