//
//  MainTableViewCell.h
//  Temp&HumiManager
//
//  Created by terry on 2018/8/31.
//  Copyright © 2018年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (nonatomic,assign)bool showLink;
@property (nonatomic,strong)UIImage * logo;
@property (nonatomic,strong)UILabel * labTitle;
@property (nonatomic,assign)bool isble;
@property (nonatomic,assign)bool iswifi;
@property (nonatomic,strong)UILabel * labPower;
@property (nonatomic,strong)UILabel * labTemp;
@property (nonatomic,strong)UILabel * labHumi;
@property (nonatomic,strong)UIButton * btnLink;

@property (nonatomic,assign)bool tempWarning;
@property (nonatomic,assign)bool humiWarning;

@property (nonatomic,strong)NSIndexPath * indexPath;

@end
