//
//  NSDictionary+DIYDictionary.m
//  SweetHooligan
//
//  Created by 谭滔 on 2017/12/8.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "NSDictionary+DIYDictionary.h"

@implementation NSDictionary (DIYDictionary)


/**
 * 将字典换乘json字符串(注意:字典里面的值不能含有自定义之类的对象，否则报错)
 */
- (NSString *)JSONString{
        
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"error:%@",error);
    }
    else{
        jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mString = [NSMutableString stringWithString:jsonString];
    NSRange range = NSMakeRange(0, jsonString.length);
    [mString replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    range = NSMakeRange(0, mString.length);
    [mString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    return mString;

}




+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error){
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

@end
