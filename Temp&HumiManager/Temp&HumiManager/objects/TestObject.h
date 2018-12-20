//
//  TestObject.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject

@property (nonatomic,assign)int intValue;
@property (nonatomic,copy)NSString *stringValue;
@property (nonatomic,copy)NSArray *arrayValue;
@property (nonatomic,copy)NSDictionary *dictionaryValue;
@property (nonatomic,strong)NSData *data;

@end
