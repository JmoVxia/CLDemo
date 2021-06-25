//
//  CLCustomTransitionAnimationController.m
//  CLDemo
//
//  Created by AUG on 2019/8/31.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCustomTransitionAnimationController.h"
#import "CLCustomTransitionDelegate.h"

@interface CLCustomTransitionAnimationController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) CLCustomTransitionDelegate *transition;


@end

@implementation CLCustomTransitionAnimationController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self.transition;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic1.jpg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 50, self.view.frame.size.width, 50);
    [self.view addSubview:button];
}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CLCustomTransitionDelegate *) transition {
    if (_transition == nil) {
        _transition = [[CLCustomTransitionDelegate alloc] init];
    }
    return _transition;
}

@end
