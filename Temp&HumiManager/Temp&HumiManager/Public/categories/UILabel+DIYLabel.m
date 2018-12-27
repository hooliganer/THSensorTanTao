//
//  UILabel+DIYLabel.m
//  HomeKitSystem
//
//  Created by 谭滔 on 2017/12/11.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "UILabel+DIYLabel.h"


@implementation UILabel (DIYLabel)

- (instancetype)initWithText:(NSString *)text{
    if (self = [super init]) {
        self.text = text;
        [self sizeToFit];
    }
    return self;
}


- (void)fitHeight:(CGFloat)height WithWeight:(CGFloat)weight{
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text=self.text;
    lab.font=self.font;
    [lab sizeToFit];
    
    CGFloat fontWeight = weight;
    CGFloat fontSize = lab.font.pointSize;
    [lab sizeToFit];
    CGSize newSize = lab.bounds.size;
    
    while (newSize.height >= height) {
        fontSize*=0.95;
        if (@available(iOS 8.2, *)) {
            lab.font = [UIFont systemFontOfSize:fontSize weight:fontWeight];
        } else {
            lab.font = [UIFont systemFontOfSize:fontSize];
        }
        [lab sizeToFit];
        newSize=lab.bounds.size;
    }
    
    self.font = lab.font;
}

- (void)fitWidth:(CGFloat)width{

    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, width,size.height);
    self.frame = rect;
}

- (void)fitMaxWidth:(CGFloat)width{
    [self sizeToFit];
    if (self.bounds.size.width > width) {
        [self fitWidth:width];
    }
}

@end
