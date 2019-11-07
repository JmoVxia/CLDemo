//
//  CLLineChartView.h
//  CLDemo
//
//  Created by AUG on 2019/9/3.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLLineChartPoint.h"
#import "CLLineChartConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CLLineChartViewDataSource <NSObject>

@required
///点数据
- (NSArray<CLLineChartPoint *> *)lineChartViewPoints;
///x最小
- (CGFloat)lineChartViewXLineMin;
///x最大
- (CGFloat)lineChartViewXLineMax;
///y最小
- (CGFloat)lineChartViewYLineMin;
///y最大
- (CGFloat)lineChartViewYLineMax;
///虚线位置
- (CGFloat)lineChartViewDottedLineY;
///图表宽高
- (CGSize)lineChartViewChartSize;

@end

@interface CLLineChartView : UIView

///数据源
@property (nonatomic, weak) id<CLLineChartViewDataSource> dataSource;
///刷新
- (void)reload;
///更新基本配置，block不会造成循环引用
- (void)updateWithConfigure:(void(^)(CLLineChartConfigure *configure))configureBlock;

@end

NS_ASSUME_NONNULL_END
