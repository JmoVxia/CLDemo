//
//  CLBroadcastController.m
//  CLDemo-OC
//
//  Created by Chen JmoVxia on 2021/6/24.
//

#import "CLBroadcastController.h"
#import "CLBroadcastView.h"
#import "CLBroadcastMainCell.h"
#import "Masonry.h"
#import "CLGCDTimerManagerOC.h"

@interface CLBroadcastController ()<CLBroadcastViewDelegate, CLBroadcastViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrayDS;

@property (nonatomic, strong) UIView *layoutView;

@property (nonatomic, strong) UILabel *customLabel;

@property (nonatomic, strong) CLBroadcastView *broadcastView1;

@property (nonatomic, strong) CLBroadcastView *broadcastView2;

@property (nonatomic, strong) CLBroadcastView *broadcastView3;

@property (nonatomic, strong) CLGCDTimerOC *timer;


@end

@implementation CLBroadcastController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.layoutView];
    [self.layoutView addSubview: self.customLabel];
    [self.layoutView addSubview: self.broadcastView1];
    [self.layoutView addSubview: self.broadcastView2];
    [self.layoutView addSubview: self.broadcastView3];
    
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
    }];
    [self.customLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.layoutView);
    }];
    [self.broadcastView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customLabel.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.layoutView);
        make.height.mas_equalTo(60);
    }];
    [self.broadcastView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.broadcastView1.mas_bottom);
        make.left.right.mas_equalTo(self.layoutView);
        make.height.mas_equalTo(60);
    }];
    [self.broadcastView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.broadcastView2.mas_bottom);
        make.left.right.mas_equalTo(self.layoutView);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.layoutView);
    }];
    [self reload];
    [self.timer start];
}

- (void)reload {
    [self.broadcastView1 reloadData];
    [self.broadcastView2 reloadData];
    [self.broadcastView3 reloadData];
}
- (void)scrollToNext {
    [self.broadcastView1 scrollToNext];
    [self.broadcastView2 scrollToNext];
    [self.broadcastView3 scrollToNext];
}
-(NSMutableArray *)arrayDS {
    if (!_arrayDS) {
        _arrayDS = [NSMutableArray array];
        [_arrayDS addObject: @"我是第一个"];
        [_arrayDS addObject: @"我是第二个"];
        [_arrayDS addObject: @"我是第三个"];
        [_arrayDS addObject: @"我是第四个"];
        [_arrayDS addObject: @"我是第伍个"];
    }
    return  _arrayDS;
}
- (CLGCDTimerOC *)timer {
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        _timer = [[CLGCDTimerOC alloc] initWithInterval:1 delaySecs:1 queue:dispatch_get_main_queue() repeats:YES action:^(NSInteger actionTimes) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf scrollToNext];
        }];
    }
    return _timer;
}
- (UIView *)layoutView {
    if (!_layoutView) {
        _layoutView = [UIView new];
    }
    return _layoutView;
}
- (UILabel *)customLabel {
    if (!_customLabel) {
        _customLabel = [UILabel new];
        _customLabel.textAlignment = NSTextAlignmentCenter;
        _customLabel.text = @"自定义View";
        _customLabel.textColor = [UIColor redColor];
    }
    return _customLabel;
}
- (CLBroadcastView *)broadcastView1 {
    if (!_broadcastView1) {
        _broadcastView1 = [[CLBroadcastView alloc] init];
        _broadcastView1.delegate = self;
        _broadcastView1.dataSource = self;
        _broadcastView1.tag = 0;
        [_broadcastView1 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
    }
    return _broadcastView1;
}
- (CLBroadcastView *)broadcastView2 {
    if (!_broadcastView2) {
        _broadcastView2 = [[CLBroadcastView alloc] init];
        _broadcastView2.delegate = self;
        _broadcastView2.dataSource = self;
        _broadcastView2.tag = 1;
        [_broadcastView2 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
    }
    return _broadcastView2;
}
- (CLBroadcastView *)broadcastView3 {
    if (!_broadcastView3) {
        _broadcastView3 = [[CLBroadcastView alloc] init];
        _broadcastView3.delegate = self;
        _broadcastView3.dataSource = self;
        _broadcastView3.tag = 2;
        [_broadcastView3 registerClass:[CLBroadcastMainCell class] forCellReuseIdentifier:@"CLBroadcastMainCell"];
    }
    return _broadcastView3;
}

- (nonnull CLBroadcastCell *)broadcastView:(nonnull CLBroadcastView *)broadcast cellForRowAtIndex:(NSInteger)index {
    CLBroadcastMainCell *cell = (CLBroadcastMainCell *)[broadcast dequeueReusableCellWithIdentifier: @"CLBroadcastMainCell"];
    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent: 0.3];
    NSInteger currentIndex = (index + broadcast.tag) % self.arrayDS.count;
    cell.adText = self.arrayDS[currentIndex];
    return cell;
}

- (NSInteger)broadcastViewRows:(nonnull CLBroadcastView *)broadcast {
    return self.arrayDS.count;
}


@end
