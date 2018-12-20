//
//  HTTP_MemberManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_MemberManager.h"

@interface HTTP_MemberManager ()
<NSXMLParserDelegate>
@property (nonatomic,strong)DeviceInfo *tempMember;
@property (nonatomic,strong)NSMutableArray <DeviceInfo *>* members;

@end

@implementation HTTP_MemberManager
{
    NSString *currentValue;
    NSString *startNode;
    NSString *endNode;
    MemberSensor tempSensor;
}


+ (HTTP_MemberManager *)shareadInstance{
    static HTTP_MemberManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTP_MemberManager alloc]init];
    });
    return manager;
}

- (NSMutableDictionary *)dataSet{
    if (_dataSet == nil) {
        _dataSet = [NSMutableDictionary dictionary];
    }
    return _dataSet;
}


- (void)selectMembersWithUid:(int)uid Gid:(int)gid{

    NSString *strURL=[NSString stringWithFormat:
                      @"http://%@:%@/aircondition/group/group_dev_query.jsp"
                      "?uid=%d"
                      "&gid=%d"
                      "&data=%@"
                      "&nio=%@"
                      ,APPIP_KEY,APPPORT_KEY
                      ,uid,gid,@"yes",@"yes"];
//    LRLog(@"%@",strURL);

    LRWeakSelf(self);

    [self queryURLString:strURL Block:^(NSData *data) {

//        NSString * strCode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",strCode);

        NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:data];
        xmlParser.delegate = weakself;
        if (![xmlParser parse]) {
            if (weakself.didGetMembers) {
                weakself.didGetMembers(weakself,nil);
            } else {
                LRLog(@"parse XML Fail !!!!%@",xmlParser.parserError);
            }
        }

    }];

}


/*================XMLDelegate===================*/
#pragma 开始解析前，在这里可以做一些初始化工作
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //    NSLog(@"ParseXML Start");
    self.tempMember = [[DeviceInfo alloc]init];
    self.members = [NSMutableArray array];
    
}

#pragma 当解析器对象遇到xml的开始标记时，调用这个方法,调用多次.    获得结点头的值
//解析到一个开始tag，开始tag中可能会有properpies，例如<book catalog="Programming">
//所有的属性都存储在attributeDict中
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

//        NSLog(@"< %@",elementName);
    //NSLog(@"%@",parser);

    startNode = elementName;

}

#pragma 当解析器找到开始标记和结束标记之间的字符时，调用这个方法。
//解析器，从两个结点之间读取具体内容
-  (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

//        NSLog(@"%@",string);
    currentValue = string;
}


#pragma 当解析器对象遇到xml的结束标记时，调用这个方法。
//获取结点结尾的值，此处为一Tag的完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

//    NSLog(@"%@ >",elementName);
    endNode = elementName;

    if ([endNode isEqualToString:@"repdata"]) {

    }
    else{
        if ([endNode isEqualToString:@"param"]) {

        }
        else if ([endNode isEqualToString:@"dev"]){
            DeviceInfo *newMember = [[DeviceInfo alloc]initWithNewDevice:self.tempMember];
            [self.members addObject:newMember];
        }
        else{
            if ([endNode isEqualToString:@"did"]) {
                self.tempMember.dID = [currentValue intValue];
            }
            else if ([endNode isEqualToString:@"name"]){
                self.tempMember.mac = currentValue;
            }
            else if ([endNode isEqualToString:@"dateline"]){
                self.tempMember.dateline = [currentValue doubleValue];
            }
            else if ([endNode isEqualToString:@"nio"]){
                self.tempMember.nio = currentValue;
            }
            else if ([endNode isEqualToString:@"dtype"]){
                self.tempMember.dType = [currentValue intValue];
            }
            else if ([endNode isEqualToString:@"devpost"]){
                currentValue = [currentValue stringByReplacingOccurrencesOfString:@"{" withString:@""];
                currentValue = [currentValue stringByReplacingOccurrencesOfString:@"}" withString:@""];
                NSArray *devPostData = [currentValue componentsSeparatedByString:@","];
                double x = [[devPostData firstObject] floatValue];
                double y = [[devPostData lastObject] floatValue];
                self.tempMember.devpost = DevicePostMake(x, y);
            }
            else if ([endNode isEqualToString:@"motostep"]){
                self.tempMember.motostep = [currentValue intValue];
            }
            else if ([endNode isEqualToString:@"state"]){
                self.tempMember.state = [currentValue intValue];
            }
            else if ([endNode isEqualToString:@"nickname"]){
                self.tempMember.nickName = currentValue;
            }
            else if ([endNode isEqualToString:@"showname"]){
                self.tempMember.showName = currentValue;
            }
            else if ([endNode isEqualToString:@"rid"]){
                self.tempMember.rid = currentValue;
            }
            else{
                if ([endNode isEqualToString:@"sensor"]) {

                    [self.tempMember addSensorToSelfSensors:tempSensor];
                }
                else if ([endNode isEqualToString:@"type"]){
                    tempSensor.type = [currentValue intValue];
                }
                else if ([endNode isEqualToString:@"value"]){
                    tempSensor.value = [currentValue floatValue];
                }
                else{
//                    NSLog(@"undefined member node:%@ -> %@",endNode,currentValue);
                }
            }
        }
    }
}

#pragma xml整个文档解析结束后的一些操作可在此
- (void)parserDidEndDocument:(NSXMLParser *)parser{

    if (self.didGetMembers) {
        self.didGetMembers(self,self.members);
    }
    
}

@end
