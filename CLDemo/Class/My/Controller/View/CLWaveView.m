//
//  CLWaveView.m
//  CLDemo
//
//  Created by AUG on 2019/3/6.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLWaveView.h"


@interface CLWaveView ()

@property (nonatomic, weak) CADisplayLink *wavesDisplayLink;

@property (nonatomic, strong) CAShapeLayer *firstWavesLayer;

@property (nonatomic, strong) UIColor *firstWavesColor;

///水纹振幅
@property (nonatomic, assign) CGFloat waveA;
///水纹周期
@property (nonatomic, assign) CGFloat waveW;
///位移
@property (nonatomic, assign) CGFloat offsetX;
///波浪高度Y
@property (nonatomic, assign) CGFloat currentK;
///水纹速度
@property (nonatomic, assign) CGFloat wavesSpeed;
///水纹宽度
@property (nonatomic, assign) CGFloat wavesWidth;

@end


@implementation CLWaveView

/*
 y =Asin（ωx+φ）+C
 A表示振幅，也就是使用这个变量来调整波浪的高度
 ω表示周期，也就是使用这个变量来调整在屏幕内显示的波浪的数量
 φ表示波浪横向的偏移，也就是使用这个变量来调整波浪的流动
 C表示波浪纵向的位置，也就是使用这个变量来调整波浪在屏幕中竖直的位置。
 */

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        [self setUpWaves];
    }
    return self;
}
- (void)setUpWaves {
    //设置波浪的宽度
    self.wavesWidth = self.frame.size.width;
    //第一个波浪颜色
    self.firstWavesColor = [UIColor orangeColor];
    //初始化layer
    if (self.firstWavesLayer == nil) {
        //初始化
        self.firstWavesLayer = [CAShapeLayer layer];
        //设置闭环的颜色
        self.firstWavesLayer.fillColor = self.firstWavesColor.CGColor;
        //设置边缘线的颜色
        //        self.firstWavesLayer.strokeColor = [UIColor blueColor].CGColor;
        //设置边缘线的宽度
        //        self.firstWavesLayer.lineWidth = 1.0;
        //        self.firstWavesLayer.strokeStart = 0.0;
        //        self.firstWavesLayer.strokeEnd = 0.8;
        [self.layer addSublayer:self.firstWavesLayer];
    }
    //设置波浪流动速度
    self.wavesSpeed = 0.05;
    //设置振幅
    self.waveA = 12;
    //设置周期
    self.waveW = 0.5/30.0;
    //设置波浪纵向位置
    self.currentK = self.frame.size.height/4;//屏幕居中
    //启动定时器
    CADisplayLink *wavesDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    self.wavesDisplayLink = wavesDisplayLink;
    [self.wavesDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)getCurrentWave:(CADisplayLink *)displayLink{
    //实时的位移
    self.offsetX += self.wavesSpeed;
    [self setCurrentFirstWaveLayerPath];
}
-(void)setCurrentFirstWaveLayerPath{
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = self.currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path, nil, 0, y);
    for (NSInteger i = 0.0f; i <= self.wavesWidth; i++) {
        //正弦函数波浪公式
        y = self.waveA * sin(self.waveW * i + self.offsetX) + self.currentK;
        //将点连成线
        CGPathAddLineToPoint(path, nil, i, y);
    }
    CGPathAddLineToPoint(path, nil, self.wavesWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    self.firstWavesLayer.path = path;
    //使用layer 而没用CurrentContext
    CGPathRelease(path);
}
- (void)invalidate {
    [self.wavesDisplayLink invalidate];
}
-(void)dealloc {
    CLLog(@"波浪视图销毁了");
}


@end
