//
//  DetailWarningView.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailWarnTopView.h"
#import "DetailWarnSetObject.h"

@interface DetailWarningView : UIView

@property (nonatomic,strong)DetailWarnTopView *topView;
@property (nonatomic,strong)UICollectionView *collection;

@property (nonatomic,strong)NSMutableArray <DetailWarnSetObject *>* records;

@end
