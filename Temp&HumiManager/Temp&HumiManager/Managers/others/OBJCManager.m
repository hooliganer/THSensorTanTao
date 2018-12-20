//
//  OBJCManager.m
//  SweetHooligan
//
//  Created by 谭滔 on 2017/12/8.
//  Copyright © 2017年 谭滔. All rights reserved.
//

#import "OBJCManager.h"

#import <objc/runtime.h>

#import "NSDictionary+DIYDictionary.h"


unsigned int count;

static OBJCManager *manager;

@implementation OBJCManager

+ (OBJCManager *)sharedInstance{
    if (manager==nil) {
        manager=[[OBJCManager alloc]init];
    }
    return manager;
}

#pragma mark - outside method

/**
 * 将对象转换成json字符串
 */
- (NSString *)getJSON_StringWithObject:(id)object{
    
    NSString *className = NSStringFromClass([object class]);
    const char * cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    unsigned int outCount,i;
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    NSMutableArray *propertyNames = [[NSMutableArray alloc]initWithCapacity:1];
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyNameString = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyNames addObject:propertyNameString];
    }
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:1];
    for (NSString *key in propertyNames) {
        //SEL selector = NSSelectorFromString(key);
        //id value = [theObject performSelector:selector];
        id value = [object valueForKey:key];
        if (value == nil) {
            value = [NSNull null];
        }
        
        value = [self getObjectInternal:value];
        if (!value) {
            value = [[NSString alloc]initWithFormat:@"含敏感字符串的类名"];
        }
        
        [mDic setObject:value forKey:key];
    }
    NSString *jsonString = [mDic JSONString];
    
    return jsonString;
    
}

/**
 * 将对像(一般指自定义)转化成字典
 */
- (NSDictionary *)getDictionaryWithObject:(id)object{


    if (object == nil || [object isMemberOfClass:[NSNull class]]) {
        return nil;
    } else{
//        NSLog(@"object : %@",object);
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    
    for(int i = 0;i < propertyCount; i++){
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];

        if ([propertyName hasSuffix:@"Url"]) {
            continue ;
        }
        
        id value = [object valueForKey:propertyName];

//        NSLog(@"%d -- %d : %@",propertyCount,i,propertyName);
        if(value == nil){
            [dic setObject:[NSNull null] forKey:propertyName];
        } else{
            value = [self getObjectInternal:value];
            [dic setObject:value forKey:propertyName];
        }
    }
    //NSLog(@"json dic:%@",dic);
    free(properties);
    
    return dic;
}


/**
 * 将对象转换成json字符串,含有类名
 */
- (NSString *)getJSON_StringWith_ClassName_ByObject:(id)object{
    NSString *className = NSStringFromClass([object class]);
    const char * cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    unsigned int outCount,i;
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    NSMutableArray *propertyNames = [[NSMutableArray alloc]initWithCapacity:1];
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyNameString = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyNames addObject:propertyNameString];
    }
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:1];
    for (NSString *key in propertyNames) {
        //SEL selector = NSSelectorFromString(key);
        //id value = [theObject performSelector:selector];
        id value = [object valueForKey:key];
        if (value == nil) {
            value = [NSNull null];
        }
        
        value = [self getObjectInternal:value];
        if (!value) {
            value = [[NSString alloc]initWithFormat:@"含敏感字符串的类名"];
        }
        
        [mDic setObject:value forKey:key];
    }
    NSDictionary *finalDic = @{className:mDic};
    NSString *jsonString = [finalDic JSONString];
    
    return jsonString;
}

/**
 * 将对像(一般指自定义)转化成字典,含有类名
 */
- (NSDictionary *)getDictionaryWith_ClassName_ByObject:(id)object{
    
    NSString *className = NSStringFromClass([object class]);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    
    for(int i = 0;i < propertyCount; i++){
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([propertyName hasSuffix:@"Url"]) {
            continue;
        }
        
        id value = [object valueForKey:propertyName];
        
        if(value == nil){
            value = [NSNull null];
        }
        
        value = [self getObjectInternal:value];
        if (!value) {
            value = [[NSString alloc]initWithFormat:@"含敏感字符串的类名"];
        }
        [dic setObject:value forKey:propertyName];
        
    }
    //NSLog(@"json dic:%@",dic);
    free(properties);
    
    return @{className:dic};
}


+ (id)getObjectWithObject:(id)objcet{
    
    if ([objcet isKindOfClass:[NSString class]] || [objcet isKindOfClass:[NSNumber class]] || [objcet isKindOfClass:[NSNull class]]) {
        return objcet;
    }
    
    if ([objcet isKindOfClass:[NSArray class]]) {
        NSArray *array = objcet;
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:array.count];
        for (int i = 0; i < array.count; i++) {
            [marr setObject:[self getObjectWithObject:[array objectAtIndex:i]] atIndexedSubscript:i];
        }
        return marr;
    }
    if ([objcet isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = objcet;
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithCapacity:[objcet count]];
        for (NSString *key in dic.allKeys) {
            [mdic setObject:[self getObjectWithObject:[dic objectForKey:key]] forKey:key];
        }
        return mdic;
    }
    
    return [self getObjectWithObject:objcet];
}

- (id)objectWithDictionary:(NSDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    } else{
        return nil;
    }
}





/**
 * 输出对象所有属性名
 */
+ (NSArray<NSString *> *)properties_by_OBJC_Runtime:(id)object{
    
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    NSMutableArray *marr = [NSMutableArray array];
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
//        NSLog(@"property------>%@",[NSString stringWithUTF8String:propertyName]);
        [marr addObject:[NSString stringWithUTF8String:propertyName]];
    }
    return marr;
}

/**
 * 输出对象所有方法名
 */
- (void)print_methods_by_OBJC_Runtime:(id)object{
    Method *methodList = class_copyMethodList([object class], &count);
    for (unsigned int i=0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method -----> %@",NSStringFromSelector(method_getName(method)));
        
    }
}

/**
 * 输出对象所有ivar
 */
- (void)print_ivars_objc_runtime:(id)object{
    Ivar *ivarList = class_copyIvarList([object class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar ----->%@",[NSString stringWithUTF8String:ivarName]);
    }
}

/**
 * 输出对象所有协议
 */
- (void)print_protocols_objc_runtime:(id)object{
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([object class], &count);
    for (unsigned int i=0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
}



+ (id)object:(id)object ValueWithKey:(NSString *)key{

//    key = [@"_" stringByAppendingString:key];
//    NSLog(@"%@ %@",object,key);
//    const void * _Nonnull keyChar = [key UTF8String];
//    return objc_getAssociatedObject(object, keyChar);

    id propertyValue = [object valueForKey:key];
    return propertyValue;

//    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
//    unsigned int outCount = 0;
//    objc_property_t *properties =class_copyPropertyList([object class], &outCount);
//    for ( int i = 0; i<outCount; i++)
//    {
////        objc_property_t property = properties[i];
////        const char* char_f =property_getName(property);
////        NSString *propertyName = [NSString stringWithUTF8String:char_f];
////        id propertyValue = [self valueForKey:(NSString *)propertyName];
////        if (propertyValue) {
////            [propsDic setObject:propertyValue forKey:propertyName];
////        }
//    }
//    free(properties);
//    return propsDic;


////    //获取当前类
////    id theClass = [object class];
//
//    unsigned int count = 0;
//    //获取属性列表
//    Ivar *members = class_copyIvarList([object class], &count);
//
//    id value;
//    //遍历属性列表
//    for (int i = 0 ; i < count; i++) {
//        Ivar var = members[i];
//        //获取变量名称
//        const char *memberName = ivar_getName(var);
//        NSString *memberString = [NSString stringWithUTF8String:memberName];
////        NSLog(@"memberString : %@",memberString);
//        if ([key isEqualToString:memberString]) {
//            //获取变量类型
//            const char *memberType = ivar_getTypeEncoding(var);
//            NSLog(@"%s----%@", memberName, [NSString stringWithUTF8String:memberType]);
//            Ivar ivar = class_getInstanceVariable([object class], memberName);
//
//            if ([[NSString stringWithUTF8String:memberType] isEqualToString:@"d"]) {
//
//            } else{
//                value = object_getIvar(object, ivar);
//            }
//
//            break ;
//        }
//    }
//    //    NSString *typeStr = [NSString stringWithCString:memberType encoding:NSUTF8StringEncoding];
//    //    //判断类型
//    //    if ([typeStr isEqualToString:@"@\"NSString\""]) {
//    //        NSString *value = object_getIvar(theClass, ivar);
//    //        return value;
//    //        break ;
//    //    } else if ([typeStr isEqualToString:@"@\"NSNumber\""]){
//    //
//    //    } else if ([typeStr isEqualToString:@"@\"NSData\""]){
//    //
//    //    } else if ([typeStr isEqualToString:@"@\"NSDate\""]){
//    //
//    //    } else{
//    //
//    //    }

//    return value;
}


#pragma mark - inside method
/**
 * 判断参数是什么类型,转化之后进行返回
 */
- (id)getObjectInternal:(id)value{
    
    if ([value isKindOfClass:[NSObject class]]) {
        if ([value isKindOfClass:[NSString class]]) {
            //NSLog(@"string -> %@",value);
            //字符串类型
            return value;
        }
        else if ([value isKindOfClass:[NSArray class]]){
            //NSLog(@"array -> %@",value);
            //数组类型
            return [self getArrayWithArrValue:value];
        }
        else if ([value isKindOfClass:[NSDictionary class]]){
            //字典类型
            //NSLog(@"dictionary -> %@",value);
            return [self getDictionaryWithDicValue:value];
        }
        else if ([value isKindOfClass:[NSNumber class]]){
            //NSLog(@"number -> %@",value);
            //数字类型
            return [NSString stringWithFormat:@"%@",value];
        }
        else if ([value isKindOfClass:[NSNull class]]){
            return value;
        }
        else{
            //其他类型(自定义对象)
//            NSLog(@"%@ -- class : %@",value,[value class]);
            if ([NSStringFromClass([value class]) containsString:@"UI"]) {
//                NSLog(@"类 的关键词里边有“UI“");
                return [[NSString alloc]initWithFormat:@"含UI字符串的类名"];
            }
            else{
                NSLog(@"%@",NSStringFromClass([value class]));
                return [self getDictionaryWithObject:value];
            }
            
        }
    }
    else{
        NSLog(@"不是 NSObject 类型");
        return [NSNull null];
    }
    
    
}

/**
 * 将数组类型的对象及其所有元素值全转换后返回数组
 */
- (NSArray *)getArrayWithArrValue:(id)value{
    NSArray *arr=(NSArray *)value;
    NSMutableArray *marrer=[NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        id arrer=arr[i];
        id newArrer=[self getObjectInternal:arrer];
        if (newArrer) {
            [marrer addObject:newArrer];
        }
        else{
            [marrer addObject:@"敏感名称的对象"];
        }
        
    }
    return marrer;
}

/**
 * 将字典类型的对象及其所有value值全转换后返回字典
 */
- (NSDictionary *)getDictionaryWithDicValue:(id)value{
    NSDictionary *dic=(NSDictionary *)value;
    NSMutableDictionary *dicer=[NSMutableDictionary dictionary];
    for (int i=0;i<[dic allKeys].count;i++) {
        id dicKey=[dic allKeys][i];
        id newDic=[self getObjectInternal:dic[dicKey]];
        if (newDic) {
            [dicer setObject:newDic forKey:dicKey];
        }
        else{
            [dicer setObject:@"敏感名称的对象" forKey:dicKey];
        }
        
    }
    return dicer;
}

@end
