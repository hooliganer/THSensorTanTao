//
//  DetailWarningView.m
//  Temp&HumiManager
//
//  Created by terry on 2018/3/16.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailWarningView.h"
#import "DetailWarnCollectionCell.h"
#import "DetailWarningCell.h"

@interface DetailWarningView ()
<UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionViewFlowLayout *flowOut;

@end

static NSString * cellIdentifer = @"constCell";
static NSString * reuviewIdentifer = @"reuviewCell";

@implementation DetailWarningView

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat distance = Fit_Y(10.0);

    self.topView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.3);
    self.topView.layer.cornerRadius = Fit_Y(8.0);

    self.collection.frame = CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height + distance, self.frame.size.width, self.frame.size.height*0.7 - distance);

    self.flowOut.itemSize = CGSizeMake(_collection.frame.size.width, _topView.frame.size.height/2.0);

}

- (DetailWarnTopView *)topView{
    if (_topView == nil) {
        _topView = [[DetailWarnTopView alloc]init];
        _topView.layer.masksToBounds = true;
        _topView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [self addSubview:_topView];
    }
    return _topView;
}

- (UICollectionViewFlowLayout *)flowOut{
    if (_flowOut == nil) {
        _flowOut = [[UICollectionViewFlowLayout alloc]init];
        _flowOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowOut;
}

- (UICollectionView *)collection{
    if (_collection == nil) {
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowOut];
        _collection.backgroundColor = [UIColor clearColor];
//        [_collection registerClass:[DetailWarnCollectionCell class] forCellWithReuseIdentifier:cellIdentifer];
        [_collection registerNib:[UINib nibWithNibName:@"DetailWarningCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifer];
        _collection.dataSource = self;
        [self addSubview:_collection];
    }
    return _collection;
}

#pragma mark - <UICollectionViewDataSource>
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    DetailWarningCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    cell.layer.masksToBounds = true;
    cell.layer.cornerRadius = Fit_Y(5.0);

    cell.labNumber.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    DetailWarnSetObject * dev = [self.records objectAtIndex:indexPath.row];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:dev.time];
    cell.labTime.text = [NSString stringWithFormat:
                         @"%@.%02d.%d %02d:%02d:%02d"
                         ,[NSString englishMonth:[date nMonth] IsAb:true]
                         ,[date nDay]
                         ,[date nYear]
                         ,[date nHour]
                         ,[date nMinute]
                         ,[date nSecond]];
    
    NSString *unit = [self getTempUnit];
    
    cell.labTemp.text = dev.temparature != -1000 ? [NSString stringWithFormat:@"%.1f%@",dev.temparature,unit] : @"--";
    
    cell.labHumi.text = dev.humidity != -1000 ? [NSString stringWithFormat:@"%d%%",dev.humidity] : @"--";
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.records.count;
}


- (NSString *)getTempUnit{
    APPGlobalObject *gobc = [[MyArchiverManager sharedInstance] readGlobalObject];
    NSString *unit;
    if (gobc) {
        unit = gobc.unitType?@"˚F":@"˚C";
    } else{
        unit = @"˚C";
    }
    return unit;
}

@end



