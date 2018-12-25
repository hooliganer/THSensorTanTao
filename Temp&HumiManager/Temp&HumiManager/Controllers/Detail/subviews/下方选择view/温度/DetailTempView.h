//
//  DetailTempView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/15.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailHistoryInfoView.h"
#import "MyLineView.h"
#import "THLineView.h"

@interface DetailTempView : UIView

@property (nonatomic,strong)DetailHistoryInfoView *tempInfoView;
@property (nonatomic,strong)MyLineView *lineView;
@property (nonatomic,strong)THLineView *liner;

@end
