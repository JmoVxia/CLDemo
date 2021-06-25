//
//  CLChartXLabel.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/15.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartXLabel.h"
#import "UIView+CLSetRect.h"
#import "UIFont+CLFont.h"

@implementation CLChartXLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _label = [UILabel new];
    _label.frame = CGRectMake(0, 0, self.cl_height - 3, self.cl_height - 3);
    _label.cl_centerY = self.cl_height * 0.5;
    _label.cl_centerX = self.cl_width * 0.5;
    _label.font = [UIFont clFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)setRound:(BOOL)round{
    _round = round;
    if (_round) {
        _label.layer.cornerRadius = _label.cl_width *0.5;
        _label.clipsToBounds = YES;
        _label.backgroundColor = cl_RandomColor;
    }
}



@end
