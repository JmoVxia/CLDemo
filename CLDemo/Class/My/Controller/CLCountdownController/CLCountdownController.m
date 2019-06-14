//
//  CLCountdownController.m
//  CLDemo
//
//  Created by AUG on 2019/6/6.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCountdownController.h"
#import "Masonry.h"
#import "CLCountdownModel.h"
#import "CLCountdownCell.h"
#import "CLGCDTimerManager.h"
#import "NSDate+CLExtension.h"

@interface CLCountdownController ()<UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic, strong) UITableView *tableView;
///数据源
@property (nonatomic, strong) NSMutableArray<CLCountdownModel *> *arrayDS;
///定时器
@property (nonatomic, strong) CLGCDTimer *timer;
///定时器响应次数
@property (nonatomic, assign) NSInteger actionTimes;
///离开的时间
@property (nonatomic, assign) NSTimeInterval resignSystemUpTime;
///恢复的时间
@property (nonatomic, assign) NSTimeInterval becomeSystemUpTime;
///离开总时间
@property (nonatomic, assign) NSInteger leaveTime;

@end

@implementation CLCountdownController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self mas_makeConstraints];
    [self initData];
    [self addNotification];
}
- (void)initUI {
    [self.view addSubview:self.tableView];
    
    UIButton *view = [UIButton new];
    view.cl_size = CGSizeMake(40, 20);
    view.backgroundColor = [UIColor orangeColor];
    __weak __typeof(self) weakSelf = self;
    [view addActionBlock:^(UIButton * _Nullable button) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        CLBaseViewController *controller = [CLBaseViewController new];
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    [self.navigationItem setRightBarButtonItem:item];
}
- (void)mas_makeConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
    }];
}
- (void)initData {
    self.arrayDS = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < 100000; i++) {
            CLCountdownModel *model = [[CLCountdownModel alloc] init];
            model.countdownTime = i + 15;
            model.row = i;
            [self.arrayDS addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            __weak __typeof(self) weakSelf = self;
            self.timer = [[CLGCDTimer alloc] initWithInterval:1 delaySecs:0 queue:dispatch_get_main_queue() repeats:YES action:^(NSInteger actionTimes) {
                __typeof(&*weakSelf) strongSelf = weakSelf;
                strongSelf.actionTimes = actionTimes;
                [strongSelf reloadVisibleCells];
            }];
            [self.timer start];
        });
    });
}
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)applicationWillResignActive:(NSNotification *)notification {
    self.resignSystemUpTime = [NSDate uptimeSinceLastBoot];
    [self.timer suspend];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    self.becomeSystemUpTime = [NSDate uptimeSinceLastBoot];
    self.leaveTime += (NSInteger)floor(self.becomeSystemUpTime - self.resignSystemUpTime);
    [self.timer resume];
}
- (void)reloadVisibleCells {
    for (CLCountdownCell *cell in self.tableView.visibleCells) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        CLCountdownModel *model = [self.arrayDS objectAtIndex:indexPath.row];
        model.actionTimes = self.actionTimes;
        model.leaveTime = self.leaveTime;
        if (model.isPause) {
            continue;
        }
        cell.model = model;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDS.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLCountdownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLCountdownCell" forIndexPath:indexPath];
    cell.model = [self.arrayDS objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CLCountdownModel *model = [self.arrayDS objectAtIndex:indexPath.row];
    model.actionTimes = self.actionTimes;
    model.leaveTime = self.leaveTime;
    if (!model.isPause) {
        CLCountdownCell *countdownCell = (CLCountdownCell *)cell;
        countdownCell.model = model;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    CLLog(@"倒计时页面销毁了");
}
- (UITableView *) tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CLCountdownCell class] forCellReuseIdentifier:@"CLCountdownCell"];
    }
    return _tableView;
}

@end
