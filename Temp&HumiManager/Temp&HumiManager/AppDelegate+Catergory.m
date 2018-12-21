//
//  AppDelegate+Catergory.m
//  Temp&HumiManager
//
//  Created by terry on 2018/9/5.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "AppDelegate+Catergory.h"

#import "HTTP_ReigistUser.h"
#import "AFManager+AFAutoRegister.h"

#include <signal.h>
#include <execinfo.h>

@implementation AppDelegate (Catergory)

/**
 判断本地是否有用户，无则注册
 */
- (void)judgeHasUser{

    dispatch_queue_t bgqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(bgqueue, ^{

        UserInfo *user = [MyDefaultManager userInfo];
        if (!user) {
            //注册用户
            [[AFManager shared] autoFirstRegistUser:^(bool success, NSString * _Nonnull info) {
                if (!success) {
                    LRLog(@"%@",info);
                }
            }];
        }
    });
}


- (void)initCrashHandler{
    
    struct sigaction newSignalAction;
    memset(&newSignalAction, 0,sizeof(newSignalAction));
    newSignalAction.sa_handler = &signalHandler;
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGSEGV, &newSignalAction, NULL);
    sigaction(SIGFPE, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    sigaction(SIGPIPE, &newSignalAction, NULL);

    //异常时调用的函数
    NSSetUncaughtExceptionHandler(&handleExceptions);
}

/**
 - 4.分析Crash
 >4.1 从```exception```中得知Crash原因为Array中写了一个为nil的Object。
 >4.2 从```callStackSymbols```堆栈符号中找到Crash的是第2条信息，堆栈列表可以理解为第0条为正在运行的，而该列表的第22是最早运行的，因此我们可以Crash的那条往下看可以知道这条Crash发生在```[ViewController viewDidLoad]```，即```ViewController```控制器的```viewDidLoad```方法中。

 - 5.注意事项
 >5.1 由于```NSSetUncaughtExceptionHandler```是```set```方法，所以只能设置一次，市面上很多抓Crash的库都会设置这个方法，因此，如果你用了UMeng Crash，Bugly（腾讯云内继承Bugly）等工具的话，最好不要自己设置，会影响Crash上报。
 */

void handleExceptions(NSException *exception) {
    NSLog(@"exception = %@",exception);
    NSLog(@"callStackSymbols = %@",[exception callStackSymbols]);
}

void signalHandler(int sig) {
    //最好不要写，可能会打印太多内容
    NSLog(@"signal = %d", sig);
}

@end
