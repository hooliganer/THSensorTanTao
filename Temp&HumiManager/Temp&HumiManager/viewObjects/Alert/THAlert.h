//
//  THAlert.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/28.
//  Copyright © 2018 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(int, THAlert_Type) {
    THAlert_Type_WarnConfirm ,
};

@interface THAlert : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIImageView *confirmTempImv;
@property (strong, nonatomic) IBOutlet UILabel *confirmTempLab;
@property (strong, nonatomic) IBOutlet UIImageView *confirmHumiImv;
@property (strong, nonatomic) IBOutlet UILabel *confirmHumiLab;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;

+ (THAlert *)instanceWithFrame:(CGRect)frame;

@property (nonatomic,assign)THAlert_Type type;

@end

NS_ASSUME_NONNULL_END
