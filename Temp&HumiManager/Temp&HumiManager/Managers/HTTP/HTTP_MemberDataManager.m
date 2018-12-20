//
//  HTTP_MemberDataManager.m
//  Temp&HumiManager
//
//  Created by terry on 2018/9/3.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_MemberDataManager.h"

@interface HTTP_MemberDataManager ()
<NSXMLParserDelegate>
//@property (nonatomic,strong)DeviceInfo *tempMember;
//@property (nonatomic,strong)NSMutableArray <DeviceInfo *>* members;

@property (nonatomic,copy)NSString *currentValue;
@property (nonatomic,copy)NSString *startNode;
@property (nonatomic,copy)NSString *endNode;

@property (nonatomic,strong)DeviceInfo * tempDevice;
@property (nonatomic,strong)NSMutableArray <DeviceInfo *>* devices;

@end

@implementation HTTP_MemberDataManager

+ (HTTP_MemberDataManager *)sharedInstance{
    static HTTP_MemberDataManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTP_MemberDataManager alloc]init];
    });
    return manager;
}

- (NSMutableDictionary *)dataSet{
    if (_dataSet == nil) {
        _dataSet = [NSMutableDictionary dictionary];
    }
    return _dataSet;
}

- (void)selectMemberDataWithMac:(NSString *)mac GMac:(NSString *)gmac{
//    /smarthome/gate_upload_query.jsp?mac=&tmac=&count=1
    NSString * urlString = [NSString stringWithFormat:
                            @"http://%@:%@/smarthome/gate_upload_query.jsp"
                            "?mac=%@"
                            "&tmac=%@"
                            "&count=%@"
                            ,APPIP_KEY,APPPORT_KEY
                            ,mac,gmac,@"1"];
//    NSLog(@"%@",urlString);

    [self queryURLString:urlString Block:^(NSData *data) {

//        NSString *strCode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        LRLog(@"%@",strCode);
        NSXMLParser * parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        if (![parser parse]) {
            LRLog(@"xml Parse Fail");
        }
    }];
}



/*================XMLDelegate===================*/
#pragma 开始解析前，在这里可以做一些初始化工作
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //    NSLog(@"ParseXML Start");
    self.tempDevice = [[DeviceInfo alloc]init];
    self.devices = [NSMutableArray array];

}

#pragma 当解析器对象遇到xml的开始标记时，调用这个方法,调用多次.    获得结点头的值
//解析到一个开始tag，开始tag中可能会有properpies，例如<book catalog="Programming">
//所有的属性都存储在attributeDict中
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    //        NSLog(@"< %@",elementName);
    //NSLog(@"%@",parser);

    _startNode = elementName;

}

#pragma 当解析器找到开始标记和结束标记之间的字符时，调用这个方法。
//解析器，从两个结点之间读取具体内容
-  (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    //        NSLog(@"%@",string);
    _currentValue = string;
}


#pragma 当解析器对象遇到xml的结束标记时，调用这个方法。
//获取结点结尾的值，此处为一Tag的完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    //    NSLog(@"%@ >",elementName);
    _endNode = elementName;

    if ([_endNode isEqualToString:@"updata"]) {

    } else {
        if ([_endNode isEqualToString:@"data"]) {
            DeviceInfo * info = [[DeviceInfo alloc]initWithNewDevice:_tempDevice];
            [self.devices addObject:info];
        } else {
            if ([_endNode isEqualToString:@"rid"]) {
                _tempDevice.rid = _currentValue;
            } else if([_endNode isEqualToString:@"utime"]) {
                _tempDevice.utime = [_currentValue doubleValue];
            } else if([_endNode isEqualToString:@"tmac"]) {
                _tempDevice.tmac = _currentValue;
            } else if([_endNode isEqualToString:@"uuid"]) {
                _tempDevice.uuid = _currentValue;
            } else if([_endNode isEqualToString:@"sdata"]) {
                _tempDevice.sdata = _currentValue;
            } else {
                if ([_endNode isEqualToString:@"rep"] || [_endNode isEqualToString:@"code"]) {
                    return ;
                }
                LRLog(@"Undefined Node : %@ - %@",_endNode,_currentValue);
            }
        }
    }
}



#pragma xml整个文档解析结束后的一些操作可在此
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //    NSLog(@"%@")
    if (self.didGetMemberData) {
        if (self.devices.count > 0) {
            self.didGetMemberData(self,self.devices[0]);
        } else {
            self.didGetMemberData(self,nil);
        }

    }


}

@end
