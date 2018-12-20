//
//  MainViewData.h
//  Temp&HumiManager
//
//  Created by terry on 2018/7/10.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyPeripheral.h"
#import "DeviceInfo.h"
#import "TH_GroupInfo.h"

typedef NS_OPTIONS(int, MainViewDataType) {
    MainViewDataType_Default ,///<蓝牙数据
    MainViewDataType_Device ,///<单关注设备数据
    MainViewDataType_Group ,///<分组数据
};

typedef struct {
    float temperature;///<温度
    int humidity;///<湿度
    int power;///<电量
} TH_BLEData;

CG_INLINE TH_BLEData
TH_BLEDataMake(float tp,int hm,int po)
{
    TH_BLEData tbd;
    tbd.temperature = tp;
    tbd.humidity = hm;
    tbd.power = po;
    return tbd;
}



@interface MainViewData : NSObject

@property (nonatomic,assign)MainViewDataType type;
@property (nonatomic,strong)MyPeripheral *periInfo;
@property (nonatomic,strong)DeviceInfo *deviceInfo;
@property (nonatomic,strong)TH_GroupInfo *groupInfo;
@property (nonatomic,assign)bool isFlex;
@property (nonatomic,assign)bool isLink;
@property (nonatomic,assign)bool isTemp;
@property (nonatomic,assign)bool isHumi;
@property (nonatomic,copy)NSString * tempUnit;///<温度单位

/*!
 * 获得当前的蓝牙数据，仅当type为MainViewDataType_Default时才有效
 */
- (TH_BLEData)getBLEData;


@end
