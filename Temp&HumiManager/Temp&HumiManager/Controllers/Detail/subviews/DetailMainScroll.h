//
//  DetailMainScroll.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/25.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCellView.h"
#import "DetailChooseSegment.h"
#import "DetailTempView.h"
#import "DetailHumidityView.h"
#import "DetailWarningView.h"
#import "DetailTypeChooseView.h"
#import "UIButton_DIYObject.h"
#import "DetailWarningAlert.h"

@interface DetailMainScroll : UIScrollView

@property (nonatomic,strong)DetailCellView *cellView;///<顶部view
@property (nonatomic,strong)UIView *btmView;
@property (nonatomic,strong)DetailChooseSegment *chooseSeg;///<时天周选择view

@property (nonatomic,strong)DetailTypeChooseView *typeView;///<温湿度警告类型view

@property (nonatomic,strong)DetailTempView *tempView;///<温度🌡️view
@property (nonatomic,strong)DetailHumidityView *humiView;///<湿度💧view
@property (nonatomic,strong)DetailWarningView *warnView;///<警告⚠️view
@property (nonatomic,strong)UIButton_DIYObject *btnExport;///<导出按钮
@property (nonatomic,strong)DetailWarningAlert *warnAlert;///<顶部警告⚠️弹窗


@property (nonatomic,assign)bool warning;

@end
