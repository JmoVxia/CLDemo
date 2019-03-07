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

    CLRotateAnimationView *rotateAnimationView = [[CLRotateAnimationView alloc] initWithFrame:CGRectMake(120, 120, 120, 120)];
    [rotateAnimationView createCircle:-M_PI_2 endAngle:(M_PI + M_PI_2)];
    [self.view addSubview:rotateAnimationView];

    
    
    CLRoundAnimationView *roundAnimationView = [[CLRoundAnimationView alloc] initWithFrame:CGRectMake(120, 320, 90, 90)];
    [self.view addSubview:roundAnimationView];
}



@end
