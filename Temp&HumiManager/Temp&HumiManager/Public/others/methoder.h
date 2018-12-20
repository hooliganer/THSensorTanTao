//
//  methoder.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/28.
//  Copyright © 2018年 terry. All rights reserved.
//

/**
 * C 类
 */


#import <Foundation/Foundation.h>


/*!
 * 异步后台线程
 */
void async_bgqueue(dispatch_block_t block);

/*!
 * 同步后台线程
 */
void sync_bgqueue(dispatch_block_t block);

/*!
 * 得到线程字符串形式
 */
NSString *stringQueue(dispatch_queue_t queue);

/*!
 * 当前queue
 */
dispatch_queue_t currentQueue(void);

/*!
 * 判断两个queue是不是一个queue
 */
bool equalQueue(dispatch_queue_t q1,dispatch_queue_t q2);

/*!
 * GCD timer
 */
dispatch_source_t gcd_timer(dispatch_source_t timer,uint64_t repettime,dispatch_queue_t queue,dispatch_block_t handler);



