//
//  MyArchiverManager.m
//  TestAll
//
//  Created by terry on 2018/4/8.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyArchiverManager.h"

#define GlobalObjectPathComponent @"APPGlobalObject.archiver"
#define GlobalObjectCodeKey @"GolbalInfo"

@implementation MyArchiverManager

+ (MyArchiverManager *)sharedInstance{
    static MyArchiverManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyArchiverManager alloc]init];
    });
    return manager;
}

- (NSString *)filePathWithComponent:(NSString *)component{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, true)firstObject]stringByAppendingPathComponent:component];
}

- (void)saveGlobalObject:(APPGlobalObject *)object{
    NSString *path = [self filePathWithComponent:GlobalObjectPathComponent];
    NSMutableData *mdata = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:mdata];
    [archiver encodeObject:object forKey:GlobalObjectCodeKey];
    [archiver finishEncoding];
    [mdata writeToFile:path atomically:true];
}

- (APPGlobalObject *)readGlobalObject{
    NSString *path = [self filePathWithComponent:GlobalObjectPathComponent];
    NSMutableData *datR = [[NSMutableData alloc]initWithContentsOfFile:path];
    if (datR) {
        NSKeyedUnarchiver *unchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datR];
        APPGlobalObject *arch = [unchiver decodeObjectForKey:GlobalObjectCodeKey];
        [unchiver finishDecoding];
        return arch;
    } else{
        return nil;
    }

}

@end
