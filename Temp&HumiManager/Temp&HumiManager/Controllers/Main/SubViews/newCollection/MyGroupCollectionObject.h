//
//  MyGroupCollectionObject.h
//  Temp&HumiManager
//
//  Created by terry on 2018/5/25.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainCollectionObject.h"
#import "TH_GroupInfo.h"

typedef NS_OPTIONS(int, MyGroupCollectionType) {
    MyGroupCollectionType_Default ,///<只有一行，没有分组
    MyGroupCollectionType_Section ,///<有分组
};



@interface MyGroupCollectionObject : NSObject


@property (nonatomic,assign)bool flex;///<是否折叠,useful when type is CollectionType_Section

@property (nonatomic,assign)MyGroupCollectionType type;///<类型

@property (nonatomic,strong)TH_GroupInfo *groupInfo;///<组对象

@property (nonatomic,strong)NSMutableArray <MainCollectionObject *>* infos;///<信息数据



//===================

@end
