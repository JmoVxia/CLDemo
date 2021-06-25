//
//  CLChangeFontSizeSlider.m
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLChangeFontSizeSlider.h"
#import "CLChangeFontSizeHelper.h"
#import "UIView+CLEvents.h"
#import "UIFont+CLFont.h"
#import "UIView+CLSetRect.h"

@interface CLChangeFontSizeSlider ()<UIGestureRecognizerDelegate>

/**背景*/
@property (nonatomic, strong) UIImageView *backgroundImageView;
/**slider*/
@property (nonatomic, strong) UISlider *slider;
/**左边label*/
@property (nonatomic, strong) UILabel *leftLabel;
/**标准label*/
@property (nonatomic, strong) UILabel *standardLabel;
/**右边label*/
@property (nonatomic, strong) UILabel *rightLabel;
/**tap手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
/**上次滑动的值*/
@property (nonatomic, assign) NSInteger lastScrollValue;
/**上次点击的值*/
@property (nonatomic, assign) NSInteger lastTapValue;

@end



@implementation CLChangeFontSizeSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.cl_width - 70, 30)];
    _slider.center = CGPointMake(self.frame.size.width / 2.0, self.cl_height - 60);
    _slider.minimumValue = 1;
    _slider.maximumValue = 6;
    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    _lastScrollValue = _lastTapValue = [CLChangeFontSizeHelper fontSizeCoefficient];
    [_slider setValue:_lastScrollValue];
    //添加点击手势和滑块滑动事件响应
    [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_slider];
    __weak __typeof(self) weakSelf = self;
    _tapGesture = [_slider addGestureTapEventHandle:^(id  _Nonnull sender, UITapGestureRecognizer * _Nonnull gestureRecognizer) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        [strongSelf tapAction:gestureRecognizer];
    }];
    _tapGesture.delegate = self;
    [_slider addGestureRecognizer:_tapGesture];
    
    //背景图
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cl_width - 70 - 30, 8)];
    _backgroundImageView.center = _slider.center;
    UIImage *img = [UIImage imageNamed:@"woxin_setFontSize_line"];
    _backgroundImageView.image = img;
    [self addSubview:_backgroundImageView];
    //slider发送到上层
    [self bringSubviewToFront:_slider];
    
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backgroundImageView.cl_x - 3, 20, 30, 20)];
    _leftLabel .font = [UIFont clFontOfSize:13];
    _leftLabel .text = @"A";
    [self addSubview:_leftLabel];
    
    _standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backgroundImageView.cl_x + _backgroundImageView.cl_width / 5.0 - 12, 20, 50, 20)];
    _standardLabel .font = [UIFont clFontOfSize:15.5];
    _standardLabel .text = @"标准";
    _standardLabel.textColor = [UIColor grayColor];
    [self addSubview:_standardLabel];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backgroundImageView.frame.origin.x + _backgroundImageView.cl_width - 7, 20, 30, 20)];
    _rightLabel .font = [UIFont clFontOfSize:24];
    _rightLabel .text = @"A";
    [self addSubview:_rightLabel];
}
//MARK:JmoVxia---数值改变
- (void)valueChanged:(UISlider *)sender {
    //只取整数值，固定间距
    NSString *tempStr = [self numberFormat:sender.value];
    if (tempStr.floatValue == sender.value) {
        return;
    }
    [sender setValue:tempStr.floatValue];
    [self changeFontCoefficient:tempStr.integerValue];
}
//MARK:JmoVxia---点击sender
- (void)tapAction:(UITapGestureRecognizer *)sender {
    //取得点击点
    CGPoint point = [sender locationInView:sender.view];
    //计算处于背景图的几分之几，并将之转换为滑块的值（1~6）
    float tempFloat = (point.x - 15 ) / (_slider.cl_width - 30) * 5 + 1;
    NSString *tempStr = [self numberFormat:tempFloat];    
    [_slider setValue:tempStr.floatValue];
    [self tapEndCoefficient:tempStr.integerValue];
}
//MARK:JmoVxia---按下sender
- (void)sliderTouchDown:(UISlider *)sender {
    _tapGesture.enabled = NO;
}
//MARK:JmoVxia---放开sender
- (void)sliderTouchUp:(UISlider *)sender {
    _tapGesture.enabled = YES;
    NSString *tempStr = [self numberFormat:sender.value];
    [self tapEndCoefficient:tempStr.integerValue];
}
//MARK:JmoVxia---格式化数值
- (NSString *)numberFormat:(float)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
//MARK:JmoVxia---点击结束
- (void)tapEndCoefficient:(NSInteger)coefficient {
    if (_lastTapValue == coefficient) {
        return;
    }
    [CLChangeFontSizeHelper setFontSizeCoefficient:coefficient];
    if (self.endChangeBlock) {
        self.endChangeBlock(coefficient);
    }
    _lastTapValue = coefficient;
}
//MARK:JmoVxia---改变数值
- (void)changeFontCoefficient:(NSInteger )coefficient{
    if (_lastScrollValue == coefficient) {
        return;
    }
    [CLChangeFontSizeHelper setFontSizeCoefficient:coefficient];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(coefficient);
    }
    _lastScrollValue = coefficient;
}


@end
