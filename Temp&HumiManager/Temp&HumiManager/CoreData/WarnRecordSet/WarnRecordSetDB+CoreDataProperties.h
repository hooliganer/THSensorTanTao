//
//  WarnRecordSetDB+CoreDataProperties.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnRecordSetDB+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WarnRecordSetDB (CoreDataProperties)

+ (NSFetchRequest<WarnRecordSetDB *> *)fetchRequest;

@property (nonatomic) double settime;
@property (nullable, nonatomic, copy) NSString *mac;
@property (nonatomic) BOOL ison;
@property (nonatomic) float tempMax;
@property (nonatomic) float tempMin;
@property (nonatomic) int16_t humiMax;
@property (nonatomic) int16_t humiMin;
@property (nullable, nonatomic, retain) DeviceDB *device;

@end

NS_ASSUME_NONNULL_END
