//
//  DetailWarnCollectionCell.h
//  Temp&HumiManager
//
//  Created by terry on 2018/3/19.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWarnCollectionCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *headLab;
@property (nonatomic,strong)UILabel *tempLab;
@property (nonatomic,strong)UILabel *humiLab;
@property (nonatomic,strong)UILabel *dateLab;
@property (nonatomic,strong)UIImageView *imvTemp;
@property (nonatomic,strong)UIImageView *imvHumi;

@end
