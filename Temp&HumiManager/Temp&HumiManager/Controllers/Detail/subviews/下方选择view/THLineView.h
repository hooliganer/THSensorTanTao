//
//  THLineView.h
//  TestOC
//
//  Created by tantao on 2018/12/25.
//  Copyright © 2018 tantao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(int, THLineType) {
    THLineType_Beeline , ///<直线
    THLineType_Curveline , ///<曲线
    THLineType_BeeCircleLine ,///<直线带圆圈
};



@interface THLineView : UIView

@property (nonatomic,strong)UIColor * bgLineColor;
@property (nonatomic,strong)UIColor * lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,assign)CGFloat bgLineWidth;
@property (nonatomic,assign)THLineType type;

- (void)reDrawWithX:(float)x Y:(float)y Values:(nullable NSArray <NSNumber *>* )values;

@end


NS_ASSUME_NONNULL_END
