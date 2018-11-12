//
//  CLEssenceController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLEssenceController.h"
#import "CLTitleControllerView.h"



@interface CLEssenceController ()<UIScrollViewDelegate>



@end

@implementation CLEssenceController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"主页", nil);
    NSArray *titlesArray = @[NSLocalizedString(@"推荐", nil),NSLocalizedString(@"精华", nil),NSLocalizedString(@"图片", nil),NSLocalizedString(@"声音", nil),NSLocalizedString(@"视频", nil),NSLocalizedString(@"福利", nil)];
    NSString *classString = @"CLEssenceListController";
    //控制器类名数组
    NSMutableArray *controllerClassNameArray = [NSMutableArray array];
    //常态颜色数组
    NSMutableArray *titleNormalColorArray = [NSMutableArray array];
    //选中颜色数组
    NSMutableArray *titleSelectedColorArray = [NSMutableArray array];
    [titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [controllerClassNameArray addObject:classString];
        [titleNormalColorArray addObject:cl_RandomColor];
        [titleSelectedColorArray addObject:cl_RandomColor];
    }];
    //创建
    CLTitleControllerView *titleView =  [[CLTitleControllerView alloc] initWithFrame:CGRectMake(0, cl_statusBarAndNavigationBarHeight, cl_screenWidth, cl_screenHeight - cl_tabbarHeight - cl_statusBarAndNavigationBarHeight) titleArray:[NSMutableArray arrayWithArray:titlesArray] controllerClassNameArray:controllerClassNameArray titleNormalColorArray:titleNormalColorArray titleSelectedColorArray:titleSelectedColorArray number:5 fatherController:self];
    [self.view addSubview:titleView];
}
-(void)dealloc {
    NSLog(@"主页页面销毁了");
}

@end
