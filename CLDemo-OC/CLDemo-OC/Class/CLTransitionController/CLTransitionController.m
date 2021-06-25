//
//  CLTransitionController.m
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLTransitionController.h"
#import "CLPresentTransitionController.h"
#import <Masonry/Masonry.h>
#import "CLPresentTransitionNavigationController.h"

@interface CLTransitionController ()

@end

@implementation CLTransitionController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.center.mas_equalTo(0);
    }];
    
    
    UIButton *topButton = [[UIButton alloc] init];
    [topButton addTarget:self action:@selector(topBottonAction) forControlEvents:UIControlEventTouchUpInside];
    [topButton setTitle:@"上" forState:UIControlStateNormal];
    [topButton setTitle:@"上" forState:UIControlStateSelected];
    topButton.backgroundColor = [UIColor colorWithRed:1.00 green:0.45 blue:0.45 alpha:1.00];
    [contentView addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton addTarget:self action:@selector(leftBottonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"左" forState:UIControlStateNormal];
    [leftButton setTitle:@"左" forState:UIControlStateSelected];
    leftButton.backgroundColor = [UIColor colorWithRed:1.00 green:0.72 blue:0.45 alpha:1.00];
    [contentView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(topButton.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(60);
    }];

    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton addTarget:self action:@selector(rightBottonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"右" forState:UIControlStateNormal];
    [rightButton setTitle:@"右" forState:UIControlStateSelected];
    rightButton.backgroundColor = [UIColor colorWithRed:0.72 green:0.45 blue:0.72 alpha:1.00];
    [contentView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(topButton.mas_bottom).mas_offset(40);
        make.right.mas_equalTo(-60);
    }];
    
    UIButton *bottomButton = [[UIButton alloc] init];
    [bottomButton addTarget:self action:@selector(bottomBottonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton setTitle:@"下" forState:UIControlStateNormal];
    [bottomButton setTitle:@"下" forState:UIControlStateSelected];
    bottomButton.backgroundColor = [UIColor colorWithRed:0.45 green:0.45 blue:1.00 alpha:1.00];
    [contentView addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(rightButton.mas_bottom).mas_offset(40);
        make.centerX.bottom.mas_equalTo(0);
    }];
}

- (void)topBottonAction {
//    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] init];
//    CLPresentTransitionNavigationController *navController = [[CLPresentTransitionNavigationController alloc] initWithRootViewController:controller presentDirection:CLInteractiveCoverDirectionTopToBottom dissmissDirection:CLInteractiveCoverDirectionBottomToTop];
//    [self presentViewController:navController animated:YES completion:nil];
    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] initWithPresentDirection:CLInteractiveCoverDirectionTopToBottom dissmissDirection:CLInteractiveCoverDirectionBottomToTop];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)leftBottonAction {
//    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] init];
//    CLPresentTransitionNavigationController *navController = [[CLPresentTransitionNavigationController alloc] initWithRootViewController:controller presentDirection:CLInteractiveCoverDirectionLeftToRight dissmissDirection:CLInteractiveCoverDirectionRightToLeft];
//    [self presentViewController:navController animated:YES completion:nil];
    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] initWithPresentDirection:CLInteractiveCoverDirectionLeftToRight dissmissDirection:CLInteractiveCoverDirectionRightToLeft];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)rightBottonAction {
//    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] init];
//    CLPresentTransitionNavigationController *navController = [[CLPresentTransitionNavigationController alloc] initWithRootViewController:controller presentDirection:CLInteractiveCoverDirectionRightToLeft dissmissDirection:CLInteractiveCoverDirectionLeftToRight];
//    [self presentViewController:navController animated:YES completion:nil];
    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] initWithPresentDirection:CLInteractiveCoverDirectionRightToLeft dissmissDirection:CLInteractiveCoverDirectionLeftToRight];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)bottomBottonAction {
//    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] init];
//    CLPresentTransitionNavigationController *navController = [[CLPresentTransitionNavigationController alloc] initWithRootViewController:controller presentDirection:CLInteractiveCoverDirectionBottomToTop dissmissDirection:CLInteractiveCoverDirectionTopToBottom];
//    [self presentViewController:navController animated:YES completion:nil];
    CLPresentTransitionController *controller = [[CLPresentTransitionController alloc] initWithPresentDirection:CLInteractiveCoverDirectionBottomToTop dissmissDirection:CLInteractiveCoverDirectionTopToBottom];
    [self presentViewController:controller animated:YES completion:nil];
}




@end
