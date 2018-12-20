//
//  APPGlobalObject.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/26.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 全局使用的对象
 */
@interface APPGlobalObject : NSObject

@property (nonatomic,copy)NSString *wifiName;
@property (nonatomic,copy)NSString *wifiPwd;
@property (nonatomic,assign)bool unitType;///<false is ˚C,true is ˚F
@property (nonatomic,assign)int closeSec;
@property (nonatomic,assign)int closeMin;
@property (nonatomic,assign)bool isWifiType;///<true is Wi-Fi模式，Wi-Fi有分组
//@property (nonatomic,strong)NSMutableDictionary *devIsAlert;
//@property (nonatomic,strong)NSMutableDictionary *devLmtValue;///<@{ MAC : @{@"tempLess":x , @"tempOver":x ,@"humiLess":x ,@"humiOver"}}

@end
