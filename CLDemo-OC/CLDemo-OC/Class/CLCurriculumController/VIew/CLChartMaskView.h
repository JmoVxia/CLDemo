//
//  CLChartMaskView.h
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Week = 0,
    OneMonth,
    ThreeMonth,
    SixMonth,
    Year
} DayType;


@interface CLChartMaskView : UIView

/**数据*/
@property (nonatomic,strong) NSDictionary *dic;
/**类型*/
@property (nonatomic,assign) DayType dayType;
/**是否全屏*/
@property (nonatomic,assign) BOOL isFullScreen;



@end
