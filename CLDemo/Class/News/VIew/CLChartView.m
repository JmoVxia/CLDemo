//
//  CLChartView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartView.h"
#import "CLChartMaskView.h"
@interface CLChartView ()

/**遮罩*/
@property (nonatomic,strong) CLChartMaskView *maskView;

@end



@implementation CLChartView


-(instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array{
    if (self = [super initWithFrame:frame]) {
        self.maskView = [[CLChartMaskView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20) Array:array];
        [self addSubview:self.maskView];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}








@end
