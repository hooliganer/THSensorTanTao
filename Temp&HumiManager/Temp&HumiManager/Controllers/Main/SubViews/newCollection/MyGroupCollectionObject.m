//
//  MyGroupCollectionObject.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/25.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyGroupCollectionObject.h"

@implementation MyGroupCollectionObject

- (instancetype)init{
    if (self = [super init]) {
        self.infos = [NSMutableArray array];
        self.groupInfo = [[TH_GroupInfo alloc]init];
    }
    return self;
}




@end
