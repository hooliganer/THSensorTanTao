//
//  NSDictionary+DIYDictionary.h
//  SweetHooligan
//
//  Created by 谭滔 on 2017/12/8.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DIYDictionary)

/**
 * 将字典换乘json字符串(注意:字典里面的值不能含有自定义之类的对象，否则报错)
 */
- (NSString *)JSONString;

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString;

@end
