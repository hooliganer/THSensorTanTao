//
//  OBJCManager.h
//  SweetHooligan
//
//  Created by 谭滔 on 2017/12/8.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJCManager : NSObject

+ (OBJCManager *)sharedInstance;

/**
 * 将对象转换成json字符串,不含有类名
 */
- (NSString *)getJSON_StringWithObject:(id)object;

/**
 * 将对像(一般指自定义)转化成字典,不含有类名
 */
- (NSDictionary *)getDictionaryWithObject:(id)object;

- (id)objectWithDictionary:(NSDictionary *)dictionary;

/**
 * 将对象转换成json字符串,含有类名
 */
- (NSString *)getJSON_StringWith_ClassName_ByObject:(id)object;

/**
 * 将对像(一般指自定义)转化成字典,含有类名
 */
- (NSDictionary *)getDictionaryWith_ClassName_ByObject:(id)object;


/**
 * 字典、数组转换成对象
 */
+ (id)getObjectWithObject:(id)objcet;



/**
 * 输出对象所有属性名
 */
+ (NSArray<NSString *> *)properties_by_OBJC_Runtime:(id)object;

/**
 * 输出对象所有方法名
 */
- (void)print_methods_by_OBJC_Runtime:(id)object;

/**
 * 输出对象所有ivar
 */
- (void)print_ivars_objc_runtime:(id)object;

/**
 * 输出对象所有协议
 */
- (void)print_protocols_objc_runtime:(id)object;


/**
 * 获取对象的值
 */
+ (id)object:(id)object ValueWithKey:(NSString *)key;


+ (void)logObject:(id)objc;


@end
