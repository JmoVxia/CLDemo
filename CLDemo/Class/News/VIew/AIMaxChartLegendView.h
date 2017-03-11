//
//  AIMaxChartLegendView.h
//  CKD
//
//  Created by 艾泽鑫 on 2017/2/6.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AIMaxChartLegendViewDelegate <NSObject>

- (void)maxChartLegendViewDidSelectedWeek:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedOneMonth:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedThreeMonth:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedSixMonth:(UIButton*)button;
- (void)maxChartLegendViewDidSelectedYear:(UIButton*)button;
@optional
- (void)maxChartLegendViewDidSelectedZoom:(UIButton*)button;

@end

@interface AIMaxChartLegendView : UIView
/** 代理*/
@property(nonatomic,weak)id<AIMaxChartLegendViewDelegate> delegate;

/** 缩放*/
@property(nonatomic, copy)void(^zoomBlock)();

- (void)selectedFirst;


@end
