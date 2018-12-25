//
//  UIImageView+DIYImageView.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 terry. All rights reserved.
//

#import "UIImageView+DIYImageView.h"

@implementation UIImageView (DIYImageView)

- (void)fitWidth{
    if (!self.image) {
        LRLog(@"不能适配宽度，因为没有图片！");
        return ;
    }
    self.width = (self.image.size.width/self.image.size.height)*self.height;
}

- (void)fitHeight{
    if (!self.image) {
        LRLog(@"不能适配高度，因为没有图片！");
        return ;
    }
    self.height = (self.image.size.height/self.image.size.width)*self.width;
}

@end
