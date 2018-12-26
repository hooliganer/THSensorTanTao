//
//  AlertInfoer.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/26.
//  Copyright © 2018 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertInfoer : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *infoLab;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UIView *line;


+ (AlertInfoer *)instanceWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
