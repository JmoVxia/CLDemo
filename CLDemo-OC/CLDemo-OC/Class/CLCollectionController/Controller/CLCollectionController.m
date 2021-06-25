//
//  FollowController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLCollectionController.h"
#import "CLSearchViewController.h"
#import "UIFont+CLFont.h"
#import "UIButton+CLBlockAction.h"

@interface CLCollectionController ()

@end

@implementation CLCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"收藏", nil);
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont clFontOfSize:18];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateSelected];
    __weak __typeof(self) weakSelf = self;
    [button addActionBlock:^(UIButton *button) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        NSLog(@"----点击搜索按钮----");
        CLSearchViewController *searchController = [[CLSearchViewController alloc] init];
        searchController.modalPresentationStyle = UIModalPresentationFullScreen;
        searchController.tapAction = ^(NSString * _Nonnull name, NSString * _Nonnull bankCode) {
            [button setTitle:name forState:UIControlStateNormal];
            [button sizeToFit];
            button.center = self.view.center;
            NSLog(@"----%@-----%@",name,bankCode);
        };
        [strongSelf presentViewController:searchController animated:YES completion:nil];
    }];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
}

-(void)dealloc {
    NSLog(@"收藏页面销毁了");
}


@end
