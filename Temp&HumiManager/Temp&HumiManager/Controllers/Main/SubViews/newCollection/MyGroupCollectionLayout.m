//
//  MyGroupCollectionLayout.m
//  TestAll
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyGroupCollectionLayout.h"

@implementation MyGroupCollectionLayout

- (instancetype)init{
    if (self = [super init]) {

        self.scrollDirection = UICollectionViewScrollDirectionVertical;


        //        //每个item水平间距
        //        flowout.minimumInteritemSpacing = Fit_X(0);

        //        //每个item的UIEdgeInsets
        //        flowout.sectionInset = UIEdgeInsetsMake(Fit_X(0), Fit_X(0), Fit_Y(0), Fit_X(0));


    }
    return self;
}

@end
