//
//  UIView+DIYView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "UIView+DIYView.h"

@implementation UIView (DIYView)

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{

    CGPoint oldpt = self.frame.origin;
    self.frame = CGRectMake(oldpt.x, oldpt.y, size.width, size.height);
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{

    CGSize oldsz = self.frame.size;
    self.frame = CGRectMake(origin.x, origin.y, oldsz.width, oldsz.height);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{

    CGPoint oldpt = self.frame.origin;
    self.frame = CGRectMake(oldpt.x, oldpt.y, self.frame.size.width, height);
    
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{

    CGPoint oldpt = self.frame.origin;
    self.frame = CGRectMake(oldpt.x, oldpt.y, width, self.frame.size.height);

}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{

    CGSize size = self.frame.size;
    self.frame = CGRectMake(self.frame.origin.x, y, size.width, size.height);

}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{

    CGSize size = self.frame.size;
    self.frame = CGRectMake(x, self.frame.origin.y, size.width, size.height);

}

- (CGFloat)bottomY{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)rightX{
    return self.frame.origin.x + self.frame.size.width;
}

@end
