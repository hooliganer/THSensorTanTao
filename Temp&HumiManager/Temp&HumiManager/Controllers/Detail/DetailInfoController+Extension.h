//
//  DetailInfoController+Extension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/13.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"
#import "DetailWarningAlert.h"
#import "DetailCellView.h"
#import "DetailChooseSegment.h"
#import "DetailTypeChooseView.h"
#import "DetailHumidityView.h"
#import "DetailTempView.h"
#import "DetailWarningView.h"
#import "DetailEditAlert.h"

@interface DetailInfoController ()

@property (nonatomic,strong)UIScrollView * bgScroll;
@property (nonatomic,strong)DetailWarningAlert * warner;
@property (nonatomic,strong)DetailCellView * topView;
@property (nonatomic,strong)UIView * btmView;
@property (nonatomic,strong)DetailChooseSegment * segmentView;
@property (nonatomic,strong)DetailTypeChooseView * typeView;
@property (nonatomic,strong)DetailTempView * temperatureView;
@property (nonatomic,strong)DetailHumidityView * humidityView;
@property (nonatomic,strong)DetailWarningView * warnView;
@property (nonatomic,strong)UIButton_DIYObject * exportBtn;
@property (nonatomic,strong)DetailEditAlert * editer;

@property (nonatomic,strong)NSMutableArray <DeviceInfo *>* currentDatas;///<当前时间段内的温湿度数据等

@end

