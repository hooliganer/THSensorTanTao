//
//  DetailWarningCell.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailWarningCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *labNumber;
@property (strong, nonatomic) IBOutlet UIImageView *imvTemp;
@property (strong, nonatomic) IBOutlet UILabel *labTemp;
@property (strong, nonatomic) IBOutlet UIImageView *imvHumi;
@property (strong, nonatomic) IBOutlet UILabel *labHumi;
@property (strong, nonatomic) IBOutlet UILabel *labTime;

@end

NS_ASSUME_NONNULL_END
