//
//  CLHorizontalLayoutController.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLHorizontalLayoutController.h"
#import "CLHorizontalLayoutView.h"
#import <Masonry/Masonry.h>
#import "CLHorizontalLayoutCell.h"
#import "CLHorizontalLayoutItem.h"

@interface CLHorizontalLayoutController ()<CLHorizontalLayoutViewDataSource>

@property (nonatomic, strong) CLHorizontalLayoutView *horizontalLayoutView;

///添加按钮
@property (nonatomic, strong) UIButton *addButton;
///减少按钮
@property (nonatomic, strong) UIButton *deleteButton;
///数据
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation CLHorizontalLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.horizontalLayoutView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.deleteButton];
    
    [self.horizontalLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(160);
        make.left.right.equalTo(self.view);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.horizontalLayoutView.mas_bottom).mas_offset(30);
        make.width.height.mas_equalTo(40);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(self.horizontalLayoutView.mas_bottom).mas_offset(30);
        make.width.height.mas_equalTo(40);
    }];
    
    self.array = [NSMutableArray array];
    for (NSInteger i = 0; i < 23; i++) {
        CLHorizontalLayoutItem *item = [CLHorizontalLayoutItem new];
        item.text = [NSString stringWithFormat:@"%ld",i];
        [self.array addObject:item];
    }
    [self.horizontalLayoutView reloadData];
}
- (void)addButtonAction {
    CLHorizontalLayoutItem *lastItem = self.array.lastObject;
    CLHorizontalLayoutItem *item = [CLHorizontalLayoutItem new];
    if (lastItem) {
        item.text = [NSString stringWithFormat:@"%ld", [lastItem.text integerValue] + 1];
    }else {
        item.text = @"0";
    }
    [self.array addObject:item];
    [self.horizontalLayoutView reloadData];
}
- (void)deleteButtonAction {
    [self.array removeLastObject];
    [self.horizontalLayoutView reloadData];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.horizontalLayoutView viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
//MARK: - JmoVxia---CLHorizontalLayoutViewDataSource
- (NSArray<Class> *)registerClassArray {
    NSLog(@"==============    registerClassArray");
    NSArray *array = @[[CLHorizontalLayoutCell class]];
    return array;
}
- (NSInteger)itemCountPerRow {
    NSLog(@"==============    itemCountPerRow");
    return 5;
}

- (CGSize)itemSize {
    NSLog(@"==============    itemSize");
    return CGSizeMake(CGRectGetWidth(self.view.bounds) / 5.0, 75);
}

- (NSInteger)maxRowCount {
    NSLog(@"==============    maxRowCount");
    return 2;
}
- (NSArray<CLHorizontalLayoutItemProtocol *> *)dataArray {
    NSLog(@"==============    dataArray");
    return self.array;
}
//MARK: - JmoVxia---懒加载
- (CLHorizontalLayoutView *) horizontalLayoutView {
    if (_horizontalLayoutView == nil) {
        _horizontalLayoutView = [[CLHorizontalLayoutView alloc] initWithDataSource:self];
    }
    return _horizontalLayoutView;
}
- (UIButton *) addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _addButton.backgroundColor = [UIColor blackColor];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:40];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton setTitle:@"+" forState:UIControlStateSelected];
    }
    return _addButton;
}
- (UIButton *) deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:40];
        [_deleteButton setTitle:@"-" forState:UIControlStateNormal];
        [_deleteButton setTitle:@"-" forState:UIControlStateSelected];
    }
    return _deleteButton;
}
@end
