//
//  ConstNotification.h
//  Temp&HumiManager
//
//  Created by terry on 2018/6/20.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const NotiName_ToBleSetControler;///<向设置界面通知发现新蓝牙设备,传递的是 MyPeripheral 参数
extern NSString * const NotiName_ToBLEController;///<向设置界面通知发现新蓝牙设备,传递的是 MyPeripheral 参数


/*！
 * 判断数组是否存在的参数
 */
typedef struct {
    NSInteger index;///<是第几个相同（以遇见的第一个判断）
    bool isExist;///<是否存在
} ContainStruct;

CG_INLINE ContainStruct
ContainStructMake(NSInteger i,bool is)
{
    ContainStruct ic;
    ic.index = i;
    ic.isExist = is;
    return ic;
}

