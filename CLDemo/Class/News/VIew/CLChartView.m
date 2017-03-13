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
//左边间距
#define leftSpace  0
//右边间距
#define rightSpace 40
//底部间距
#define bottomSpace 0
//工具条高度
#define toolBarHeight  40


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
/** 缩放*/
@property(nonatomic,strong)UIButton *zoomButton;

@end



@implementation CLChartView

- (CLChartMaskView *) maskView{
    if (_maskView == nil){
        _maskView = [[CLChartMaskView alloc] initWithFrame:CGRectMake(leftSpace ,toolBarHeight, self.frame.size.width - rightSpace - leftSpace, self.frame.size.height - bottomSpace - toolBarHeight)];
    }
    return _maskView;
}
- (CLChartToolBar *) toolBar{
    if (_toolBar == nil){
        _toolBar = [[CLChartToolBar alloc] initWithFrame:CGRectMake(leftSpace, 0, self.frame.size.width - rightSpace - leftSpace, toolBarHeight)];
        _toolBar.delegate = self;
    }
    return _toolBar;
}
- (UIButton *) zoomButton{
    if (_zoomButton == nil){
        _zoomButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - rightSpace, 0, rightSpace, toolBarHeight)];
        _zoomButton.backgroundColor = [UIColor redColor];
        [_zoomButton addTarget:self action:@selector(zoomButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _zoomButton;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _isFullScreen = NO;
        [self addSubview:self.maskView];
        [self addSubview:self.toolBar];
        [self addSubview:self.zoomButton];
        self.toolBar.nameString = @"血压";
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.maskView.dic = _dic;
}

- (void)zoomButtonAction:(UIButton*)button{
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
        self.zoomButton.frame = CGRectMake(self.frame.size.height - rightSpace, 0, rightSpace, toolBarHeight);
        self.toolBar.frame = CGRectMake(leftSpace, 0, self.frame.size.height - rightSpace - leftSpace, toolBarHeight);
        self.maskView.frame = CGRectMake(leftSpace ,toolBarHeight, self.frame.size.height - rightSpace - leftSpace, self.frame.size.width - bottomSpace - toolBarHeight);
        [self setNeedsLayout];
        [self layoutIfNeeded];
//        [self.maskView setNeedsDisplay];
    }else{
        self.zoomButton.frame = CGRectMake(self.frame.size.width - rightSpace, 0, rightSpace, toolBarHeight);
        self.toolBar.frame = CGRectMake(leftSpace, 0, self.frame.size.width - rightSpace - leftSpace, toolBarHeight);
        self.maskView.frame = CGRectMake(leftSpace ,toolBarHeight, self.frame.size.width - rightSpace - leftSpace, self.frame.size.height - bottomSpace - toolBarHeight);
        [self setNeedsLayout];
        [self layoutIfNeeded];
//        [self.maskView setNeedsDisplay];
    }
}

@end
