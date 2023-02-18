//
//  CLController.h
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLController : UIViewController

@property(nonatomic, assign, getter = isSideSlipBack) BOOL sideSlipBack;

@property(nonatomic, assign, getter = isHiddenStatusBar) BOOL hiddenStatusBar;

@property(nonatomic, assign, getter = isHiddenNavigationBar) BOOL hiddenNavigationBar;

@property(nonatomic, strong) UIColor *navigationBarBackgroundColor;

@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property(nonatomic, strong) NSString *titleText;

-(void)back;

-(void)updateTitleLabel:(void (^)(UILabel *))viewCallback;

-(CGFloat)navigationBarHeight;

-(CGFloat)tabBarHeight;

@end
