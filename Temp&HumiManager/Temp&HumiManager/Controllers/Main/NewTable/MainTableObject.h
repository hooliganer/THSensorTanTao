//
//  MainTableObject.h
//  Temp&HumiManager
//
//  Created by terry on 2018/9/1.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlueToothInfo.h"
#import "TH_GroupInfo.h"

typedef NS_OPTIONS(int, DataType) {
    DataType_Default ,///<默认分组
    DataType_Wifi ,///<网络数据
    DataType_Ble ,///<蓝牙数据
};

@interface MainTableObject : NSObject

@property (nonatomic,strong)BlueToothInfo * bleInfo;
@property (nonatomic,strong)TH_GroupInfo * groupInfo;
@property (nonatomic,strong)DeviceInfo * devInfo;

@property (nonatomic,assign)bool flex;
@property (nonatomic,strong)TH_GroupInfo * group;
@property (nonatomic,assign)DataType type;
/*!
 * 每组设备列表
 * {
 *  @"warning":@{@"temp":@(true),@"humi":@(false)},
 *  @"ble":BlueToothInfo,
 *  @"wifi":DeviceInfo
 * }
 */
@property (nonatomic,strong)NSMutableArray <NSMutableDictionary *>* devices;

@property (nonatomic,assign)bool tpWarning;
@property (nonatomic,assign)bool hmWarning;

@property (nonatomic,assign)NSMutableArray <NSMutableDictionary <NSString *,NSNumber *>*>* gWarns;

- (int)powerBle;
- (float)temperatureBle;
- (int)humidityBle;

@end
