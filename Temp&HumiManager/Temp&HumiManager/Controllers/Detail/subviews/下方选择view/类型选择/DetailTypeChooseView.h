//
//  DetailTypeChooseView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/15.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailTypeChooseView;

@protocol DetailTypeChooseViewDelegate <NSObject>

- (void)typeChooseView:(DetailTypeChooseView *)chooseView ChooseType:(int)type;

@end

@interface DetailTypeChooseView : UIView

@property (nonatomic,weak)id <DetailTypeChooseViewDelegate>delegate;
@property (nonatomic,assign)int type;///<0:温度🌡️,1:湿度💧,2:警告⚠️

@end
