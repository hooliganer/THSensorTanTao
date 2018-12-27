//
//  WarnHistoryRecordDB+CoreDataProperties.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnHistoryRecordDB+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WarnHistoryRecordDB (CoreDataProperties)

+ (NSFetchRequest<WarnHistoryRecordDB *> *)fetchRequest;

@property (nonatomic) double time;
@property (nonatomic) float temparature;
@property (nonatomic) int16_t humidity;
@property (nullable, nonatomic, copy) NSString *mac;
@property (nullable, nonatomic, copy) NSString *sdata;
@property (nonatomic) int16_t power;

@end

NS_ASSUME_NONNULL_END
