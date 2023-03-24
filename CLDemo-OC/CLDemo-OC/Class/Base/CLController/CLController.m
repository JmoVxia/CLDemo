//
//  CLController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLController.h"
#import "CLNavigationController.h"

@interface CLController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CLController

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor orangeColor];
    }
    return _titleLabel;
}

// MARK: - view生命周期

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self makeConstraints];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(CLNavigationController *)self.navigationController setNavigationBarBackgroundColor:self.navigationBarBackgroundColor];
    [self.navigationController setNavigationBarHidden:self.isHiddenNavigationBar animated:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
-(void)initSubViews {
    self.hiddenStatusBar = NO;
    self.hiddenNavigationBar = NO;
    self.sideSlipBack = YES;
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.navigationBarBackgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleLabel;
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    pan.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:pan];
}

-(void)makeConstraints {
}

// MARK: - 重写父类方法

-(BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

-(BOOL)prefersStatusBarHidden {
    return self.isHiddenStatusBar;
}

-(UIUserInterfaceStyle)overrideUserInterfaceStyle API_AVAILABLE(ios(13.0)) {
    return UIUserInterfaceStyleLight;
}

// MARK: - 手势代理

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (!self.isSideSlipBack) {
        return NO;
    }
    BOOL isResponds = [self.navigationController.interactivePopGestureRecognizer.delegate respondsToSelector:NSSelectorFromString(@"handleNavigationTransition:")];
    if (!isResponds) {
        return NO;
    }
    return self.navigationController.childViewControllers.count > 1;
}

// MARK: - public方法

-(void)back {
    if (self.navigationController.presentingViewController != nil && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)updateTitleLabel:(void (^)(UILabel *))viewCallback {
    if (viewCallback) {
        viewCallback(self.titleLabel);
        [self.titleLabel sizeToFit];
        self.navigationItem.titleView = self.titleLabel;
    }
}

// MARK: - 重写set,get方法

-(void)setTitleText:(NSString *)titleText {
    if (titleText.length > 0) {
        self.titleLabel.text = titleText;
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar {
    _hiddenNavigationBar = hiddenNavigationBar;
    [self.navigationController setNavigationBarHidden:_hiddenNavigationBar animated:YES];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    _navigationBarBackgroundColor = navigationBarBackgroundColor;
    [(CLNavigationController *)self.navigationController setNavigationBarBackgroundColor:_navigationBarBackgroundColor];
}

-(CGFloat)navigationBarHeight {
    return self.navigationController.navigationBar.bounds.size.height;
}

-(CGFloat)tabBarHeight {
    return self.tabBarController.tabBar.frame.size.height;
}

-(NSString *)titleText {
    return self.titleLabel.text;
}

@end
