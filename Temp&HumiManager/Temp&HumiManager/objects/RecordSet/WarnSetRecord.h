//
//  WarnSetRecord.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/24.
//  Copyright © 2018 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 阈值的值与时间
 */
struct WarnSetRecordValueTime {
    NSTimeInterval time;
    float value;
};
typedef struct CG_BOXABLE WarnSetRecordValueTime WarnSetRecordValueTime;

CG_INLINE WarnSetRecordValueTime
WarnSetRecordValueTimeMake(float value,NSTimeInterval time)
{
    WarnSetRecordValueTime ws;
    ws.value = value;
    ws.time = time;
    return ws;
}


/**
 阈值结构体
 */
struct WarnSetRecordThreshold {
    WarnSetRecordValueTime tempMax;
    WarnSetRecordValueTime tempMin;
    WarnSetRecordValueTime humiMax;
    WarnSetRecordValueTime humiMin;
};
typedef struct CG_BOXABLE WarnSetRecordThreshold WarnSetRecordThreshold;

CG_INLINE WarnSetRecordThreshold
WarnSetRecordThresholdDefault()
{
    WarnSetRecordThreshold ws;
    ws.humiMax = WarnSetRecordValueTimeMake(50, 0);
    ws.humiMin = WarnSetRecordValueTimeMake(10, 0);
    ws.tempMax = WarnSetRecordValueTimeMake(30, 0);
    ws.tempMin = WarnSetRecordValueTimeMake(0, 0);
    return ws;
}


typedef NS_OPTIONS(int, WarnSetValueType) {
    WarnSetValueType_TempMax ,
    WarnSetValueType_HumiMax ,
    WarnSetValueType_TempMin ,
    WarnSetValueType_HumiMin ,
};


@interface WarnSetRecord : NSObject

@property (nonatomic,assign)bool ison;
@property (nonatomic,copy)NSString * info;///<info 前两个字节为类型 01 - 表示该值为温度最小值 02 - 温度最大值 03 - 湿度最小值 04 - 湿度最大值 
@property (nonatomic,copy)NSString * mac;
@property (nonatomic,copy)NSString * oco;
@property (nonatomic,copy)NSString * opr;
@property (nonatomic,assign)NSTimeInterval settime;
@property (nonatomic,assign)float tvalue;///<（此值只有当按类型区分时才有意义）

@property (nonatomic)WarnSetRecordThreshold threshold;///<阈值，包括温度、湿度的最值，及其设置时间 (此值只有当按时间区分时才有效)

@property (nonatomic,assign)WarnSetValueType valueType;///<值的类型（此值只有当按类型区分时才有效）

/**
 字典转对象

 @param dict 只会赋予字典里的值,其他对象需另外赋予
 @return WarnSetRecord对象
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
