//
//  MyNavigationBar.m
//  MedicalTreatmentProject
//
//  Created by 谭滔 on 2017/8/17.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "MyNavigationBar.h"

#import "UIColor+DIYColor.h"
#import "UIButton_DIYObject.h"
#import "UIFont+DIYFont.h"

#define Distance   ((StatusBarHeight/414.0)*MainScreenWidth)

@interface MyNavigationBar ()

@property (nonatomic,strong)UILabel *labTitle;

@property (nonatomic,strong)NSMutableArray *leftActions;
@property (nonatomic,strong)NSMutableArray *leftBlocks;

@property (nonatomic,strong)NSMutableArray *rightActions;
@property (nonatomic,strong)NSMutableArray *rightBlocks;

@property (nonatomic,strong,readwrite)UIView *btmLine;

@end

@implementation MyNavigationBar

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, StatusBarHeight + 44.0);
        self.backgroundColor = [UIColor mainGrayColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 0, MainScreenWidth, StatusBarHeight + 44.0);
        
        self.backgroundColor=[UIColor mainGrayColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat distance = (10.f/414.f)*MainScreenWidth;
    CGFloat distancer = (10.f/414.f)*MainScreenWidth;
    CGFloat old_R_X = distance;
    CGFloat old_L_X = distance;
    
    for (int i=0;i<self.rightActions.count;i++) {
        UIView *rView = self.rightActions[i];
        CGRect oldFrame = rView.frame;
        rView.center = CGPointMake(self.frame.size.width-old_R_X-oldFrame.size.width/2.f, oldFrame.origin.y+oldFrame.size.height/2.f);
        old_R_X += (rView.frame.size.width+distancer);
    }
    
    for (int i=0;i<self.leftActions.count;i++) {
        UIView *lView = self.leftActions[i];
        CGRect oldFrame = lView.frame;
        lView.center = CGPointMake(old_L_X+oldFrame.size.width/2.f, oldFrame.origin.y+oldFrame.size.height/2.f);
        old_L_X += (lView.frame.size.width+distancer);
    }
    
}

#pragma mark - set method
- (void)setTitle:(NSString *)title{
    _title=title;
    self.labTitle.text=title;
    [self.labTitle sizeToFit];
    self.labTitle.center=CGPointMake(self.frame.size.width/2.f, StatusBarHeight + (44.f/2.f));
}

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    self.labTitle.textColor = tintColor;
    for (UIView *sview in self.subviews) {
        if ([sview isMemberOfClass:[UIButton_DIYObject class]]) {
            UIButton_DIYObject *btn = (UIButton_DIYObject *)sview;
            btn.tintsColor = tintColor;
        }
    }
}


#pragma mark - lazy method
- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle=[[UILabel alloc]init];
        _labTitle.textColor=[UIColor whiteColor];
        if (@available(iOS 8.2, *)) {
            _labTitle.font=[UIFont fitSystemFontOfSize:22.f weight:UIFontWeightRegular];
        } else {
            _labTitle.font=[UIFont fitSystemFontOfSize:22.f];
        }
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

- (UIView *)btmLine{
    if (_btmLine == nil) {
        _btmLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1.f, self.frame.size.width, 1.f)];
        _btmLine.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        [self addSubview:_btmLine];
    }
    return _btmLine;
}


#pragma mark - Outside Method
- (instancetype)initWithTitle:(NSString *)title{
    if (self=[super init]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, StatusBarHeight + 44);
        self.labTitle.text = title;
        [self.labTitle sizeToFit];
        self.labTitle.center = CGPointMake(self.frame.size.width/2.0, StatusBarHeight +44/2.0);
    }
    return self;
}



- (void)removeRightActionWithIndex:(NSInteger)index{
    for (int i=0;i<self.rightActions.count;i++) {
        UIView *view = self.rightActions[i];
        if (view.tag == (55+index)) {
            [view removeFromSuperview];
            [self.rightActions removeObjectAtIndex:i];
            [self.rightBlocks removeObjectAtIndex:i];
            break ;
        }
    }
    
}

- (void)removeLeftActionWithIndex:(NSInteger)index{
    NSLog(@"%@",self.leftActions);
}


- (void)showBackButton:(void (^)(void))clickBlock{
    if (!_leftActions) {
        _leftActions=[NSMutableArray array];
        _leftBlocks=[NSMutableArray array];
    }
    CGFloat oldWitth = 0;
    for (UIButton *btn in _leftActions) {
        if (btn) {
            oldWitth+=btn.frame.size.width;
        }
    }
    
    UIButton_DIYObject *btn=[[UIButton_DIYObject alloc]initWithFrame:CGRectMake(0, StatusBarHeight, 44.f, 44.f) Style:INIT_STYLE_Left];
    btn.imageScale = 0.8;
    btn.tintsColor = _tintColor;
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.tag=50+_leftActions.count;
    
    [_leftActions addObject:btn];
    if (clickBlock==nil) {
        clickBlock=^{
            NSLog(@"为空占位");
        };
    }
    [_leftBlocks addObject:clickBlock];
    
}

- (void)addActionRightWithType:(Navigation_Action_Type)type Block:(void(^)(void))block{
    
    if (!_rightActions) {
        _rightActions=[NSMutableArray array];
        _rightBlocks=[NSMutableArray array];
    }
    
    CGFloat oldWitth = 0;
    for (UIButton *btn in _rightActions) {
        if (btn) {
            oldWitth+=btn.frame.size.width+Distance;
        }
    }
    
    if (type==Navigation_Action_Type_Add) {
        
        CGFloat distance = (20.f/414.f)*MainScreenWidth;
        CGFloat width = 44.f;
        
        UIButton_DIYObject *add=[[UIButton_DIYObject alloc]initWithFrame:CGRectMake(self.frame.size.width-distance-oldWitth-width, 20.f, width, width) Style:INIT_STYLE_Add];
        [add addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        add.tag = 55+_rightActions.count;
        add.tintsColor = self.tintColor;
        [self addSubview:add];
        
        [_rightActions addObject:add];
        if (block==nil) {
            block=^{
                NSLog(@"为空占位");
            };
        }
        [_rightBlocks addObject:block];
        
    }
    
}

- (void)addActionLeftWithType:(Navigation_Action_Type)type Block:(void(^)(void))block{
    if (!_leftActions) {
        _leftActions=[NSMutableArray array];
        _leftBlocks=[NSMutableArray array];
    }
    
    CGFloat oldWitth = 0;
    for (UIButton *btn in _leftActions) {
        if (btn) {
            oldWitth+=btn.frame.size.width+Distance;
        }
    }
    
    if (type==Navigation_Action_Type_Add) {
        
        CGFloat distance = (20.f/414.f)*MainScreenWidth;
        CGFloat width = 44.f;
        
        UIButton_DIYObject *add=[[UIButton_DIYObject alloc]initWithFrame:CGRectMake(self.frame.size.width-distance-oldWitth-width, 20.f, width, width) Style:INIT_STYLE_Add];
        [add addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        add.tag=50+_leftActions.count;
        add.tintsColor = self.tintColor;
        add.originalScale = 0.5;
        [self addSubview:add];
        
        [_leftActions addObject:add];
        if (block==nil) {
            block=^{
                NSLog(@"为空占位");
            };
        }
        [_leftBlocks addObject:block];
        
    }
}



- (void)addActionLeftImage:(UIImage *)image Block:(void (^)(void))block{

    if (image == nil) {
        return ;
    }
    if (!_leftActions) {
        _leftActions=[NSMutableArray array];
        _leftBlocks=[NSMutableArray array];
    }
    
    CGFloat oldWitth = 0;
    for (UIButton *btn in _leftActions) {
        if (btn) {
            oldWitth+=btn.frame.size.width+Distance;
        }
    }
    
    CGFloat distance = Fit_X(20);
    
    CGFloat height = 44;
    CGFloat width=(image.size.width/image.size.height)*height;
    UIButton_DIYObject *btn = [[UIButton_DIYObject alloc]initWithFrame:CGRectMake(distance+oldWitth, StatusBarHeight, width, height)];
    btn.originalScale = 0.8;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [self addSubview:btn];

    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = 50+_leftActions.count;
    
    [_leftActions addObject:btn];
    if (block==nil) {
        block=^{
            NSLog(@"为空占位");
        };
    }
    [_leftBlocks addObject:block];
    
    
}

- (void)addActionLeftTitle:(NSString *)title Block:(void (^)(void))block{
    
    if (!_leftActions) {
        _leftActions=[NSMutableArray array];
        _leftBlocks=[NSMutableArray array];
    }
    
    CGFloat oldWidth = 0;
    for (UIButton *btn in _leftActions) {
        if (btn) {
            oldWidth+=btn.frame.size.width+Distance;
        }
    }
    
    UILabel *lab=[[UILabel alloc]init];
    lab.text=title;
    lab.textColor=[UIColor whiteColor];
    if (@available(iOS 8.2, *)) {
        lab.font=[UIFont fitSystemFontOfSize:20.f weight:UIFontWeightLight];
    } else {
        lab.font=[UIFont fitSystemFontOfSize:20.f];
    }
    [lab sizeToFit];
    
    CGFloat height=44.f;
    CGFloat width=lab.bounds.size.width;
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(Distance+oldWidth, StatusBarHeight, width, height)];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(clickActionDown:) forControlEvents:UIControlEventTouchDown];
    
    lab.center=CGPointMake(width/2.f, height/2.f);
    [btn addSubview:lab];
    
    btn.tag=50+_leftActions.count;
    
    [_leftActions addObject:btn];
    if (block==nil) {
        block=^{
            NSLog(@"为空占位");
        };
    }
    [_leftBlocks addObject:block];
    
}


- (void)addActionRightImage:(UIImage *)image Block:(void(^)(void))block{
    if (image) {
        if (!_rightActions) {
            _rightActions=[NSMutableArray array];
            _rightBlocks=[NSMutableArray array];
        }
        
        CGFloat oldWitth = 0;
        for (UIButton *btn in _rightActions) {
            if (btn) {
                oldWitth+=btn.frame.size.width+Distance;
            }
        }
        
        CGFloat distance = (20.f/414.f)*MainScreenWidth;
        
        CGFloat height=44.f;
        CGFloat width=(image.size.width/image.size.height)*height;
        UIButton_DIYObject *btn=[[UIButton_DIYObject alloc]initWithFrame:CGRectMake(self.frame.size.width-distance-width-oldWitth, StatusBarHeight, width, height)];
        btn.originalScale = 0.8;
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag=55+_rightActions.count;
        
        [_rightActions addObject:btn];
        if (block==nil) {
            block=^{
                NSLog(@"为空占位");
            };
        }
        [_rightBlocks addObject:block];
    }
}

- (void)addActionRightTitle:(NSString *)title Block:(void(^)(void))block{
    if (!_rightActions) {
        _rightActions=[NSMutableArray array];
        _rightBlocks=[NSMutableArray array];
    }
    
    CGFloat oldWidth = 0;
    for (UIButton *btn in _rightActions) {
        if (btn) {
            oldWidth+=btn.frame.size.width+Distance;
        }
    }
    
    UILabel *lab=[[UILabel alloc]init];
    lab.text=title;
    lab.textColor=[UIColor whiteColor];
    if (@available(iOS 8.2, *)) {
        lab.font=[UIFont fitSystemFontOfSize:20.f weight:UIFontWeightLight];
    } else {
        lab.font=[UIFont fitSystemFontOfSize:20.f];
    }
    [lab sizeToFit];
    
    CGFloat height=44.f;
    CGFloat width=lab.bounds.size.width;
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-Distance-width-oldWidth, StatusBarHeight, width, height)];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(clickActionDown:) forControlEvents:UIControlEventTouchDown];
    
    lab.center=CGPointMake(width/2.f, height/2.f);
    [btn addSubview:lab];
    
    btn.tag=55+_rightActions.count;
    
    [_rightActions addObject:btn];
    if (block==nil) {
        block=^{
            NSLog(@"为空占位");
        };
    }
    [_rightBlocks addObject:block];
}



#pragma mark ------ Inside Method
- (void)clickActionDown:(UIButton *)sender{
    sender.alpha=0.5;
}

- (void)clickAction:(UIButton *)sender{
    
    sender.alpha=1;
    
    if (sender.tag>=55) {
        for (int i=0; i<_rightActions.count; i++) {
            UIButton *btn = _rightActions[i];
            if (btn.tag==sender.tag) {
                void(^block)(void)=_rightBlocks[i];
                if (block) {
                    block();
                }
                break ;
            }
        }
    }
    else{
        for (int i=0;i<_leftActions.count;i++) {
            UIButton *btn = _leftActions[i];
            if (btn.tag==sender.tag) {
                void(^block)(void)=_leftBlocks[i];
                if (block) {
                    block();
                }
                break ;
            }
        }
    }
    
    
    
    
}


/**
 * 实现背景渐变
 */
- (void)addGridiantLayer{
    //实现背景渐变
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.frame;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[
                             (__bridge id)[UIColor blueColor].CGColor,
                             (__bridge id)[UIColor redColor].CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.5f), @(1.0f)];
}


@end
