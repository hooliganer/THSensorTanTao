//
//  methoder.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/28.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "methoder.h"

void async_bgqueue(dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, block);
}

void sync_bgqueue(dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_sync(queue, block);
}

//得到线程字符串形式
NSString *stringQueue(dispatch_queue_t queue) {
    const char * charLabel = dispatch_queue_get_label(queue);
    return [NSString stringWithUTF8String:charLabel];
}

//当前queue
dispatch_queue_t currentQueue(void) {
    return dispatch_queue_create(DISPATCH_CURRENT_QUEUE_LABEL, nil);
}

//判断两个queue是不是一个queue
bool equalQueue(dispatch_queue_t q1,dispatch_queue_t q2) {
    return [stringQueue(q1) isEqualToString:stringQueue(q2)];
}

dispatch_source_t gcd_timer(dispatch_source_t timer,uint64_t repettime,dispatch_queue_t queue,dispatch_block_t handler) {
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, repettime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, handler);
    dispatch_resume(timer);
    return timer;
}



