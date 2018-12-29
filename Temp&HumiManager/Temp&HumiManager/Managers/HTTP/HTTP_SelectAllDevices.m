//
//  HTTP_SelectAllDevices.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/7.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_SelectAllDevices.h"

@interface HTTP_SelectAllDevices ()
<NSXMLParserDelegate>


@end

@implementation HTTP_SelectAllDevices
{
    NSString *currentValue;
    NSString *startNode;
    NSString *endNode;
    NSMutableArray *marrDevices;
    NSMutableArray *marrSensors;
    DeviceInfo *tempDev;
//    SensorInfo *tempSnr;
    MemberSensor tempSnr;
    void(^didGetDevices)(NSArray<DeviceInfo *> *);

    XMLParseType lastType;
}

+ (HTTP_SelectAllDevices *)sharedInstance{
    static HTTP_SelectAllDevices *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTP_SelectAllDevices alloc]init];
    });
    return manager;
}

- (void)linkDevWithMac:(NSString *)mac Name:(NSString *)name Block:(void (^)(bool, NSString *))block{

    UserInfo *user = [[MyDefaultManager sharedInstance] readUser];
    // aircondition/app/like_dev.jsp?opertype=link&username=1182&uid=1182&encode=utf-8&mac=g54yg356hg356rf&showname=wee&pwd=123456
    NSString *strURL=[NSString stringWithFormat:
                      @"http://%@:%@/aircondition/app/like_dev.jsp"
                      "?opertype=%@"
                      "&username=%d"
                      "&uid=%d"
                      "&encode=%@"
                      "&mac=%@"
                      "&showname=%@"
                      "&pwd=%@"
                      ,APPIP_KEY,APPPORT_KEY
                      ,@"link",user.uid,user.uid
                      ,@"utf-8",mac,name,@"123456"];
//    NSLog(@"%@",strURL);

    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sesTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        if (error) {
            NSDictionary *dic=error.userInfo;
            NSString *str=[dic valueForKey:@"NSLocalizedDescription"];
            str=[self getHttpWithCode:error.code UserInfo:str];
            NSLog(@"%@",str);
            if (block) {
                block(false,@"Internet Error!");
            }
        }else{
            NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",strCode);
//            NSString *info = [strCode getStringBetweenFormerString:@"<desc>" AndLaterString:@"</desc>"];
            if (block) {
                if ([strCode containsString:@"<cod>0</cod>"]) {
                    block(true,@"Link Successful !");
                }
                else if ([strCode containsString:@"<cod>4</cod>"]){
                    block(false,@"Link Fail ! Device Does Not Match !");
                }
                else {
                    block(false,@"Serve Error !");
                }
            }
        }

    }];
    [sesTask resume];

}


- (void)parseGData:(NSData *)data Error:(NSError *)error Block:(void(NSArray<DeviceInfo *> *))block{

//    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
//
//    //获取根节点（Users）
//    GDataXMLElement *rootElement = [doc rootElement];
//
////    //获取根节点下的节点（User）
////    NSArray *users = [rootElement elementsForName:@""];
////
////    for (GDataXMLElement *user in users) {
////
////
//////        //User节点的id属性
//////        NSString *userId = [[user attributeForName:@"id"]stringValue];
//////        NSLog(@"User id is:%@",userId);
//////
//////        //获取name节点的值
//////
//////        GDataXMLElement *nameElement = [[user elementsForName:@"name"]objectAtIndex:0];
//////        NSString *name = [nameElement stringValue];
//////        NSLog(@"User name is:%@",name);
//////
//////        //获取age节点的值
//////        GDataXMLElement *ageElement = [[user elementsForName:@"age"]objectAtIndex:0];
//////        NSString *age = [ageElement stringValue];
//////        NSLog(@"User age is:%@",age);
//////        NSLog(@"-------------------");
////    }
}



- (void)selectAllDevicesWithUid:(int)uid Block:(void (^)(NSArray<DeviceInfo *> *))block{

    didGetDevices = block;
    ///aircondition/app/like_dev_query.jsp?uid=
    NSString *strURL=[NSString stringWithFormat:@"http://%@:%@/aircondition/app/like_dev_query.jsp?uid=%d&data=%@",APPIP_KEY,APPPORT_KEY,uid,@"yes"];
//    NSLog(@"%@",strURL);

    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sesTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        if (error) {
            NSDictionary *dic=error.userInfo;
            NSString *str=[dic valueForKey:@"NSLocalizedDescription"];
            str=[self getHttpWithCode:error.code UserInfo:str];
            NSLog(@"%@",str);

        }else{
//            NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",strCode);
            [self parseData:data Error:error];
        }

    }];
    [sesTask resume];
}


- (void)parseData:(NSData *)data Error:(NSError *)error{

//    NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",string);

    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:data];
    xmlParser.delegate = self;
    BOOL flag = [xmlParser parse];
    if (flag) {
        //        NSLog(@"解析intenet的xml成功");
    }else{
        NSLog(@"解析intenet的xml失败");
    }
}

/*================XMLDelegate===================*/
#pragma 开始解析前,在这里可以做一些初始化工作
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //    NSLog(@"ParseXML Start");
    marrDevices = [NSMutableArray array];
    marrSensors = [NSMutableArray array];
    tempDev = [[DeviceInfo alloc]init];
}

#pragma 当解析器对象遇到xml的开始标记时,调用这个方法,调用多次.    获得结点头的值
//解析到一个开始tag，开始tag中可能会有properpies，例如<book catalog="Programming">
//所有的属性都存储在attributeDict中
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{


//        NSLog(@"< %@",elementName);
    //NSLog(@"%@",parser);
    startNode = elementName;

    lastType = XMLParseType_Start;
}

#pragma 当解析器找到开始标记和结束标记之间的字符时,调用这个方法。
//解析器，从两个结点之间读取具体内容
-  (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

//    NSLog(@"%@",string);
    switch (lastType) {
        case XMLParseType_Start://如果上次解析是开始的话，就直接赋值
            currentValue = string;
            break;
        case XMLParseType_Value://如果上次解析是值的话，就拼接
            currentValue = [currentValue stringByAppendingString:string];
            break;

        default:
            break;
    }
    lastType = XMLParseType_Value;

}


#pragma 当解析器对象遇到xml的结束标记时,调用这个方法。
//获取结点结尾的值，此处为一Tag的完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

//        NSLog(@"%@ >",elementName);
    endNode=elementName;

    if ([endNode isEqualToString:@"repdata"]) {

    } else{
        if ([endNode isEqualToString:@"dev"]) {
            [marrDevices addObject:[[DeviceInfo alloc] initWithNewDevice:tempDev]];
        } else{
            if ([endNode isEqualToString:@"did"]) {
                tempDev.dID = [currentValue intValue];
            } else if ([endNode isEqualToString:@"name"]){
                tempDev.mac = currentValue;
            } else if ([endNode isEqualToString:@"dateline"]){
                tempDev.dateline = [currentValue doubleValue];
            } else if ([endNode isEqualToString:@"citycode"]){
                tempDev.cityCode = currentValue;
            } else if ([endNode isEqualToString:@"email"]){
                tempDev.email = currentValue;
            } else if ([endNode isEqualToString:@"dtype"]){
                tempDev.dType = [currentValue intValue];
            } else if ([endNode isEqualToString:@"motostep"]){
                tempDev.motostep = [currentValue intValue];
            } else if ([endNode isEqualToString:@"nio"]){
                tempDev.nio = currentValue;
            } else if ([endNode isEqualToString:@"devpost"]){
                tempDev.devpost = DevicePostFromString(currentValue);
            } else if ([endNode isEqualToString:@"state"]){
                tempDev.state = [currentValue boolValue];
            } else if ([endNode isEqualToString:@"showname"]){
                tempDev.showName = currentValue;
            }  else if ([endNode isEqualToString:@"nickname"]){
                tempDev.nickName = currentValue;
            } else if ([endNode isEqualToString:@"pwd"]){
                tempDev.pwd = currentValue;
            } else if ([endNode isEqualToString:@"sensor"]){
            } else{
                if ([endNode isEqualToString:@"type"]) {
                    tempSnr.type = [currentValue intValue];
                } else if ([endNode isEqualToString:@"value"]){
                    tempSnr.value = [currentValue doubleValue];

                    [tempDev addSensorToSelfSensors:tempSnr];

                } else{
                    NSLog(@"unkown node %@",endNode);
                }
            }
        }
    }

}

#pragma xml整个文档解析结束后的一些操作可在此
- (void)parserDidEndDocument:(NSXMLParser *)parser{

    //    NSLog(@"%@",marrGroups);
    if (didGetDevices) {
        didGetDevices(marrDevices);
        didGetDevices = nil;
    }

}


@end
