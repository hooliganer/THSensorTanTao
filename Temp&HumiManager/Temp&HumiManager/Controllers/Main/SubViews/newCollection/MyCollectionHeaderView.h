//
//  MyCollectionHeaderView.h
//  TestAll
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionHeaderView : UICollectionReusableView

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,strong)UILabel *labRight;

@end
