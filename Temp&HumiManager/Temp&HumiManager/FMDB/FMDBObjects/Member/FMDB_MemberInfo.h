//
//  FMDB_MemberInfo.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "SuperFMDBManager.h"
#import "FMDB_MemberInfo+MemberInfoExtension.h"
#import <CoreLocation/CoreLocation.h>


@interface FMDB_MemberInfo : SuperFMDBManager

/**
 * 经纬度
 */
@property (nonatomic)CLLocationCoordinate2D coordinate;
/**
 * 设备ID
 */
@property (nonatomic,assign)NSInteger dID;
/**
 * Mac
 */
@property (nonatomic,copy)NSString *mac;
/**
 * 注册时间
 */
@property (nonatomic,assign)NSTimeInterval dateline;
/**
 * 城市码？随便吧
 */
@property (nonatomic,copy)NSString *cityCode;
/**
 * 邮箱
 */
@property (nonatomic,copy)NSString *email;
/**
 * 类型
 */
@property (nonatomic,assign)int dType;
/**
 * nio
 */
@property (nonatomic,copy)NSString *nio;
/**
 * 状态
 */
@property (nonatomic,assign)NSInteger state;
/**
 * 名称
 */
@property (nonatomic,copy)NSString *showName;

@property (nonatomic,copy)NSString *nickName;

@property (nonatomic,copy)NSString *rid;

@property (nonatomic,copy)NSString *motostep;

@property (nonatomic,strong)NSMutableArray <NSValue *>* sensors;///<元素是MemberSensor的结构体

/**
 * 密码
 */
@property (nonatomic,copy)NSString *password;

- (void)addSensorToSelfSensors:(MemberSensor)sensor;
- (MemberSensor)MemberSensorValue:(NSValue *)value;

- (instancetype)initWithNewMember:(FMDB_MemberInfo *)member;

@end
