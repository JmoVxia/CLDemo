//
//  CLChangeFontSizeController.m
//  CLDemo
//
//  Created by AUG on 2018/11/11.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLChangeFontSizeController.h"
#import "ChangeFontSizeModel.h"
#import "CLChangeFontSizeCell.h"
#import "CLChangeFontSizeSlider.h"
#import "CLHomepageController.h"
#import "CLTabbarController.h"


@interface CLChangeFontSizeController ()<UITableViewDelegate,UITableViewDataSource>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/**数据*/
@property (nonatomic, strong) NSMutableArray<ChangeFontSizeModel *> *arrayDS;
/**slider*/
@property (nonatomic, strong) CLChangeFontSizeSlider *slider;

@end

@implementation CLChangeFontSizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"修改字号", nil);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.mas_equalTo(self.slider.mas_top);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDS.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLChangeFontSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLChangeFontSizeCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CLChangeFontSizeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CLChangeFontSizeCell"];
    }
    ChangeFontSizeModel *model = self.arrayDS[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeFontSizeModel *model = self.arrayDS[indexPath.row];
    return model.cellHeight;
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
    CLChangeFontSizeController *fontSizeController = [[CLChangeFontSizeController alloc] init];
    fontSizeController.hidesBottomBarWhenPushed = YES;
    [viewControllers addObject:fontSizeController];
    //解决奇怪的动画bug。
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
        navigationController.viewControllers = viewControllers;
        CLLog(@"已切文字大小");
    });
}
- (NSMutableArray *) arrayDS{
    if (_arrayDS == nil){
        _arrayDS = [[NSMutableArray alloc] init];
        
        ChangeFontSizeModel *model1 = [[ChangeFontSizeModel alloc] initWithHeadImage:[UIImage imageNamed:@"1"] contentString:@"预览字体大小" fromMe:YES];
        [_arrayDS addObject:model1];
        
        ChangeFontSizeModel *model2 = [[ChangeFontSizeModel alloc] initWithHeadImage:[UIImage imageNamed:@"2"] contentString:@"拖拽或者点击下面的滑块，可设置字体大小" fromMe:NO];
        [_arrayDS addObject:model2];
        
        ChangeFontSizeModel *model3 = [[ChangeFontSizeModel alloc] initWithHeadImage:[UIImage imageNamed:@"2"] contentString:@"设置后，可改变聊天菜单中的字体大小。如果在使用过程中存在问题或意见，可反馈给我们团队" fromMe:NO];
        [_arrayDS addObject:model3];

    }
    return _arrayDS;
}
- (UITableView *) tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:240.3/255.0 blue:246.3/255.0 alpha:255.0/255.0];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CLChangeFontSizeCell class] forCellReuseIdentifier:@"CLChangeFontSizeCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (CLChangeFontSizeSlider *) slider {
    if (_slider == nil){
        _slider = [[CLChangeFontSizeSlider alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 130, self.view.frame.size.width, 130)];
        __weak __typeof(self) weakSelf = self;
        //value改变，刷新当前页面
        _slider.valueChangeBlock = ^(NSInteger Value) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf.arrayDS enumerateObjectsUsingBlock:^(ChangeFontSizeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj refreshFrame];
            }];
            [strongSelf.tableView reloadData];
        };
        //value停止改变，刷新根控制器
        _slider.endChangeBlock = ^(NSInteger Value) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf refreshRootViewController];
        };
        [self.view addSubview:_slider];
    }
    return _slider;
}
-(void)dealloc {
    CLLog(@"修改字号页面销毁了");
}

@end
