//
//  MyFileManager.m
//  TestOC
//
//  Created by tantao on 2018/12/6.
//  Copyright © 2018 tantao. All rights reserved.
//

#import "MyFileManager.h"

@implementation MyFileManager

/**
 获取创建路径

 @return 创建文件的路径
 */
+ (NSURL *)getCreatePath{
    NSArray <NSURL *>* urlForDocument = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * urlpath = urlForDocument.firstObject;
    return urlpath;
}

/**
 创建文件夹

 @param name 文件夹名字
 */
+ (void)createDirectory:(NSString *)name{
    
    NSURL * urlpath = [MyFileManager getCreatePath];
    urlpath = [urlpath URLByAppendingPathComponent:name];
    NSError * error;
    bool suc = [[NSFileManager defaultManager] createDirectoryAtURL:urlpath withIntermediateDirectories:true attributes:nil error:&error];
    if (!suc) {
        NSLog(@"%@",error.description);
    }
}

/**
 创建文件

 @param name 文件名
 @param data 文件内容
 */
+ (void)createFile:(NSString *)name Data:(NSData *)data InDirectory:(NSString *)directory{
    
    if (!data) {
        NSLog(@"\n\n data is null ! 不能创建空文件！ \n\n");
        return ;
    }
    NSURL * urlpath = [MyFileManager getCreatePath];
    //创建文件
    urlpath = [urlpath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",directory,name]];
    NSError * error;
    bool suc = [[NSFileManager defaultManager] createFileAtPath:urlpath.path contents:data attributes:nil];
    if (!suc) {
        NSLog(@"%@",error.description);
    }
}

/**
 读取文件

 @param directory 文件夹
 @param name 文件名
 @return {@"data":数据(NSData),@"url":文件路径(NSURL)}
 */
+ (NSDictionary *)readFile:(NSString *)directory Name:(NSString *)name{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    //读取文件
    NSArray <NSURL *>* urlsForDocDirectory = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * docPath = urlsForDocDirectory.firstObject;
    NSString * dirName = [NSString stringWithFormat:@"%@/%@",directory,name];
    NSURL * file = [docPath URLByAppendingPathComponent:dirName];
    NSData * redData = [manager contentsAtPath:file.path];
    if (!redData) {
        return [MyFileManager readFile2:directory Name:name];
    }
    return @{@"data":redData,
             @"url":file};
}

+ (NSDictionary *)readFile2:(NSString *)directory Name:(NSString *)name{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    //读取文件
    NSArray <NSURL *>* urlsForDocDirectory = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * docPath = urlsForDocDirectory.firstObject;
    NSString * dirName = [NSString stringWithFormat:@"%@/%@",directory,name];
    NSURL * file = [docPath URLByAppendingPathComponent:dirName];
    
    NSError * error;
    NSFileHandle * readHandler = [NSFileHandle fileHandleForReadingFromURL:file error:&error];
    NSData * redData = [readHandler readDataToEndOfFile];
    if (!redData) {
        NSLog(@"\n\n readFile - 数据为空 ！ \n\n");
        return nil;
    }
    return @{@"data":redData,
             @"url":file};
    
//    //方法1
//    let readHandler = try! FileHandle(forReadingFrom:file)
//    let data = readHandler.readDataToEndOfFile()
}

/**
 删除指定路径的文件（夹）

 @param url 路径
 */
+ (void)deleteFile:(NSURL *)url{

    NSFileManager * manager= [NSFileManager defaultManager];
    NSError *error;
    if ([manager removeItemAtURL:url error:&error]) {
        NSLog(@"delete suc");
    } else {
        NSLog(@"%@",error.description);
    }
}


@end
