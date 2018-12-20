//
//  MainCollectionObject+MainCollectionObjectExtension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/24.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MainCollectionObject.h"

/*！
 * 判断数组是否存在的参数
 */
typedef struct {
    NSInteger index;///<是第几个相同（以遇见的第一个判断）
    bool isExist;///<是否存在
} IsContain;

CG_INLINE IsContain
IsContainMake(NSInteger i,bool is)
{
    IsContain ic;
    ic.index = i;
    ic.isExist = is;
    return ic;
}


/*!
 * 阈值结构min~max
 */
typedef struct {
    float min;
    float max;
} ThresholdValue;

CG_INLINE ThresholdValue
ThresholdMake(float min,float max)
{
    ThresholdValue stru;
    stru.min = min;
    stru.max = max;
    return stru;
}


typedef NS_OPTIONS(int, MCODataType) {
    MCODataType_None ,///<没有数据
    MCODataType_Wifi ,///<网络数据
    MCODataType_Ble ,///<蓝牙数据
};

