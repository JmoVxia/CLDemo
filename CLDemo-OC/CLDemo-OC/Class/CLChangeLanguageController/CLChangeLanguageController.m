//
//  SettingViewController.m
//  CLDemo
//
//  Created by AUG on 2018/11/7.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLChangeLanguageController.h"
#import "CLLanguageManager.h"
#import "NSBundle+CLLanguage.h"
#import "CLHomepageController.h"
#import "CLTabbarController.h"
#import "Masonry.h"
#import "UIFont+CLFont.h"


@interface CLChangeLanguageController () <UITableViewDelegate, UITableViewDataSource>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CLChangeLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"切换语言", nil);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
    }];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }

//     Configure the cell...
//    用户没有自己设置的语言，则跟随手机系统
    if (![CLLanguageManager userLanguage].length) {
        cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        if ([NSBundle isChineseLanguage]) {
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"跟随系统", nil);
    }else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"中文", nil);
    }else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"英文", nil);
    }
    cell.textLabel.font = [UIFont clFontOfSize:18];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        return;
    }
    for (UITableViewCell *acell in tableView.visibleCells) {
        acell.accessoryType = acell == cell ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0) {
        [CLLanguageManager setUserLanguage:nil];
    } else if (indexPath.row == 1) {
        [CLLanguageManager setUserLanguage:@"zh-Hans"];
    } else {
        [CLLanguageManager setUserLanguage:@"en"];
    }
    [self refreshRootViewController];
}
- (void)refreshRootViewController {
    //创建新的根控制器
    CLTabbarController *tabbarController = [[CLTabbarController alloc] init];
    tabbarController.selectedIndex = 0;
    UINavigationController *navigationController = tabbarController.selectedViewController;
    NSMutableArray *viewControllers = navigationController.viewControllers.mutableCopy;
    //取出我的页面，提前加载，解决返回按钮不变化
    CLHomepageController *me = (CLHomepageController *)[viewControllers firstObject];
    [me loadViewIfNeeded];
    //新建设置语言页面
    CLChangeLanguageController *languageController = [[CLChangeLanguageController alloc] init];
    languageController.hidesBottomBarWhenPushed = YES;
    [viewControllers addObject:languageController];
    //解决奇怪的动画bug。
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
        navigationController.viewControllers = viewControllers;
        NSLog(@"已切换到语言 %@", [NSBundle currentLanguage]);
    });
}

- (UITableView *) tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)dealloc {
    NSLog(@"语言切换页面销毁了");
}

@end
