//
//  WarnConfirm+CoreDataProperties.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/28.
//  Copyright © 2018 terry. All rights reserved.
//
//

#import "WarnConfirm+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WarnConfirm (CoreDataProperties)

+ (NSFetchRequest<WarnConfirm *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *mac;
@property (nonatomic) double time;

@end

NS_ASSUME_NONNULL_END
