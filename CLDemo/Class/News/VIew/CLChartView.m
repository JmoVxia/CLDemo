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
/**控件原始Farme*/
@property (nonatomic,assign) CGRect customFarme;
/**父类控件*/
@property (nonatomic,strong) UIView *fatherView;
/**全屏标记*/
@property (nonatomic,assign) BOOL   isFullScreen;


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
        _isFullScreen = NO;
        [self addSubview:self.maskView];
        [self addSubview:self.toolBar];
        self.toolBar.nameString = @"血压";
        self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        self.maskView.frame = CGRectMake(10 ,40, self.frame.size.width - 20, self.frame.size.height - 10 - 40);
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
    self.maskView.array = _array;
}

- (void)maxChartLegendViewDidSelectedZoom:(UIButton*)button{
    self.toolBar.dateToolBar.hidden = button.selected;
    self.toolBar.nameToolBar.hidden = !button.selected;
    if (!button.selected) {
        self.customFarme = self.frame;
        self.fatherView = self.superview;
        //添加到Window上
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }];
        self.frame = CGRectMake(0, 0, CLscreenWidth, CLscreenHeight);
        self.isFullScreen = YES;
    }else{
        [self.fatherView addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }];
        self.frame = self.customFarme;
        self.isFullScreen = NO;
    }
    button.selected = !button.selected;
}
-(void)setIsFullScreen:(BOOL)isFullScreen{
    if (isFullScreen) {
        self.toolBar.frame = CGRectMake(0, 0, self.frame.size.height, 40);
        self.maskView.frame = CGRectMake(10 ,40, self.frame.size.height - 20, self.frame.size.width - 10 - 40);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }else{
        self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        self.maskView.frame = CGRectMake(10 ,40, self.frame.size.width - 20, self.frame.size.height - 10 - 40);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

@end
