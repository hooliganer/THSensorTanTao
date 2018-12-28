//
//  AFManager+WarningSetRecord.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/24.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+WarningSetRecord.h"

@implementation AFManager (WarningSetRecord)

- (void)selectLastWarnSetRecordWithMac:(NSString *)mac Block:(nonnull void (^)(WarnSetRecord *))block{
    // /aircondition/dev/query_dev_trigger_history.jsp? 参数：mac= ，stype=4，all=yes，
    [self queryWithMac:mac IsShort:true Block:^(NSArray<NSDictionary *> *triggers) {
        
        if (triggers.count == 0) {
            if (block) {
                block(nil);
            }
            return ;
        }
        
        NSDictionary * trigger = triggers.firstObject;
        WarnSetRecord * record = [[WarnSetRecord alloc]initWithDictionary:trigger];
        WarnSetRecordThreshold threshold = WarnSetRecordThresholdDefault();
        
        for (NSDictionary *tt in triggers) {
            NSString * info = [tt[@"info"] substringWithRange:NSMakeRange(0, 2)];
            NSTimeInterval time = [tt[@"settime"] doubleValue];
            float value = [tt[@"tvalue"] floatValue];
            if ([info isEqualToString:@"01"]) {
                threshold.tempMin = WarnSetRecordValueTimeMake(value, time);
                break ;
            }
        }
        for (NSDictionary *tt in triggers) {
            NSString * info = [tt[@"info"] substringWithRange:NSMakeRange(0, 2)];
            NSTimeInterval time = [tt[@"settime"] doubleValue];
            float value = [tt[@"tvalue"] floatValue];
            if ([info isEqualToString:@"02"]) {
                threshold.tempMax = WarnSetRecordValueTimeMake(value, time);
                break ;
            }
        }
        for (NSDictionary *tt in triggers) {
            NSString * info = [tt[@"info"] substringWithRange:NSMakeRange(0, 2)];
            NSTimeInterval time = [tt[@"settime"] doubleValue];
            float value = [tt[@"tvalue"] floatValue];
            if ([info isEqualToString:@"03"]) {
                threshold.humiMin = WarnSetRecordValueTimeMake(value, time);
                break ;
            }
        }
        for (NSDictionary *tt in triggers) {
            NSString * info = [tt[@"info"] substringWithRange:NSMakeRange(0, 2)];
            NSTimeInterval time = [tt[@"settime"] doubleValue];
            float value = [tt[@"tvalue"] floatValue];
            if ([info isEqualToString:@"04"]) {
                threshold.humiMax = WarnSetRecordValueTimeMake(value, time);
                break ;
            }
        }
        record.threshold = threshold;
        if (block) {
            block(record);
        }
    }];
}

- (void)selectAllWarnRecordSetWithMac:(NSString *)mac Block:(nonnull void (^)(NSArray<WarnSetRecord *> * _Nonnull, NSArray<WarnSetRecord *> * _Nonnull, NSArray<WarnSetRecord *> * _Nonnull, NSArray<WarnSetRecord *> * _Nonnull))block{
    
    [self queryWithMac:mac IsShort:false Block:^(NSArray<NSDictionary *> *triggers) {
        
        NSMutableDictionary *res = [NSMutableDictionary dictionary];
        
        for (NSDictionary *dic in triggers){
            NSString * info = [dic[@"info"] substringWithRange:NSMakeRange(0, 2)];
            if (res[info]){
                [res[info] addObject:dic];
            }
            else{
                res[info] = [NSMutableArray arrayWithObject:dic];
            }
        }
        
        NSArray * arr01 = res[@"01"];
        NSArray * arr02 = res[@"02"];
        NSArray * arr03 = res[@"03"];
        NSArray * arr04 = res[@"04"];
        
        NSMutableArray * tpmins = [NSMutableArray array];
        for (NSDictionary * dic in arr01) {
            WarnSetRecord * wsr = [[WarnSetRecord alloc]initWithDictionary:dic];
            wsr.valueType = WarnSetValueType_TempMin;
            [tpmins addObject:wsr];
        }
        
        NSMutableArray * tpmaxs = [NSMutableArray array];
        for (NSDictionary * dic in arr02) {
            WarnSetRecord * wsr = [[WarnSetRecord alloc]initWithDictionary:dic];
            wsr.valueType = WarnSetValueType_TempMax;
            [tpmaxs addObject:wsr];
        }
        
        NSMutableArray * hmmins = [NSMutableArray array];
        for (NSDictionary * dic in arr03) {
            WarnSetRecord * wsr = [[WarnSetRecord alloc]initWithDictionary:dic];
            wsr.valueType = WarnSetValueType_HumiMin;
            [hmmins addObject:wsr];
        }
        
        NSMutableArray * hmmaxs = [NSMutableArray array];
        for (NSDictionary * dic in arr04) {
            WarnSetRecord * wsr = [[WarnSetRecord alloc]initWithDictionary:dic];
            wsr.valueType = WarnSetValueType_HumiMax;
            [hmmaxs addObject:wsr];
        }
        
        if (block) {
            block(tpmaxs,tpmins,hmmaxs,hmmins);
        }
    }];
}

- (void)setWarnWithMac:(NSString *)mac Type:(NSString *)type IsOn:(bool)ison Uid:(int)uid Value:(NSNumber *)value{
    
    // http://www.easyhomeai.com:8080/aircondition/dev/set_dev_trigger.jsp?isbiger=0&enable=0&mac=CF1206168A6D&uid=5&otype=10&ocode=03&save=yes&stype=01&value=30
    // /aircondition/dev/set_dev_trigger.jsp?
    // 参数 mac= ，stype= 数据类型 01 - 表示该值为温度最小值 02 - 温度最大值 03 - 湿度最小值 04 - 湿度最大值 isbiger=0,enable= 当前报警开关 0 - 关 1 - 开； otype=10；ocode=03；uid 用户id value=值，save=yes，表示保存；
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/dev/set_dev_trigger.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{@"mac":mac,
                             @"stype":type,
                             @"isbiger":@"0",
                             @"enable":@(ison),
                             @"uid":@(uid),
                             @"otype":@"10",
                             @"ocode":@"03",
                             @"value":value,
                             @"save":@"yes"};
//    NSString * fl = [self fullUrl:url Param:param];
    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - 私有方法

- (void)queryWithMac:(NSString *)mac IsShort:(bool)isShort Block:(void (^)(NSArray <NSDictionary *>*triggers))block{
    
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/dev/query_dev_trigger_history.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{
                             @"mac":mac,
                             @"stype":@"4",
                             @"all":!isShort?@"yes":@"no"
                             };

    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"------%@",mac);
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        NSArray * triggers = dic[@"trigger"];
        block(triggers);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        block(nil);
    }];
}

@end
