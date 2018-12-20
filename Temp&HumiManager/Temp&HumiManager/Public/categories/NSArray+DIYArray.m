//
//  NSArray+DIYArray.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "NSArray+DIYArray.h"

@implementation NSArray (DIYArray)

- (NSNumber *)maxNumber{
    NSNumber *max = [self firstObject];
    for (int i=0; i<self.count; i++) {
        NSNumber *number = self[i];
        switch ([number compare:max]) {
            case NSOrderedDescending://降序（左 > 右)
                max = number;
                break;

            default:
                break;
        }
    }
    return max;
}

- (NSNumber *)minNumber{
    NSNumber *min = [self firstObject];
    for (int i=0; i<self.count; i++) {
        NSNumber *number = self[i];
        switch ([number compare:min]) {

            case NSOrderedAscending://升序 (左 < 右)
                min = number;
                break;

            default:
                break;
        }
    }
    return min;
}

/*!
 * 转换成浮点数进行求平均值
 */
- (NSNumber *)avgNumber{
    if (self.count == 0) {
        return 0;
    }
    float sum = 0;
    for (NSNumber *vol in self) {
        sum += [vol floatValue];
    }
    return @(sum/floor(self.count));
}







+ (bool)isAllEqualCountArrays:(NSArray *)firstArray,... NS_REQUIRES_NIL_TERMINATION
{
    if(firstArray == nil){
        LRLog(@"nil array can`t isAllEqualCountArrays:");
        return false;
    }

    bool isEqual = true;
    va_list args; ///< VA_LIST 是在C语言中解决变参问题的一组宏
    // VA_START宏，获取可变参数列表的第一个参数的地址,在这里是获取firstObj的内存地址,这时argList的指针 指向firstObj
    va_start(args, firstArray);
    NSUInteger count = firstArray.count;
    // VA_ARG宏，获取可变参数的当前参数，返回指定类型并将指针指向下一参数
    // 首先 argList的内存地址指向的fristObj将对应储存的值取出,如果不为nil则判断为真,将取出的值房在数组中,
    //并且将指针指向下一个参数,这样每次循环argList所代表的指针偏移量就不断下移直到取出nil
    for(NSArray *arr = firstArray;arr != nil;arr = va_arg(args, NSArray *)){
        if (count != arr.count) {
            isEqual = false;
            break ;
        }
    }
    // 清空列表
    va_end(args);
    return isEqual;
}

@end
