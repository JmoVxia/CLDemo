//
//  CLBroadcastViewController.m
//  CLDemo
//
//  Created by AUG on 2019/9/4.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBroadcastViewController.h"
#import "CLBroadcastView.h"
#import <Masonry/Masonry.h>

@interface CLBroadcastViewController ()<CLBroadcastViewDataSource>

///广播view
@property (nonatomic, strong) CLBroadcastView *broadcastView;
///数据源
@property (nonatomic, strong) NSMutableArray *arrayDS;


@end

@implementation CLBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.broadcastView = [[CLBroadcastView alloc] init];
    [self.view addSubview:self.broadcastView];
    [self.broadcastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.center.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    self.broadcastView.backgroundColor = [UIColor redColor];
    self.broadcastView.dataSource = self;
    
    self.arrayDS = [NSMutableArray array];
    
    
    [self.arrayDS addObject:@"旋转木马"];
    
//    [self.arrayDS addObject:@"牛津词典"];
//
//    [self.arrayDS addObject:@"双语例句"];
//
//    [self.arrayDS addObject:@"我找到了一份好工作"];

    [self.broadcastView reloadData];
    
}

///广播个数
- (NSInteger)broadcastViewRows:(CLBroadcastView *)broadcast {
    return self.arrayDS.count;
}
///创建cell
- (CLBroadcastCell *)broadcastView:(CLBroadcastView *)broadcast cellForRowAtIndexIndex:(NSInteger)index {
    CLBroadcastCell *cell = [broadcast dequeueReusableCellWithIdentifier:@"CLBroadcastCell"];
    cell.text = [self.arrayDS objectAtIndex:index];
    cell.backgroundColor = cl_RandomColor;
    return cell;
}

@end
