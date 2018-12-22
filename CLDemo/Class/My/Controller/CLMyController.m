

//
//  MeController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLMyController.h"
#import "CLChangeLanguageController.h"
#import "CLChangeFontSizeController.h"
#import "CLRotateAnimationController.h"
#import "CLDemo-Swift.h"

@interface CLMyController ()<UITableViewDelegate,UITableViewDataSource>

/**tableview*/
@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayDS;



@end

@implementation CLMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"我的", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDS.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.arrayDS[indexPath.row];
    cell.textLabel.font = [UIFont clFontOfSize:18];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    });
    if (indexPath.row == 0) {
        CLChangeLanguageController *languageController = [CLChangeLanguageController new];
        [self.navigationController pushViewController:languageController animated:YES];
    }else if (indexPath.row == 1) {
        CLChangeFontSizeController *fontSizeController = [CLChangeFontSizeController new];
        [self.navigationController pushViewController:fontSizeController animated:YES];
    }else if (indexPath.row == 2) {
        CLRotateAnimationController *rotateAnimationController = [CLRotateAnimationController new];
        [self.navigationController pushViewController:rotateAnimationController animated:YES];
    }else if (indexPath.row == 3) {
        CLRotatingPictureViewController *rotatingPictureViewController = [CLRotatingPictureViewController new];
        [self.navigationController pushViewController:rotatingPictureViewController animated:YES];
    }
}
- (UITableView *) tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *) arrayDS{
    if (_arrayDS == nil){
        _arrayDS = [[NSMutableArray alloc] init];
        [_arrayDS addObject:NSLocalizedString(@"切换语言", nil)];
        [_arrayDS addObject:NSLocalizedString(@"修改字号", nil)];
        [_arrayDS addObject:NSLocalizedString(@"转子动画", nil)];
        [_arrayDS addObject:NSLocalizedString(@"图片旋转", nil)];
    }
    return _arrayDS;
}

-(void)dealloc {
    CLLog(@"我的页面销毁了");
}

@end
