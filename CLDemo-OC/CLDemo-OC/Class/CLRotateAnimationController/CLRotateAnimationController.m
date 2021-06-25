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

    {
        CLRotateAnimationView *rotateAnimationView = [[CLRotateAnimationView alloc] initWithFrame:CGRectMake(120, 120, 80, 80)];
        [rotateAnimationView updateWithConfigure:^(CLRotateAnimationViewConfigure * _Nonnull configure) {
            configure.backgroundColor = [UIColor orangeColor];
            configure.number = 8;
            configure.duration = 4;
            configure.intervalDuration = 0.2;
        }];
        [rotateAnimationView startAnimation];
        [self.view addSubview:rotateAnimationView];
    }
    
    {
        CLRoundAnimationView *roundAnimationView = [[CLRoundAnimationView alloc] initWithFrame:CGRectMake(120, 250, 90, 90)];
        [roundAnimationView updateWithConfigure:^(CLRoundAnimationViewConfigure * _Nonnull configure) {
            configure.outBackgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.60];
            configure.inBackgroundColor = [UIColor colorWithRed:0.96 green:0.71 blue:0.05 alpha:1.00];
            configure.duration = 1;
            configure.strokeStart = 0;
            configure.strokeEnd = 0.3;
            configure.inLineWidth = 5;
            configure.outLineWidth = 15;
            configure.position = AnimationMiddle;
        }];
        [self.view addSubview:roundAnimationView];
        [roundAnimationView startAnimation];
    }
    
    {
        CLRoundAnimationView *roundAnimationView = [[CLRoundAnimationView alloc] initWithFrame:CGRectMake(180, 380, 60, 60)];
        [roundAnimationView updateWithConfigure:^(CLRoundAnimationViewConfigure * _Nonnull configure) {
            configure.outBackgroundColor = [UIColor clearColor];
            configure.inBackgroundColor = [UIColor colorWithRed:0.96 green:0.71 blue:0.05 alpha:1.00];
            configure.duration = 0.6;
            configure.strokeStart = 0;
            configure.strokeEnd = 0.3;
            configure.inLineWidth = 5;
            configure.outLineWidth = 5;
            configure.position = AnimationMiddle;
        }];
        [self.view addSubview:roundAnimationView];
        [roundAnimationView startAnimation];
    }

}

-(void)dealloc {
    NSLog(@"转子动画控制器销毁了");
}

@end
