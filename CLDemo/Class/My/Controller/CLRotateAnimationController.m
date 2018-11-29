//
//  CLRotateAnimationController.m
//  CLDemo
//
//  Created by AUG on 2018/11/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLRotateAnimationController.h"
#import "CLRotateAnimationView.h"

@interface CLRotateAnimationController ()

@end

@implementation CLRotateAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];

    CLRotateAnimationView *rotateAnimationView = [[CLRotateAnimationView alloc] initWithFrame:CGRectMake(120, 120, 120, 120)];
    [rotateAnimationView createCircle:-M_PI_2 andEndAngle:(M_PI + M_PI_2)];
    [self.view addSubview:rotateAnimationView];

}



@end
