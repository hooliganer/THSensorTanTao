//
//  DetailInfoController+UI.h
//  Temp&HumiManager
//
//  Created by terry on 2018/12/13.
//  Copyright © 2018年 terry. All rights reserved.
//

#import "DetailInfoController.h"
#import "DetailInfoController+Extension.h"

@interface DetailInfoController (UI)
<DetailTypeChooseViewDelegate,DetailChooseSegmentDelegate>

- (void)setupSubviews;

- (int)motostepByType:(int)type;
- (int)typeByMotostep:(int)moto;

- (void)showIsWaner:(bool)is;

@end
