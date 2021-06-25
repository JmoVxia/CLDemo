//
//  CLPresentTransitionController.m
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPresentTransitionController.h"
#import <Masonry/Masonry.h>
#import "CLTransitioningDelegate.h"
#import "UIButton+CLBlockAction.h"

@interface CLPresentTransitionController ()

@property(nonatomic, assign) CLInteractiveCoverDirection presentDirection;

@property(nonatomic, assign) CLInteractiveCoverDirection dissmissDirection;

///转场代理
@property (nonatomic, strong) CLTransitioningDelegate *transitioning;

@end

@implementation CLPresentTransitionController

- (instancetype)initWithPresentDirection:(CLInteractiveCoverDirection)presentDirection dissmissDirection:(CLInteractiveCoverDirection)dissmissDirection {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.presentDirection = presentDirection;
        self.dissmissDirection = dissmissDirection;
        self.transitioningDelegate = self.transitioning;
    }
    return self;
}
- (instancetype)init {
    return [self initWithPresentDirection:CLInteractiveCoverDirectionRightToLeft dissmissDirection:CLInteractiveCoverDirectionLeftToRight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *button = [[UIButton alloc] init];
    __weak __typeof(self) weakSelf = self;
    [button addActionBlock:^(UIButton * _Nullable button) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    button.backgroundColor = [UIColor redColor];
    button.alpha = 0.5;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(90);
    }];
}

- (CLTransitioningDelegate *) transitioning {
    if (_transitioning == nil) {
        _transitioning = [[CLTransitioningDelegate alloc] initWithPresentDirection:self.presentDirection dissmissDirection:self.dissmissDirection dissmissInteractiveController:self];
    }
    return _transitioning;
}


@end
