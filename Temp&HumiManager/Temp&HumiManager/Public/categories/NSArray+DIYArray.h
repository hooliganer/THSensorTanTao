//
//  NSArray+DIYArray.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DIYArray)

- (NSNumber *)maxNumber;
- (NSNumber *)minNumber;
/*!
 * 转换成浮点数进行求平均值
 */
- (NSNumber *)avgNumber;

/*!
 * 判断所有数组是否都是一样的长度
 */
+ (bool)isAllEqualCountArrays:(NSArray *)firstArray,... NS_REQUIRES_NIL_TERMINATION;

@end
