//
//  AlertInfoer.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/26.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AlertInfoer.h"

@implementation AlertInfoer


+ (AlertInfoer *)instanceWithFrame:(CGRect)frame{
    
    UINib * nib = [UINib nibWithNibName:@"AlertInfoer" bundle:nil];
    AlertInfoer * view = [[nib instantiateWithOwner:nil options:nil] firstObject];
    view.frame = frame;
    
    return view;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 8;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.height = self.infoLab.bottomY + 30 + self.line.height + self.btn.height;
    [self.superview setNeedsLayout];
}

- (void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    
    
}




@end
