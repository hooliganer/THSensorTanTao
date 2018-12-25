//
//  DetailChooseSegment.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/12.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton_DIYObject.h"

struct DCSegmentTime {
    NSTimeInterval next;///<后一个时间点
    NSTimeInterval last;///<前一个时间点
};
typedef struct CG_BOXABLE DCSegmentTime DCSegmentTime;

CG_INLINE DCSegmentTime
DCSegmentTimeMake(NSTimeInterval next, NSTimeInterval last)
{
    DCSegmentTime dc; dc.next = next; dc.last = last; return dc;
}

@class DetailChooseSegment;

@protocol DetailChooseSegmentDelegate <NSObject>

- (void)segmentView:(DetailChooseSegment *)segment chooseIndex:(NSInteger)index;
- (void)segmentView:(DetailChooseSegment *)segment chooseLR:(bool)isLeft;

@end

@interface DetailChooseSegment : UIView

@property (nonatomic,assign)int type;///<0:Hour,1:Day,2:Week
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,readonly)DCSegmentTime times;///<时间段
@property (nonatomic,strong)UILabel *labCenter;
@property (nonatomic,weak)id<DetailChooseSegmentDelegate>delegate;

@property (nonatomic,strong)UIButton_DIYObject *btn4;
@property (nonatomic,strong)UIButton_DIYObject *btn5;

@end
