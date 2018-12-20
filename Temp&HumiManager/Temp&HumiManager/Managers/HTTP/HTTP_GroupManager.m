//
//  HTTP_GroupManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/23.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_GroupManager.h"

@interface HTTP_GroupManager ()
<NSXMLParserDelegate>
@property (nonatomic,strong)NSMutableArray <TH_GroupInfo *>* groups;
@property (nonatomic,strong)TH_GroupInfo *tempGroup;

@end

@implementation HTTP_GroupManager
{
    NSString *currentValue;
    NSString *startNode;
    NSString *endNode;
}

+ (HTTP_GroupManager *)shreadInstance{
    static HTTP_GroupManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTP_GroupManager alloc]init];
    });
    return manager;
}

/**
 * 查询用户关注组
 */
- (void)selectGroupOfUserWithUid:(int)uid Pwd:(NSString *)pwd{

//    LRWeakSelf(self);

    //http://%@:%@/aircondition/group/group_query.jsp?uid=%@&pwd=%@
    NSString *stringURL = [NSString stringWithFormat:@"http://%@:%@/aircondition/group/group_query.jsp?uid=%d&pwd=%@",APPIP_KEY,APPPORT_KEY,uid,pwd];
//    NSLog(@"%@",stringURL);

    [self queryURLString:stringURL Block:^(NSData *data) {

//        NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        LRLog(@"%@",strCode);
        [self parseData:data Error:nil];
    }];
}

- (void)linkGroupWithMac:(NSString *)mac Uid:(NSString *)uid Pwd:(NSString *)pwd{

//    http://%@:%@/aircondition/group/group_set.jsp?mac=%@&uid=%@&gid=%@&pwd=%@&opertype=ingroup%@&dtype=2
    
    NSString *stringUrl = [NSString stringWithFormat:
                           @"http://%@:%@/aircondition/group/group_set.jsp"
                           "?mac=%@"
                           "&uid=%@"
//                           "&gid=%@"
                           "&pwd=%@"
                           "&opertype=%@"
                           "&dtype=%@"
                           ,APPIP_KEY,APPPORT_KEY
                           ,[mac getUTF8String]
                           ,uid
                           ,[pwd getUTF8String]
                           ,@"ingroup"
                           ,@"2"];
    NSLog(@"%@",stringUrl);

    LRWeakSelf(self);
    [self queryWithURLString:stringUrl Block:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error){
            NSLog(@"%@",error);
            NSDictionary *dic = error.userInfo;
            NSString *str=[dic valueForKey:@"NSLocalizedDescription"];
            str = [weakself getHttpWithCode:error.code UserInfo:str];
//            NSLog(@"error:%@",str);
            if (self.didGetGroupsFail) {
                self.didGetGroupsFail(str);
            }
        }
        else{
            NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
            NSString *strCode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *desc = [strCode getStringBetweenFormerString:@"<desc>" AndLaterString:@"</desc>"];
//            LRLog(@"%@",strCode);
            if (httpResponse.statusCode==200 || httpResponse.statusCode==304){
                if ([strCode containsString:@"<cod>0</cod>"]) {
                    if (self.didLinkDevice) {
                        self.didLinkDevice(false, @"Link successful !");
                    }
                } else if ([strCode containsString:@"<cod>5</cod>"]) {
                    if (self.didLinkDevice) {
                        self.didLinkDevice(false, @"The MAC is incorrect !");
                    }
                } else if ([strCode containsString:@"<cod>4</cod>"]) {
                    if (self.didLinkDevice) {
                        self.didLinkDevice(false, @"The Device is Distinct !");
                    }
                } else {
                    if (self.didLinkDevice) {
                        self.didLinkDevice(false, desc);
                    }
                }
            }
            else{
                NSLog(@"服务器内部错误:%@",strCode);
                if (self.didGetGroupsFail) {
                    self.didGetGroupsFail(@"Serve Error !");
                }
                return;
            }
        }

    }];
}

- (void)parseData:(NSData *)data Error:(NSError *)error{

    //    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
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
#pragma 开始解析前，在这里可以做一些初始化工作
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //    NSLog(@"ParseXML Start");
    self.tempGroup = [[TH_GroupInfo alloc]init];
    self.groups = [NSMutableArray array];
}

#pragma 当解析器对象遇到xml的开始标记时，调用这个方法,调用多次.    获得结点头的值
//解析到一个开始tag，开始tag中可能会有properpies，例如<book catalog="Programming">
//所有的属性都存储在attributeDict中
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    //    NSLog(@"%@",elementName);
    //NSLog(@"%@",parser);

    startNode = elementName;

}

#pragma 当解析器找到开始标记和结束标记之间的字符时，调用这个方法。
//解析器，从两个结点之间读取具体内容
-  (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    //    NSLog(@"%@",string);
    currentValue=string;
}


#pragma 当解析器对象遇到xml的结束标记时，调用这个方法。
//获取结点结尾的值，此处为一Tag的完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    //    NSLog(@"%@",elementName);
    endNode=elementName;
    if ([endNode isEqualToString:@"repdata"]) {

    }
    else{
        if ([endNode isEqualToString:@"group"]) {
            TH_GroupInfo *group = [[TH_GroupInfo alloc]initWithNewRoomInfo:self.tempGroup];
            [_groups addObject:group];
        }
        else{
            if ([endNode isEqualToString:@"id"]) {
                self.tempGroup.gid = [currentValue intValue];
            }
            else if ([endNode isEqualToString:@"type"]){
                self.tempGroup.type=[currentValue intValue];
            }
            else if ([endNode isEqualToString:@"name"]){
                self.tempGroup.mac = currentValue;
            }
            else if ([endNode isEqualToString:@"desc"]){
                self.tempGroup.name = currentValue;
            }
            else if ([endNode isEqualToString:@"state"]){
                self.tempGroup.state=[currentValue intValue];
            }
            else if ([endNode isEqualToString:@"dateline"]){
                self.tempGroup.dateline=[currentValue doubleValue];
            }
            else if ([endNode isEqualToString:@"appsid"]){
                self.tempGroup.appSID = currentValue;
            }
            else if ([endNode isEqualToString:@"mcount"]){
                self.tempGroup.mCount = [currentValue intValue];
            }
            else if ([endNode isEqualToString:@"online"]){
                self.tempGroup.online = [currentValue boolValue];
            }
            else{
                NSLog(@"\n\n group info unknown node:%@ \n \n",endNode);
            }
        }
    }
}

#pragma xml整个文档解析结束后的一些操作可在此
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //    NSLog(@"%@",marrGroups);
    if (self.didGetGroups) {
        self.didGetGroups(self.groups);
    }
}


@end
