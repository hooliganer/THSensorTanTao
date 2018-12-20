//
//  DeviceInfo+DeviceInfoExtension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DeviceInfo.h"

/*************** 枚举 SensorType ***************/

typedef NS_OPTIONS(int, SensorType) {
    SensorType_Temparature = 1 ,
    SensorType_Humidity = 2 ,
};


/*************** - 结构体 DevicePost - ***************/

typedef struct {
    double x;
    double y;
} DevicePost;///<坐标

CG_INLINE DevicePost
DevicePostMake(double x,double y)
{
    DevicePost dp;
    dp.x = x;
    dp.y = y;
    return dp;
}

CG_INLINE NSString *
NSStringFromDevicePost(DevicePost dp)
{
    return [NSString stringWithFormat:@"%f,%f",dp.x,dp.y];
}

CG_INLINE DevicePost
DevicePostFromString(NSString *string)
{
    double x = [[string getFormerStringOfAString:@","] doubleValue];
    double y = [[string getLaterStringOfAString:@","] doubleValue];
    return DevicePostMake(x, y);
}


typedef struct {
    SensorType type;///<数据类型
    float value;///<数据值
} MemberSensor;///<成员数据






