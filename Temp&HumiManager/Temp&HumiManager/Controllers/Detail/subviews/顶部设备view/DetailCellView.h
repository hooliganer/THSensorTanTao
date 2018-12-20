//
//  DetailCellView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/9.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(int, CellImvType) {
    CellImvType_Bed ,
    CellImvType_Chair ,
    CellImvType_WC ,
    CellImvType_Car ,
    CellImvType_Baby ,
    CellImvType_Bar ,
};


@interface DetailCellView : UIView

@property (nonatomic,strong)UIImageView *imvHead;
@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,strong)UIImageView *imvInternet;
@property (nonatomic,strong)UIImageView *imvBluetooth;
@property (nonatomic,strong)UIImageView *imvBattery;
@property (nonatomic,strong)UIImageView *imvTempar;
@property (nonatomic,strong)UIImageView *imvHumi;
@property (nonatomic,strong)UILabel *labPower;
@property (nonatomic,strong)UILabel *labTempar;
@property (nonatomic,strong)UILabel *labHumi;
@property (nonatomic,strong)UIImageView *imvTemparB;
@property (nonatomic,strong)UIImageView *imvHumiB;
@property (nonatomic,strong)UIImageView *imvWarning;

@property (nonatomic,assign)bool isWifi;
@property (nonatomic,assign)bool isBle;

@property (nonatomic,assign)bool tempWarning;
@property (nonatomic,assign)bool humiWarning;

@property (nonatomic,assign)CellImvType type;

@end
