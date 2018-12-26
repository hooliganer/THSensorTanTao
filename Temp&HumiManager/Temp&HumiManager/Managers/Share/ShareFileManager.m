//
//  ShareFileManager.m
//  TestOC
//
//  Created by tantao on 2018/12/26.
//  Copyright © 2018 tantao. All rights reserved.
//

#import "ShareFileManager.h"
#import "MyFileManager.h"

@interface ShareFileManager ()
<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong)UIDocumentInteractionController * documentController;

@property (nonatomic,strong)UIViewController * controller;

@end

@implementation ShareFileManager

+ (ShareFileManager *)shared{
    static dispatch_once_t onceToken;
    static ShareFileManager * manager;
    dispatch_once(&onceToken, ^{
        manager = [[ShareFileManager alloc]init];
    });
    return manager;
}

- (void)shareTXTName:(NSString *)name Substance:(NSString *)substance InController:(UIViewController *)controller{
    
    //文件夹文件名
    NSString * directory = @"share_TXT_directory";
    
    name = [name stringByAppendingString:@".txt"];
    //创建文件夹
    [MyFileManager createDirectory:directory];
    
    //创建文件(随机字符串)
    NSData * data = [substance dataUsingEncoding:NSUTF8StringEncoding];
    [MyFileManager createFile:name Data:data InDirectory:directory];
    
    //读取文件
    NSDictionary * dic = [MyFileManager readFile:directory Name:name];
    NSURL * file = [dic valueForKey:@"url"];
    
    if (!file) {
        return ;
    }
    
    self.controller = controller;
    
    //展示分享框
    [self showShare:file.path];
}

- (void)shareCSVName:(NSString *)name Substance:(NSString *)substance InController:(UIViewController *)controller{
    
    //文件夹文件名
    NSString * directory = @"share_TXT_directory";
    
    name = [name stringByAppendingString:@".csv"];
    //创建文件夹
    [MyFileManager createDirectory:directory];
    
    //创建文件(随机字符串)
    NSData * data = [substance dataUsingEncoding:NSUTF8StringEncoding];
    [MyFileManager createFile:name Data:data InDirectory:directory];
    
    //读取文件
    NSDictionary * dic = [MyFileManager readFile:directory Name:name];
    NSURL * file = [dic valueForKey:@"url"];
    
    if (!file) {
        return ;
    }
    
    self.controller = controller;
    
    //展示分享框
    [self showShare:file.path];
}

/**
 展示分享视图
 
 @param filePath 路径
 */
- (void)showShare:(NSString *)filePath{
    
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentController.delegate = self;
    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.controller.view animated:YES];
    
}


#pragma mark - Delegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self.controller;
}


- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    
    //完成后删除
    [MyFileManager deleteFile:controller.URL];
    
}

@end
