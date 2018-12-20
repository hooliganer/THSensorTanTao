//
//  HTTP_Manager+HTTP_ManagerExtension.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/27.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "HTTP_Manager.h"

typedef NS_OPTIONS(int, XMLParseType) {
    XMLParseType_Start ,///<头节点
    XMLParseType_Value ,///<中间值
    XMLParseType_End ,///<尾节点
};

