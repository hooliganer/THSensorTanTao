//
//  WarnSetRecord.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/24.
//  Copyright © 2018 terry. All rights reserved.
//

#import "WarnSetRecord.h"

@implementation WarnSetRecord

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict) {
            self.ison = [dict[@"enable"] boolValue];
            self.info = dict[@"info"];
            self.mac = dict[@"mac"];
            self.oco = dict[@"oco"];
            self.opr = dict[@"opr"];
            self.settime = [dict[@"settime"] doubleValue];
            self.tvalue = [dict[@"tvalue"] floatValue];
        } else {
            LRLog(@"初始化WarnSetRecord时dictionary为空！");
        }
    }
    return self;
}

@end
