//
//  TH_GroupInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"

/*!
 * 分组信息
 */
@interface TH_GroupInfo : NSObject

@property (nonatomic,copy)NSString *mac;///<Mac
@property (nonatomic,assign)int gid;
@property (nonatomic,assign)int type;
@property (nonatomic,copy)NSString *name;///<名称
@property (nonatomic,assign)int state;
@property (nonatomic,assign)NSTimeInterval dateline;
@property (nonatomic,copy)NSString * appSID;
@property (nonatomic,assign)bool online;
@property (nonatomic,assign)int mCount;

@property (nonatomic,strong)NSMutableArray <DeviceInfo *>*devices;

//@property (nonatomic,assign)bool flex;

- (instancetype)initWithNewRoomInfo:(TH_GroupInfo *)newInfo;

@end
