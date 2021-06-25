//
//  CLLayoutController.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLLayoutController.h"
#import "CLLayoutView.h"
#import <Masonry/Masonry.h>
#import "CLHorizontalItem.h"
#import "CLHorizontalCell.h"
#import "CLVerticalItem.h"
#import "CLVerticalCell.h"
#import "CLLayoutItemProtocol.h"
#import "UIView+CLSetRect.h"

@interface CLLayoutController ()<CLLayoutViewDataSource>

///水平
@property (nonatomic, strong) CLLayoutView *horizontalLayoutView;
///水平
@property (nonatomic, strong) UILabel *horizontalLayoutLabel;

///竖直
@property (nonatomic, strong) CLLayoutView *verticalLayoutView;
///竖直
@property (nonatomic, strong) UILabel *verticalLayoutLabel;

///添加按钮
@property (nonatomic, strong) UIButton *addButton;
///减少按钮
@property (nonatomic, strong) UIButton *deleteButton;

///水平数据
@property (nonatomic, strong) NSMutableArray<id<CLLayoutItemProtocol>> *horizontalLayoutArray;
///竖直数据
@property (nonatomic, strong) NSMutableArray<id<CLLayoutItemProtocol>> *verticalLayoutArray;


@end

@implementation CLLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.horizontalLayoutLabel];
    [self.view addSubview:self.horizontalLayoutView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.deleteButton];
    
    [self.view addSubview:self.verticalLayoutLabel];
    [self.view addSubview:self.verticalLayoutView];
    
    [self.horizontalLayoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(160);
    }];
    [self.horizontalLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.horizontalLayoutLabel.mas_bottom).mas_equalTo(15);
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
    
    [self.verticalLayoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.deleteButton.mas_bottom).mas_offset(30);
    }];
    [self.verticalLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verticalLayoutLabel.mas_bottom).mas_equalTo(15);
        make.left.right.equalTo(self.view);
    }];
    
    self.horizontalLayoutArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 28; i++) {
        CLHorizontalItem *item = [CLHorizontalItem new];
        item.text = [NSString stringWithFormat:@"%ld",i];
        [self.horizontalLayoutArray addObject:item];
    }
    [self.horizontalLayoutView reloadData];
    
    self.verticalLayoutArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 22; i++) {
        CLVerticalItem *item = [CLVerticalItem new];
        item.text = [NSString stringWithFormat:@"%ld",i];
        [self.verticalLayoutArray addObject:item];
    }
    [self.verticalLayoutView reloadData];
}
- (void)addButtonAction {
    CLHorizontalItem *horizontalLastItem = self.horizontalLayoutArray.lastObject;
    CLHorizontalItem *horizontalItem = [CLHorizontalItem new];
    if (horizontalLastItem) {
        horizontalItem.text = [NSString stringWithFormat:@"%ld", [horizontalLastItem.text integerValue] + 1];
    }else {
        horizontalItem.text = @"0";
    }
    [self.horizontalLayoutArray addObject:horizontalItem];
    [self.horizontalLayoutView reloadData];
    
    CLVerticalItem *verticalLastItem = self.verticalLayoutArray.lastObject;
    CLVerticalItem *verticalItem = [CLVerticalItem new];
    if (verticalLastItem) {
        verticalItem.text = [NSString stringWithFormat:@"%ld", [verticalLastItem.text integerValue] + 1];
    }else {
        verticalItem.text = @"0";
    }
    [self.verticalLayoutArray addObject:verticalItem];
    [self.verticalLayoutView reloadData];
}
- (void)deleteButtonAction {
    [self.horizontalLayoutArray removeLastObject];
    [self.horizontalLayoutView reloadData];
    
    [self.verticalLayoutArray removeLastObject];
    [self.verticalLayoutView reloadData];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.horizontalLayoutView viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
//MARK: - JmoVxia---CLLayoutViewDataSource
///item数组
- (NSArray<id<CLLayoutItemProtocol>> *)dataArrayInLayout:(CLLayoutView *)layoutView {
    if (layoutView == self.horizontalLayoutView) {
        return self.horizontalLayoutArray;
    }else {
        return self.verticalLayoutArray;
    }
}
///每行计数
- (NSInteger)itemCountPerRowInLayout:(CLLayoutView *)layoutView {
    if (layoutView == self.horizontalLayoutView) {
        return 3;
    }else {
        return 4;
    }
}
///最大行数
- (NSInteger)maxRowCountInLayout:(CLLayoutView *)layoutView {
    if (layoutView == self.horizontalLayoutView) {
        return 2;
    }else {
        return 3;
    }
}
///item 大小
- (CGSize)itemSizeInLayout:(CLLayoutView *)layoutView {
    if (layoutView == self.horizontalLayoutView) {
        return CGSizeMake(CGRectGetWidth(self.view.bounds) / 3.0, 75);
    }else {
        return CGSizeMake(80, 80);
    }
}
///item左右间距，竖直布局生效
- (CGFloat)minimumInteritemSpacingInVerticalLayout:(CLLayoutView *)layoutView {
    return (cl_screenWidth - 80 * 4) / 12.0;
}
///section左侧间距，竖直布局生效
- (CGFloat)sectionLeftSpacingInVerticalLayout:(CLLayoutView *)layoutView {
    return (cl_screenWidth - 80 * 4) / 4.0;
}
///section右侧间距，竖直布局生效
- (CGFloat)sectionRightSpacingInVerticalLayout:(CLLayoutView *)layoutView {
    return (cl_screenWidth - 80 * 4) / 4.0;
}
//MARK: - JmoVxia---懒加载
- (UILabel *) horizontalLayoutLabel {
    if (_horizontalLayoutLabel == nil) {
        _horizontalLayoutLabel = [[UILabel alloc] init];
        _horizontalLayoutLabel.text = @"水平布局";
    }
    return _horizontalLayoutLabel;
}
- (UILabel *) verticalLayoutLabel {
    if (_verticalLayoutLabel == nil) {
        _verticalLayoutLabel = [[UILabel alloc] init];
        _verticalLayoutLabel.text = @"竖直布局";
    }
    return _verticalLayoutLabel;
}
- (CLLayoutView *) horizontalLayoutView {
    if (_horizontalLayoutView == nil) {
        _horizontalLayoutView = [[CLLayoutView alloc] initWithScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _horizontalLayoutView.backgroundColor = cl_RandomColor;
        _horizontalLayoutView.dataSource = self;
        [_horizontalLayoutView registerClass:[CLHorizontalCell class]];
    }
    return _horizontalLayoutView;
}
- (UIButton *) addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _addButton.backgroundColor = [UIColor orangeColor];
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
- (CLLayoutView *) verticalLayoutView {
    if (_verticalLayoutView == nil) {
        _verticalLayoutView = [[CLLayoutView alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
        _verticalLayoutView.backgroundColor = cl_RandomColor;
        _verticalLayoutView.dataSource = self;
        [_verticalLayoutView registerClass:[CLVerticalCell class]];
    }
    return _verticalLayoutView;
}
@end
