//
//  MyGroupCollection.m
//  TestAll
//
//  Created by terry on 2018/5/21.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "MyGroupCollection.h"

@interface MyGroupCollection ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

static NSString * reuseIdentifer = @"CellID";
static NSString * headerFooterID = @"headerFooterID";

@implementation MyGroupCollection

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {

        [self registerClass:[MainCollectionCell class] forCellWithReuseIdentifier:reuseIdentifer];
        [self registerClass:[MyCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFooterID];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerFooterID];

        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSMutableArray<MyGroupCollectionObject *> *)objects{
    if (_objects == nil) {
        _objects = [NSMutableArray array];
    }
    return _objects;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    MyGroupCollectionObject *gco = [self.objects objectAtIndex:indexPath.section];
    MainCollectionObject *mco = [gco.infos objectAtIndex:indexPath.row];

    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifer forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = true;
    cell.layer.cornerRadius = Fit_Y(8.0);

//    if (mco.isBle) {
//        cell.isLink = true;
//    } else {
//        cell.isLink = false;
//    }

    cell.title = mco.showName?mco.showName:mco.bleInfo.peripheral.name;
    cell.type = [self getUICellTypeWithDevType:mco.motostep];

    //    MainCollectionObject *info = self.datasArray[indexPath.row];

    [cell.btnLink addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnLink.indexPath = indexPath;


    switch ([mco hasData]) {
        case MCODataType_Wifi:
        {
            cell.power = [NSString stringWithFormat:@"%d%%",mco.powerWifi];
            cell.temparature = [NSString stringWithFormat:@"%.1f%%",mco.temperatureWifi];
            cell.humidity = [NSString stringWithFormat:@"%d%%",mco.humidityWifi];
            
            cell.isBle = false;
            cell.isWifi = true;

            cell.isLink = false;
            cell.btnLink.backgroundColor = [UIColor redColor];
        }
            break;
        case MCODataType_Ble:
        {
            cell.power = [NSString stringWithFormat:@"%d%%",mco.powerBle];
            cell.temparature = [NSString stringWithFormat:@"%.1f%@",mco.temperatureBle,mco.tempUnit];
            cell.humidity = [NSString stringWithFormat:@"%d%%",mco.humidityBle];
            cell.isBle = true;
            cell.isWifi = false;

            if (mco.isWifi) {
                cell.isLink = false;
                cell.btnLink.backgroundColor = [UIColor redColor];
            } else {
                cell.isLink = true;
                cell.btnLink.backgroundColor = AuxiBlackColor;
            }
        }
            break;

        default:
        {
            cell.power = @"--";
            cell.temparature = @"--";
            cell.humidity = @"--";

            cell.isBle = false;
            cell.isWifi = false;

            cell.isLink = false;
            cell.btnLink.backgroundColor = [UIColor redColor];
        }
            break;
    }

    cell.tempWarning = mco.tempWarning;
    cell.humiWarning = mco.humiWarning;

    return cell;

}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    MyGroupCollectionObject *object = [self.objects objectAtIndex:section];
    return object.infos.count;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.objects.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    MyGroupCollectionObject *gco = [self.objects objectAtIndex:indexPath.section];
    TH_GroupInfo *group = gco.groupInfo;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MyCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFooterID forIndexPath:indexPath];
        header.indexPath = indexPath;

        header.backgroundColor = [UIColor clearColor];
        header.layer.masksToBounds = true;
        header.layer.cornerRadius = Fit_Y(5.0);

        header.labTitle.text = group.name;
        [header.labTitle sizeToFit];

        header.labRight.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)gco.infos.count];
        [header.labRight sizeToFit];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
        [header addGestureRecognizer:tap];

        return header;
    } else {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerFooterID forIndexPath:indexPath];
        return footer;
    }


}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    MyGroupCollectionObject *gco = [self.objects objectAtIndex:indexPath.section];
    MainCollectionObject *mco = [gco.infos objectAtIndex:indexPath.row];

    CGFloat height;
    switch ([mco hasData]) {
        case MCODataType_Wifi://有网络数据
        {
            height = Fit_Y(100.0);
        }
            break;

        case MCODataType_Ble://有蓝牙数据
        {
            if (mco.isWifi) {//有网络信息
                height = Fit_Y(100.0);
            } else {//没有网络信息
                height = Fit_Y(100.0) + Height_BtnLink;
            }
        }
            break;

        default://二者数据都没有
        {
            height = Fit_Y(100.0);
        }
            break;
    }

    CGFloat distance = Fit_X(20.0);
    return CGSizeMake(collectionView.frame.size.width - distance*2.0, height);

}

//每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    CGFloat distance = Fit_X(20.0);
    return distance;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    MyGroupCollectionObject *gco = [self.objects objectAtIndex:section];
    switch (gco.type) {
        case MyGroupCollectionType_Section:
        {
            return CGSizeMake(0, Fit_Y(80.0));
        }
            break;

        default:
        {
            return CGSizeZero;
        }
            break;
    }

//    MyGroupCollection *collectioner = (MyGroupCollection *)collectionView;
//    GroupCollectionObject *objcSec = [collectioner.objects objectAtIndex:section];
//    switch (objcSec.type) {
//        case CollectionType_Section:
//        {
////            CGFloat distance = Fit_Y(10.0);
//            return CGSizeMake(0, Fit_Y(80.0));
//        }
//            break;
//
//        default:
//        {
//            return CGSizeZero;
//        }
//            break;
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    CGFloat distance = Fit_Y(10.0);
    return CGSizeMake(collectionView.frame.size.width - distance*2.0, Fit_Y(20.0));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.mdelegate respondsToSelector:@selector(collection:didSelectItemAtIndexPath:)]) {
        [self.mdelegate collection:self didSelectItemAtIndexPath:indexPath];
    }
}


#pragma mark ----- <event>
- (void)tapHeader:(UITapGestureRecognizer *)gesture{

    MyCollectionHeaderView *header = (MyCollectionHeaderView *)gesture.view;
    NSInteger section = header.indexPath.section;
    MyGroupCollectionObject *objSec = [self.objects objectAtIndex:section];
    objSec.flex = !objSec.flex;
    [self.objects replaceObjectAtIndex:section withObject:objSec];
    [self reloadSections:[NSIndexSet indexSetWithIndex:section]];

//    MyCollectionHeaderView *header = (MyCollectionHeaderView *)gesture.view;
//    NSInteger section = header.indexPath.section;
//    GroupCollectionObject *objSec = [self.objects objectAtIndex:section];
//    objSec.flex = !objSec.flex;
//    [self.objects replaceObjectAtIndex:section withObject:objSec];
//    [self reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

- (void)clickButton:(UIButton_DIYObject *)sender{
    if ([self.mdelegate respondsToSelector:@selector(collection:didClickLinkAtIndexPath:)]) {
        [self.mdelegate collection:self didClickLinkAtIndexPath:sender.indexPath];
    }
}


#pragma mark - inside method
- (CellImvType)getUICellTypeWithDevType:(int)type{

    switch (type) {
        case 6:
            return CellImvType_WC;
            break;
        case 7:
            return CellImvType_Bar;
            break;
        case 8:
            return CellImvType_Bed;
            break;
        case 9:
            return CellImvType_Baby;
            break;

        default:
            return CellImvType_Car;
            break;
    }
}

@end
