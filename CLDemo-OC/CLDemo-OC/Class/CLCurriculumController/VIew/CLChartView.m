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
#import "CLChartNameToolBar.h"
#import "UIButton+CLBlockAction.h"

//左边间距
#define leftSpace  0
//右边间距
#define rightSpace 0
//底部间距
#define bottomSpace 0
//工具条高度
#define toolBarHeight  40


@interface CLChartView ()<CLMaxChartLegendViewDelegate>

/**遮罩*/
@property (nonatomic,strong) CLChartMaskView *maskView;
/**顶部工具条*/
@property (nonatomic,strong) CLChartToolBar *toolBar;
/**全屏名称工具条*/
@property (nonatomic,strong) CLChartNameToolBar *nameToolBar;
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
        _toolBar = [[CLChartToolBar alloc] initWithFrame:CGRectMake(leftSpace, 0, self.frame.size.width - rightSpace - leftSpace - 40, toolBarHeight)];
        _toolBar.delegate = self;
    }
    return _toolBar;
}
- (CLChartNameToolBar *) nameToolBar{
    if (_nameToolBar == nil){
        _nameToolBar = [[CLChartNameToolBar alloc] initWithFrame:CGRectMake(leftSpace + 40, toolBarHeight, self.frame.size.width - rightSpace - leftSpace - 40, toolBarHeight)];
        _nameToolBar.hidden = YES;
    }
    return _nameToolBar;
}
- (UIButton *) zoomButton{
    if (_zoomButton == nil){
        _zoomButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, toolBarHeight)];
        _zoomButton.backgroundColor = [UIColor redColor];
        __weak __typeof(self) weakSelf = self;
        [_zoomButton addActionBlock:^(UIButton *button) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf zoomButtonAction:button];
        }];
    }
    return _zoomButton;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _isFullScreen = NO;
        [self addSubview:self.maskView];
        [self addSubview:self.toolBar];
        [self addSubview:self.zoomButton];
        [self addSubview:self.nameToolBar];
        
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)selectedWeek{
    [self.toolBar selectedFirst];
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.toolBar.nameString = @"血肌酐算法";
    self.nameToolBar.nameString = @"血肌酐算法";
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
    self.nameToolBar.hidden = button.selected;
    [self.toolBar selectedFirst];
    if (!button.selected) {
        self.customFarme = self.frame;
        self.fatherView = self.superview;
        //添加到Window上
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }];
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
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
        self.zoomButton.frame = CGRectMake(self.frame.size.height - rightSpace - 40, 0, 40, toolBarHeight);
        self.toolBar.frame = CGRectMake(leftSpace, 0, self.frame.size.height - rightSpace - leftSpace - 40, toolBarHeight);
        self.nameToolBar.frame = CGRectMake(leftSpace + 40, toolBarHeight, self.frame.size.height - rightSpace - leftSpace - 40, toolBarHeight);
        self.maskView.frame = CGRectMake(leftSpace ,toolBarHeight, self.frame.size.height - rightSpace - leftSpace, self.frame.size.width - bottomSpace - toolBarHeight);
    }else{
        self.zoomButton.frame = CGRectMake(self.frame.size.width - rightSpace - 40, 0, 40, toolBarHeight);
        self.toolBar.frame = CGRectMake(leftSpace, 0, self.frame.size.width - rightSpace - leftSpace - 40, toolBarHeight);
        self.nameToolBar.frame = CGRectMake(leftSpace + 40, toolBarHeight, self.frame.size.width - rightSpace - leftSpace - 40, toolBarHeight);
        self.maskView.frame = CGRectMake(leftSpace ,toolBarHeight, self.frame.size.width - rightSpace - leftSpace, self.frame.size.height - bottomSpace - toolBarHeight);
    }
    self.maskView.isFullScreen = isFullScreen;
    [self setNeedsLayout];
    [self layoutIfNeeded];

}
#pragma mark - 按钮点击事件
//一周
- (void)maxChartLegendViewDidSelectedWeek:(UIButton*)button{
    self.maskView.dayType = Week;
    if (_delegate && [_delegate respondsToSelector:@selector(CLChartViewDidSelectedWeek:)]) {
        [_delegate CLChartViewDidSelectedWeek:button];
    }else{
        NSLog(@"未实现代理或者没有代理人");
    }
    
    
}
//一月
- (void)maxChartLegendViewDidSelectedOneMonth:(UIButton*)button{
    self.maskView.dayType = OneMonth;
    if (_delegate && [_delegate respondsToSelector:@selector(CLChartViewDidSelectedOneMonth:)]) {
        [_delegate CLChartViewDidSelectedOneMonth:button];
    }else{
        NSLog(@"未实现代理或者没有代理人");
    }
}
//三月
- (void)maxChartLegendViewDidSelectedThreeMonth:(UIButton*)button{
    self.maskView.dayType = ThreeMonth;
    if (_delegate && [_delegate respondsToSelector:@selector(CLChartViewDidSelectedThreeMonth:)]) {
        [_delegate CLChartViewDidSelectedThreeMonth:button];
    }else{
        NSLog(@"未实现代理或者没有代理人");
    }
}
//六月
- (void)maxChartLegendViewDidSelectedSixMonth:(UIButton*)button{
    self.maskView.dayType = SixMonth;
    if (_delegate && [_delegate respondsToSelector:@selector(CLChartViewDidSelectedSixMonth:)]) {
        [_delegate CLChartViewDidSelectedSixMonth:button];
    }else{
        NSLog(@"未实现代理或者没有代理人");
    }
}
//一年
- (void)maxChartLegendViewDidSelectedYear:(UIButton*)button{
    self.maskView.dayType = Year;
    if (_delegate && [_delegate respondsToSelector:@selector(CLChartViewDidSelectedYear:)]) {
        [_delegate CLChartViewDidSelectedYear:button];
    }else{
        NSLog(@"未实现代理或者没有代理人");
    }
}












@end
