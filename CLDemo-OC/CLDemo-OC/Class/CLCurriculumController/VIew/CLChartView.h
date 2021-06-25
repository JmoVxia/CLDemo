//
//  CLChartView.h
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLChartViewDelegate <NSObject>

/**周*/
- (void)CLChartViewDidSelectedWeek:(UIButton *)weekButton;
/**一月*/
- (void)CLChartViewDidSelectedOneMonth:(UIButton *)oneMonth;
/**三月*/
- (void)CLChartViewDidSelectedThreeMonth:(UIButton *)threeMonth;
/**六月*/
- (void)CLChartViewDidSelectedSixMonth:(UIButton *)sixMonth;
/**一年*/
- (void)CLChartViewDidSelectedYear:(UIButton *)year;

@end

@interface CLChartView : UIView


/**数据*/
@property (nonatomic,strong) NSDictionary *dic;
/**代理*/
@property (nonatomic,weak) id<CLChartViewDelegate> delegate;

/**
 选中一周
 */
- (void)selectedWeek;

@end
