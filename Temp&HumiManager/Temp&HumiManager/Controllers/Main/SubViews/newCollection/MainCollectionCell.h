//
//  MainCollectionCell.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton_DIYObject.h"

#define Height_BtnLink Fit_Y(30.0)

typedef NS_OPTIONS(int, CellImvType) {
    CellImvType_Bed ,
    CellImvType_Chair ,
    CellImvType_WC ,
    CellImvType_Car ,
    CellImvType_Baby ,
    CellImvType_Bar ,
};

@interface MainCollectionCell : UICollectionViewCell

@property (nonatomic,assign)CellImvType type;

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *power;
@property (nonatomic,assign)bool isWifi;
@property (nonatomic,assign)bool isBle;
@property (nonatomic,copy)NSString *temparature;
@property (nonatomic,copy)NSString *humidity;
@property (nonatomic,assign)bool tempWarning;
@property (nonatomic,assign)bool humiWarning;

@property (nonatomic,assign)bool isLink;///<是否显示关注按钮
@property (nonatomic,strong)UIButton_DIYObject *btnLink;

@end
