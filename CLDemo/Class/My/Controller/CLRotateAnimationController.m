//
//  CLRotateAnimationController.m
//  CLDemo
//
//  Created by AUG on 2018/11/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLRotateAnimationController.h"
#import "CLRotateAnimationView.h"
#import "CLRoundAnimationView.h"

@interface CLRotateAnimationController ()

@end

@implementation CLRotateAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];

    CLRotateAnimationView *rotateAnimationView = [[CLRotateAnimationView alloc] initWithFrame:CGRectMake(120, 120, 80, 80)];
    [rotateAnimationView updateWithConfigure:^(CLRotateAnimationViewConfigure * _Nonnull configure) {
        configure.backgroundColor = [UIColor orangeColor];
        configure.number = 8;
        configure.duration = 4;
        configure.intervalDuration = 0.2;
    }];
    [rotateAnimationView startAnimation];
    [self.view addSubview:rotateAnimationView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rotateAnimationView pauseAnimation];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rotateAnimationView resumeAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rotateAnimationView stopAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rotateAnimationView startAnimation];
    });
    
    
    CLRoundAnimationView *roundAnimationView = [[CLRoundAnimationView alloc] initWithFrame:CGRectMake(120, 320, 90, 90)];
    [roundAnimationView updateWithConfigure:^(CLRoundAnimationViewConfigure * _Nonnull configure) {
        configure.outBackgroundColor = [UIColor orangeColor];
        configure.inBackgroundColor = [UIColor greenColor];
        configure.duration = 1;
        configure.strokeStart = 0;
        configure.strokeEnd = 0.1;
        configure.inLineWidth = 3;
        configure.outLineWidth = 3;
    }];
    [self.view addSubview:roundAnimationView];
    [roundAnimationView startAnimation];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [roundAnimationView pauseAnimation];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [roundAnimationView resumeAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [roundAnimationView stopAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [roundAnimationView startAnimation];
    });
}

-(void)dealloc {
    CLLog(@"转子动画控制器销毁了");
}

@end
