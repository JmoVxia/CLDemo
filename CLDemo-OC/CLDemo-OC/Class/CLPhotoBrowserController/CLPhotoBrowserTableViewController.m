//
//  CLPhotoBrowserTableViewController.m
//  CLDemo
//
//  Created by AUG on 2019/7/14.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPhotoBrowserTableViewController.h"
#import "CLPhotoBrowserController.h"
#import "Masonry.h"
#import "UIFont+CLFont.h"

@interface CLPhotoBrowserTableViewController ()<UITableViewDelegate,UITableViewDataSource>

/**tableview*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CLPhotoBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont clFontOfSize:18];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"使用Imgae显示";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"使用ImageUrl显示";
    }
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
    CLPhotoBrowserController *controller =  [[CLPhotoBrowserController alloc] init];
    if (indexPath.row == 0) {
        controller.isImgae = YES;
    }else if (indexPath.row == 1) {
        controller.isImgae = NO;
    }
    [self.navigationController pushViewController:controller animated:YES];
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

@end
