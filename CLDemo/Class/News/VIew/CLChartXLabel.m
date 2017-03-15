//
//  CLChartXLabel.m
//  CLDemo
//
//  Created by JmoVxia on 2017/3/15.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartXLabel.h"

@implementation CLChartXLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _label = [UILabel new];
    _label.frame = CGRectMake(0, 0, self.CLheight - 1, self.CLheight - 1);
    _label.CLcenterY = self.CLheight * 0.5;
    _label.CLcenterX = self.CLwidth * 0.5;
    _label.font = [UIFont systemFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)setRound:(BOOL)round{
    _round = round;
    if (_round) {
        _label.layer.cornerRadius = _label.CLwidth *0.5;
        _label.clipsToBounds = YES;
        _label.backgroundColor = CLRandomColor;
    }
}



@end
