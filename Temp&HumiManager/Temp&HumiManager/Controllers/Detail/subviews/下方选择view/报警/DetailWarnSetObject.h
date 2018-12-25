//
//  DetailWarnSetObject.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailWarnSetObject : NSObject

@property (nonatomic,assign)float temparature;
@property (nonatomic,assign)int humidity;
@property (nonatomic,assign)NSTimeInterval time;

@end

NS_ASSUME_NONNULL_END
