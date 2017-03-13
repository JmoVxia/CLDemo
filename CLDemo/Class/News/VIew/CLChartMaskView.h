//
//  CLChartMaskView.h
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Week,
    OneMonth,
    ThreeMonth,
    SixMonth,
    Year
} timeType;


@interface CLChartMaskView : UIView

/**数据*/
@property (nonatomic,strong) NSDictionary *dic;



@end
