//
//  CLChartToolBar.h
//  CLDemo
//
//  Created by JmoVxia on 2017/3/11.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLChartNameToolBar.h"
@protocol CLMaxChartLegendViewDelegate <NSObject>

- (void)maxChartLegendViewDidSelectedWeek:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedOneMonth:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedThreeMonth:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedSixMonth:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedYear:(UIButton*)button;


@end





@interface CLChartToolBar : UIView

/** 代理*/
@property(nonatomic,weak)id<CLMaxChartLegendViewDelegate> delegate;
/**日期切换工具条*/
@property (nonatomic,strong) UIView *dateToolBar;
/**名称工具条*/
@property (nonatomic,strong) CLChartNameToolBar *nameToolBar;
/**图表名称*/
@property (nonatomic,copy) NSString *nameString;

- (void)selectedFirst;


@end
