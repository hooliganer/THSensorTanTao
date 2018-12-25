//
//  DeviceDB+CoreDataProperties.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/16.
//  Copyright © 2018年 terry. All rights reserved.
//
//

#import "DeviceDB+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeviceDB (CoreDataProperties)

+ (NSFetchRequest<DeviceDB *> *)fetchRequest;

@property (nonatomic) BOOL isWarn;
@property (nonatomic) float lessTemper;
@property (nonatomic) float overTemper;
@property (nonatomic) float lessHumidi;
@property (nonatomic) float overHumidi;
@property (nullable, nonatomic, copy) NSString *mac;
@property (nonatomic) double tempTime;
@property (nonatomic) double humiTime;
@property (nullable, nonatomic, copy) NSString *dbName;
@property (nonatomic) int16_t devType;

@end

NS_ASSUME_NONNULL_END
