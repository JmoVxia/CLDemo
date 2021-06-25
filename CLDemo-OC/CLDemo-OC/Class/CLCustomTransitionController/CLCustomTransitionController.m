//
//  CLCustomTransitionController.m
//  CLDemo
//
//  Created by AUG on 2019/8/31.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCustomTransitionController.h"
#import <Masonry/Masonry.h>
#import "CLCustomTransitionAnimationController.h"

@interface CLCustomTransitionController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation CLCustomTransitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic2.jpeg"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    [button setTitle:@"点击或\n拖动我" forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = 1;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor grayColor];
    button.layer.cornerRadius = 40;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 0)).priorityLow();
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.left.greaterThanOrEqualTo(self.view);
        make.top.greaterThanOrEqualTo(self.view).offset(84);
        make.bottom.right.lessThanOrEqualTo(self.view);
    }];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [button addGestureRecognizer:pan];
}
- (void)present {
    CLCustomTransitionAnimationController *controller = [[CLCustomTransitionAnimationController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
    UIView *button = panGesture.view;
    CGPoint newCenter = CGPointMake([panGesture translationInView:panGesture.view].x + button.center.x - [UIScreen mainScreen].bounds.size.width / 2, [panGesture translationInView:panGesture.view].y + button.center.y - [UIScreen mainScreen].bounds.size.height / 2);
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(newCenter).priorityLow();
    }];
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}


@end
