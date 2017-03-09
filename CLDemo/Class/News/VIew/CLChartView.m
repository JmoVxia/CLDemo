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


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (CLChartMaskView *) maskView{
    if (_maskView == nil){
        _maskView = [[CLChartMaskView alloc] init];
    }
    return _maskView;
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.maskView.dic = _dic;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    self.maskView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
}



@end
