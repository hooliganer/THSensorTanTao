//
//  MyScrollView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

- (instancetype)init{
    if (self = [super init]) {
        self.delaysContentTouches = false;
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if (view) {
        return true;
    }
    return [super touchesShouldCancelInContentView:view];
}



@end
