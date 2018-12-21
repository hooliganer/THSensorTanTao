//
//  THNavigationBar.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import "THNavigationBar.h"
#import "UIButton_DIYObject.h"

@interface THNavigationBar ()

@property (nonatomic,strong) NSMutableArray <NSDictionary *>* actions;

@end

@implementation THNavigationBar

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, StatusBarHeight + 44);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, StatusBarHeight + 44);
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray<NSDictionary *> *)actions{
    if (_actions == nil) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

#pragma mark - 外部方法
- (void)showBack:(void (^)(THNavigationBar * _Nonnull))block{
    
    UIButton_DIYObject *btn = [[UIButton_DIYObject alloc]initWithFrame:CGRectMake(0, StatusBarHeight, 44, 44) Style:INIT_STYLE_Left];
    btn.imageScale = 0.8;
    btn.tintsColor = self.tintColor;
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.tag = 1000;
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    [mdic setValue:block forKey:@"block"];
    [mdic setValue:btn forKey:@"object"];
    [self.actions addObject:mdic];
}


#pragma mark - 事件
- (void)clickButton:(UIButton *)sender{
    for (NSDictionary * dic in self.actions) {
        id obj = [dic valueForKey:@"object"];
        if ([obj isEqual:sender]) {
            switch (sender.tag) {
                case 1000:
                {
                    void(^block)(THNavigationBar *) = [dic valueForKey:@"block"];
                    if (block) {
                        block(self);
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            break ;
        }
    }
}

@end
