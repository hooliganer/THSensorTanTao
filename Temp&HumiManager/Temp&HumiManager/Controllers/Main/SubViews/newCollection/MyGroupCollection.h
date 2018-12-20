//
//  MyGroupCollection.h
//  TestAll
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupCollectionLayout.h"
//#import "GroupCollectionObject.h"
#import "MainCollectionCell.h"
#import "MyCollectionHeaderView.h"
#import "MyGroupCollectionObject.h"

@class MyGroupCollection;

@protocol MyGroupCollectionDelegate <NSObject>

- (void)collection:(MyGroupCollection *)collection didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collection:(MyGroupCollection *)collection didClickLinkAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface MyGroupCollection : UICollectionView

//@property (nonatomic,strong)NSMutableArray <GroupCollectionObject *> *objects;
@property (nonatomic,strong)NSMutableArray <MyGroupCollectionObject *> *objects;
@property (nonatomic,weak)id <MyGroupCollectionDelegate>mdelegate;

@end
