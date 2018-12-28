//
//  WarnConfirm+CoreDataClass.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/28.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WarnConfirm : NSManagedObject

+ (WarnConfirm *)newWarnConfirm;
+ (WarnConfirm *)readByMac:(NSString *)mac;
- (void)save;

@end

NS_ASSUME_NONNULL_END

#import "WarnConfirm+CoreDataProperties.h"
