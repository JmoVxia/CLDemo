//
//  CLWaveView.m
//  CLDemo
//
//  Created by AUG on 2019/3/6.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLWaveView.h"


@interface CLWaveViewConfigure ()

@end

@implementation CLWaveViewConfigure

+ (instancetype)defaultConfigure {
    CLWaveViewConfigure *configure = [[CLWaveViewConfigure alloc] init];
    configure.color = [UIColor orangeColor];
    configure.speed = 0.05;
    configure.amplitude = 12;
    configure.cycle = 0.5/30.0;
    configure.y = configure.amplitude;
    configure.upSpeed = 0;
    return configure;
}

@end



@interface CLWaveView ()

@property (nonatomic, weak) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///配置
@property (nonatomic, strong) CLWaveViewConfigure *configure;
///位移
@property (nonatomic, assign) CGFloat offsetX;

@end


@implementation CLWaveView

- (CLWaveViewConfigure *) configure{
    if (_configure == nil){
        _configure = [CLWaveViewConfigure defaultConfigure];
        _configure.width = self.frame.size.width;
    }
    return _configure;
}
- (void)updateWithConfigure:(void(^)(CLWaveViewConfigure *configure))configureBlock {
    configureBlock(self.configure);
    configureBlock = nil;
    self.shapeLayer.fillColor = self.configure.color.CGColor;
}
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
        [self initUI];
    }
    return self;
}
- (void)initUI {
    //初始化layer
    if (self.shapeLayer == nil) {
        //初始化
        self.shapeLayer = [CAShapeLayer layer];
        //设置闭环的颜色
        self.shapeLayer.fillColor = self.configure.color.CGColor;
        [self.layer addSublayer:self.shapeLayer];
    }
    //启动定时器
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentWave:)];
    self.displayLink = displayLink;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)currentWave:(CADisplayLink *)displayLink{
    //实时的位移
    self.offsetX += self.configure.speed;
    self.configure.y = MAX(self.configure.y - self.configure.upSpeed, self.configure.amplitude);
    [self currentFirstWaveLayerPath];
}
-(void)currentFirstWaveLayerPath{
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = self.configure.y;
    //将点移动到 x=0,y=y的位置
    CGPathMoveToPoint(path, nil, 0, y);
    for (NSInteger i = 0.0f; i <= self.configure.width; i++) {
        //正弦函数波浪公式
        y = self.configure.amplitude * sin(self.configure.cycle * i + self.offsetX) + self.configure.y;
        //将点连成线
        CGPathAddLineToPoint(path, nil, i, y);
    }
    CGPathAddLineToPoint(path, nil, self.configure.width, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    self.shapeLayer.path = path;
    //使用layer 而没用CurrentContext
    CGPathRelease(path);
}
- (void)invalidate {
    [self.displayLink invalidate];
}
-(void)dealloc {
    CLLog(@"波浪视图销毁了");
}
@end
