//
//  HTTP_Manager.h
//  Hoologaner
//
//  Created by terry on 2018/1/18.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "HTTP_Manager+HTTP_ManagerExtension.h"



//#define MOB_APPKEY @"1b261b2651a18"
//#define MOB_APPSECRET @"a1f95c96c7280f5b18b2defee3e336da"

extern NSString * APPIP_KEY ;
extern NSString * APPPORT_KEY ;

@interface HTTP_Manager : NSObject

@property (nonatomic,copy)void(^didGetError)(NSString *desc);
@property (nonatomic,strong)NSMutableDictionary * dataSets;///<用于存放数据的字典，可用作区别月回调是哪个接口发起的


/**
 * 解析网络error的userinfo 和 code信息返回错误具体信息
 */
- (NSString *)getHttpWithCode:(NSUInteger)code UserInfo:(NSString *)userinfo;

- (void)queryWithURLString:(NSString *)urlString Block:(void(^)(NSData * data, NSURLResponse * response, NSError * error))block;

- (void)queryURLString:(NSString *)urlStr Block:(void(^)(NSData *data))block;

@end
