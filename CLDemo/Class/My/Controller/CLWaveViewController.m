//
//  CLWaveViewController.m
//  CLDemo
//
//  Created by AUG on 2019/3/6.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLWaveViewController.h"
#import "CLWaveView.h"

@interface CLWaveViewController ()

@property (nonatomic, strong) CLWaveView *waveView;

@end

@implementation CLWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.waveView = [[CLWaveView alloc] initWithFrame:CGRectMake(0, 99, self.view.cl_width, 90)];
    self.waveView.alpha = 0.6;
    [self.waveView updateWithConfig:^(CLWaveViewConfigure * _Nonnull configure) {
        configure.color = [UIColor redColor];
        configure.y = 40;
        configure.speed = 0.05;
    }];
    [self.view addSubview:self.waveView];
}

-(void)dealloc {
    [self.waveView invalidate];;
}

@end
