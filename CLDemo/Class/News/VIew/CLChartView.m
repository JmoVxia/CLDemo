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

- (CLChartMaskView *) maskView{
    if (_maskView == nil){
        _maskView = [[CLChartMaskView alloc] init];
    }
    return _maskView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.maskView = [[CLChartMaskView alloc] init];
        [self addSubview:self.maskView];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setArray:(NSArray *)array{
    _array = array;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.maskView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
    self.maskView.array = _array;
}




@end
