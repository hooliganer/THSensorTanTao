//
//  DetailHumidityView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailHistoryInfoView.h"
#import "MyLineView.h"
#import "THLineView.h"

@interface DetailHumidityView : UIView

@property (nonatomic,strong)DetailHistoryInfoView *humiInfoView;
@property (nonatomic,strong)MyLineView *lineView;
@property (nonatomic,strong)THLineView *liner;

@end
