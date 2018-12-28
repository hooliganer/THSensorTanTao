//
//  THAlert.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/28.
//  Copyright © 2018 terry. All rights reserved.
//

#import "THAlert.h"

@interface THAlert ()

@property (strong, nonatomic) IBOutlet UIView *topBGView;
@property (strong, nonatomic) IBOutlet UIView *confirmView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *confrimTempImvH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *confirmHumiImvH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *confirmTempImvW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *confirmHumiImvW;

@end

@implementation THAlert

+ (THAlert *)instanceWithFrame:(CGRect)frame{
    
    UINib * nib = [UINib nibWithNibName:@"THAlert" bundle:nil];
    THAlert * view = [[nib instantiateWithOwner:nil options:nil] firstObject];
    view.frame = frame;
    
    return view;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 8;
    
    if (self.type == THAlert_Type_WarnConfirm) {
        self.confirmBtn.layer.masksToBounds = true;
        self.confirmBtn.layer.cornerRadius = 5;
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
        
    self.height = self.confirmBtn.height + self.confirmHumiImv.height + self.confirmTempImv.height + self.topBGView.height + 35;
    [self.superview setNeedsLayout];
}


@end
