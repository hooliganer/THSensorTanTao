//
//  AFManager+WarningSetRecord.m
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/24.
//  Copyright © 2018 terry. All rights reserved.
//

#import "AFManager+WarningSetRecord.h"

@implementation AFManager (WarningSetRecord)

- (void)selectLastWarnSetRecordWithMac:(NSString *)mac Block:(nonnull void (^)(WarnSetRecord * _Nonnull))block{
    // /aircondition/dev/query_dev_trigger_history.jsp? 参数：mac= ，stype=4，all=yes，
    [self queryWithMac:mac Block:^(NSArray<NSDictionary *> *triggers) {
       
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
    
    [self queryWithMac:mac Block:^(NSArray<NSDictionary *> *triggers) {
        
//        NSLog(@"%@",triggers);
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


#pragma mark - 私有方法

- (void)queryWithMac:(NSString *)mac Block:(void (^)(NSArray <NSDictionary *>*triggers))block{
    
    NSString * url = [NSString stringWithFormat:@"http://%@:%@/aircondition/dev/query_dev_trigger_history.jsp?",TH_IP,TH_PORT];
    NSDictionary * param = @{
                             @"mac":mac,
                             @"stype":@"4",
                             @"all":@"yes"
                             };
    [self.sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithXMLData:responseObject];
        NSArray * triggers = dic[@"trigger"];
        block(triggers);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        block(nil);
    }];
}

@end
