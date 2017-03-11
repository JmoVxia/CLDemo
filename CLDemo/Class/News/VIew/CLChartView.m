//
//  CLChartView.m
//  demo
//
//  Created by JmoVxia on 2017/3/9.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLChartView.h"
#import "CLChartMaskView.h"
#import "CLChartToolBar.h"
@interface CLChartView ()<CLMaxChartLegendViewDelegate>

/**遮罩*/
@property (nonatomic,strong) CLChartMaskView *maskView;
/**顶部工具条*/
@property (nonatomic,strong) CLChartToolBar *toolBar;


@end



@implementation CLChartView

- (CLChartMaskView *) maskView{
    if (_maskView == nil){
        _maskView = [[CLChartMaskView alloc] init];
    }
    return _maskView;
}
- (CLChartToolBar *) toolBar{
    if (_toolBar == nil){
        _toolBar = [[CLChartToolBar alloc] init];
        _toolBar.delegate = self;
    }
    return _toolBar;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskView];
        [self addSubview:self.toolBar];
        self.toolBar.nameString = @"血压";
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
    self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    self.maskView.frame = CGRectMake(10 ,40, self.frame.size.width - 20, self.frame.size.height - 10 - 40);
    self.maskView.array = _array;
}

- (void)maxChartLegendViewDidSelectedZoom:(UIButton*)button{
    self.toolBar.dateToolBar.hidden = button.selected;
    self.toolBar.nameToolBar.hidden = !button.selected;
    button.selected = !button.selected;
}


@end
