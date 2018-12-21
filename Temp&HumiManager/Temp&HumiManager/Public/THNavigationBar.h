//
//  THNavigationBar.h
//  Temp&HumiManager
//
//  Created by tantao on 2018/12/21.
//  Copyright © 2018 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THNavigationBar : UIView

/**
 子元素颜色
 */
@property (nonatomic,strong)UIColor * tintColor;

- (void)showBack:(void(^)(THNavigationBar * navigationBar))block;

@end

NS_ASSUME_NONNULL_END
