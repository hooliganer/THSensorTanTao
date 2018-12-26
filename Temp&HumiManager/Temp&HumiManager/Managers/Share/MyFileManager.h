//
//  MyFileManager.h
//  TestOC
//
//  Created by tantao on 2018/12/6.
//  Copyright © 2018 tantao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyFileManager : NSObject



/**
 获取创建路径
 
 @return 创建文件的路径
 */
+ (NSURL *)getCreatePath;

/**
 创建文件夹
 
 @param name 文件夹名字
 */
+ (void)createDirectory:(NSString *)name;

/**
 创建文件
 
 @param name 文件名
 @param data 文件内容
 @param directory 文件夹
 */
+ (void)createFile:(NSString *)name Data:(NSData *)data InDirectory:(NSString *)directory;

/**
 读取文件
 
 @param directory 文件夹
 @param name 文件名
 @return {@"data":数据(NSData),@"url":文件路径(NSURL)}
 */
+ (NSDictionary *)readFile:(NSString *)directory Name:(NSString *)name;

/**
 删除指定路径的文件（夹）
 
 @param url 路径
 */
+ (void)deleteFile:(NSURL *)url;



@end

NS_ASSUME_NONNULL_END
