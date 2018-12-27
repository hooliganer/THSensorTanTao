//
//  WarnHistoryRecordDB+CoreDataClass.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/27.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WarnHistoryRecordDB : NSManagedObject

+ (WarnHistoryRecordDB *)newWarnHistoryRecord;

+ (WarnHistoryRecordDB *)readByTime:(NSTimeInterval)time;

+ (void)deleteAll;

+ (NSArray <WarnHistoryRecordDB *>*)readAll;
+ (NSArray <WarnHistoryRecordDB *>*)readAllByMac:(NSString *)mac;
+ (NSArray <WarnHistoryRecordDB *>*)readAllByMac:(NSString *)mac Time:(NSTimeInterval)time;

- (void)save;

+ (void)logAll;

@end

NS_ASSUME_NONNULL_END

#import "WarnHistoryRecordDB+CoreDataProperties.h"
