//
//  CLHorizontalLayoutView.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLHorizontalLayoutView.h"
#import "CLHorizontalLayout.h"
#import <Masonry/Masonry.h>
#import "CLHorizontalLayoutItemProtocol.h"
#import "CLHorizontalLayoutCellProtocol.h"

@interface CLHorizontalLayoutView ()<UICollectionViewDelegate, UICollectionViewDataSource>

///数据源
@property(nonatomic, weak)id<CLHorizontalLayoutViewDataSource> dataSource;

///collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
///layout
@property (nonatomic, strong) CLHorizontalLayout *layout;

///数据源
@property (nonatomic, strong) NSArray<CLHorizontalLayoutItemProtocol *> *dataArray;
///每行计数
@property (nonatomic, strong) NSNumber *itemCountPerRow;
///最大行数
@property (nonatomic, strong) NSNumber *maxRowCount;
///item 大小
@property (nonatomic, strong) NSValue *itemSize;

@end

@implementation CLHorizontalLayoutView

- (instancetype)initWithDataSource:(id<CLHorizontalLayoutViewDataSource>)dataSource {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        [self initUI];
        [self mas_makeConstraints];
        [self registerCell];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = cl_RandomColor;
    [self addSubview:self.collectionView];
}
- (void)mas_makeConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
}
- (void)registerCell {
    NSArray *classArray = self.dataSource.registerClassArray;
    for (Class item in classArray) {
        [self.collectionView registerClass:item forCellWithReuseIdentifier:NSStringFromClass(item)];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
        id item = [self.dataArray objectAtIndex:indexPath.row];
        if ([item conformsToProtocol:@protocol(CLHorizontalLayoutItemProtocol)]) {
            Class cellClass = [item dequeueReusableCellClass];
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
            if ([cell conformsToProtocol:@protocol(CLHorizontalLayoutCellProtocol)]) {
                [((id)cell) updateItem:item];
            }
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = [UIColor orangeColor];
            }else {
                cell.backgroundColor = [UIColor cyanColor];
            }
            return cell;
        }
        return nil;
    }else{
       return nil;
    }
}
- (NSNumber *)itemCountPerRow {
    if (_itemCountPerRow) {
        return _itemCountPerRow;
    }
    _itemCountPerRow = [NSNumber numberWithInteger:self.dataSource.itemCountPerRow];
    return _itemCountPerRow;
}
- (NSNumber *)maxRowCount {
    if (_maxRowCount) {
        return _maxRowCount;
    }
    _maxRowCount = [NSNumber numberWithInteger:self.dataSource.maxRowCount];
    return _maxRowCount;
}
- (NSValue *)itemSize {
    if (_itemSize) {
        return _itemSize;
    }
    _itemSize = [NSValue valueWithCGSize:self.dataSource.itemSize];
    return _itemSize;
}
- (NSArray<CLHorizontalLayoutItemProtocol *> *)dataArray {
    if (_dataArray) {
        return _dataArray;
    }
    _dataArray = self.dataSource.dataArray;
    return _dataArray;
}
- (void)reloadData {
    self.itemCountPerRow = nil;
    self.maxRowCount = nil;
    self.itemSize = nil;
    self.dataArray = nil;
    [self.layout invalidateLayout];
    self.layout.itemSize = self.itemSize.CGSizeValue;
    NSInteger rowCount;
    CGFloat dataArrayCount = (CGFloat)self.dataArray.count;
    CGFloat maxRowCount = self.maxRowCount.floatValue;
    CGFloat itemCountPerRow = self.itemCountPerRow.floatValue;
    if (self.dataArray.count == 0) {
        rowCount = 0;
    } else if (dataArrayCount / (maxRowCount * itemCountPerRow) > 1) {
        rowCount = maxRowCount;
    } else {
        rowCount = ceil(dataArrayCount / itemCountPerRow);
    }
    CGFloat collectionViewHeight = rowCount * self.itemSize.CGSizeValue.height;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionViewHeight);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.collectionView reloadData];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGPoint offset = self.collectionView.contentOffset;
    CGFloat width = self.collectionView.bounds.size.width;
    NSInteger index = round(offset.x/width);
    CGPoint newOffset = CGPointMake(index * size.width, offset.y);
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        [self reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        [self.collectionView setContentOffset:newOffset animated:NO];
    }];
}
- (CLHorizontalLayout *)layout {
    if (_layout == nil) {
        _layout = [[CLHorizontalLayout alloc] initWithItemCountPerRow:self.itemCountPerRow.integerValue maxRowCount:self.maxRowCount.integerValue];
        _layout.itemSize = self.itemSize.CGSizeValue;
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
@end
