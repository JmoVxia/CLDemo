//
//  CLLayoutView.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLLayoutView.h"
#import "CLHorizontalLayout.h"
#import "CLVerticalLayout.h"
#import "CLLayoutItemProtocol.h"
#import "CLLayoutCellProtocol.h"
#import <Masonry/Masonry.h>

@interface CLLayoutView ()<UICollectionViewDelegate, UICollectionViewDataSource>

///方向
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

///collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
///水平
@property (nonatomic, strong) CLHorizontalLayout *horizontalLayout;
///竖直
@property (nonatomic, strong) CLVerticalLayout *verticalLayout;

///数据源
@property (nonatomic, strong) NSArray<id<CLLayoutItemProtocol>> *dataArray;
///每行计数
@property (nonatomic, strong) NSNumber *itemCountPerRow;
///最大行数
@property (nonatomic, strong) NSNumber *maxRowCount;
///item 大小
@property (nonatomic, strong) NSValue *itemSize;
///item间距
@property (nonatomic, strong) NSNumber *minimumInteritemSpacing;
///section左侧间距，竖直布局生效
@property (nonatomic, strong) NSNumber *leftSpacing;
///section右侧间距，竖直布局生效
@property (nonatomic, strong) NSNumber *rightSpacing;

@end

@implementation CLLayoutView

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    self = [super init];
    if (self) {
        self.scrollDirection = scrollDirection;
        [self initUI];
        [self mas_makeConstraints];
    }
    return self;
}
- (void)initUI {
    [self addSubview:self.collectionView];
}
- (void)mas_makeConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
}
- (void)setDataSource:(id<CLLayoutViewDataSource>)dataSource {
    _dataSource = dataSource;
}
///注册cell
- (void)registerClass:(Class)cellClass {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}
- (NSInteger)collectionView:(UICollectionView *__unused)collectionView numberOfItemsInSection:(NSInteger __unused)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < (NSInteger)self.dataArray.count) {
        id item = [self.dataArray objectAtIndex:indexPath.row];
        if ([item conformsToProtocol:@protocol(CLLayoutItemProtocol)]) {
            Class cellClass = [item dequeueReusableCellClass];
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
            if ([cell conformsToProtocol:@protocol(CLLayoutCellProtocol)]) {
                [((id)cell) updateItem:item];
            }
            return cell;
        }
        return nil;
    }else{
       return nil;
    }
}
- (void)collectionView:(UICollectionView *__unused)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutView:didSelectItemAtIndexPath:)]) {
        [self.delegate layoutView:self didSelectItemAtIndexPath:indexPath];
    }
}
- (NSNumber *)itemCountPerRow {
    if (_itemCountPerRow) {
        return _itemCountPerRow;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemCountPerRowInLayout:)]) {
        _itemCountPerRow = [NSNumber numberWithInteger:[self.dataSource itemCountPerRowInLayout:self]];
    }else {
        _itemCountPerRow = [NSNumber numberWithInteger:0];
    }
    return _itemCountPerRow;
}
- (NSNumber *)maxRowCount {
    if (_maxRowCount) {
        return _maxRowCount;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(maxRowCountInLayout:)]) {
        _maxRowCount = [NSNumber numberWithInteger:[self.dataSource maxRowCountInLayout:self]];
    }else {
        _maxRowCount = [NSNumber numberWithInteger:0];
    }
    return _maxRowCount;
}
- (NSValue *)itemSize {
    if (_itemSize) {
        return _itemSize;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemSizeInLayout:)]) {
        _itemSize = [NSValue valueWithCGSize:[self.dataSource itemSizeInLayout:self]];
    }else {
        _itemSize = [NSValue valueWithCGSize:CGSizeZero];
    }
    return _itemSize;
}
- (NSArray<id<CLLayoutItemProtocol>> *)dataArray {
    if (_dataArray) {
        return _dataArray;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataArrayInLayout:)]) {
        _dataArray = [self.dataSource dataArrayInLayout:self];
    }else {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (NSNumber *)minimumInteritemSpacing {
    if (_minimumInteritemSpacing) {
        return _minimumInteritemSpacing;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(minimumInteritemSpacingInVerticalLayout:)]) {
        _minimumInteritemSpacing = [NSNumber numberWithFloat:(float)[self.dataSource minimumInteritemSpacingInVerticalLayout:self]];
    }else {
        _minimumInteritemSpacing = [NSNumber numberWithFloat:0.0];
    }
    return _minimumInteritemSpacing;
}
- (NSNumber *)leftSpacing {
    if (_leftSpacing) {
        return _leftSpacing;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionLeftSpacingInVerticalLayout:)]) {
        _leftSpacing = [NSNumber numberWithFloat:(float)[self.dataSource sectionLeftSpacingInVerticalLayout:self]];
    }else {
        _leftSpacing = [NSNumber numberWithFloat:0.0];
    }
    return _leftSpacing;
}
- (NSNumber *)rightSpacing {
    if (_rightSpacing) {
        return _rightSpacing;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionRightSpacingInVerticalLayout:)]) {
        _rightSpacing = [NSNumber numberWithFloat:(float)[self.dataSource sectionRightSpacingInVerticalLayout:self]];
    }else {
        _rightSpacing = [NSNumber numberWithFloat:0.0];
    }
    return _rightSpacing;
}
- (void)reloadData {
    self.itemCountPerRow = nil;
    self.maxRowCount = nil;
    self.itemSize = nil;
    self.dataArray = nil;
    self.minimumInteritemSpacing = nil;
    self.leftSpacing = nil;
    self.rightSpacing = nil;
    
    NSInteger rowCount;
    CGFloat dataArrayCount = (CGFloat)self.dataArray.count;
    CGFloat maxRowCount = self.maxRowCount.floatValue;
    CGFloat itemCountPerRow = self.itemCountPerRow.floatValue;
    CGSize itemSize = self.itemSize.CGSizeValue;
    if (self.dataArray.count == 0) {
        rowCount = 0;
    } else if (dataArrayCount / (maxRowCount * itemCountPerRow) > 1) {
        rowCount = (NSInteger)maxRowCount;
    } else {
        rowCount = (NSInteger)ceil(dataArrayCount / itemCountPerRow);
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        self.horizontalLayout.itemSize = itemSize;
        [self.horizontalLayout invalidateLayout];
    }else {
        self.verticalLayout.itemSize = itemSize;
        self.verticalLayout.sectionInset = UIEdgeInsetsMake(0, self.leftSpacing.floatValue, 0, self.rightSpacing.floatValue);
        self.verticalLayout.minimumInteritemSpacing = self.minimumInteritemSpacing.floatValue;
        [self.verticalLayout invalidateLayout];
    }
    CGFloat collectionViewHeight = rowCount * itemSize.height;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionViewHeight);
    }];
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
    [self.collectionView reloadData];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGPoint offset = self.collectionView.contentOffset;
    CGFloat width = self.collectionView.bounds.size.width;
    NSInteger index = (NSInteger)round(offset.x/width);
    CGPoint newOffset = CGPointMake(index * size.width, offset.y);
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> __unused context) {
        [self reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> __unused context) {
        [self.collectionView setContentOffset:newOffset animated:NO];
    }];
}
- (CLHorizontalLayout *)horizontalLayout {
    if (_horizontalLayout == nil) {
        _horizontalLayout = [[CLHorizontalLayout alloc] init];
        __weak __typeof(self) weakSelf = self;
        _horizontalLayout.itemCountPerRowBlock = ^NSInteger{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return 0;
            }
            return strongSelf.itemCountPerRow.integerValue;
        };
        _horizontalLayout.maxRowCountBlock = ^NSInteger{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return 0;
            }
            return strongSelf.maxRowCount.integerValue;
        };
    }
    return _horizontalLayout;
}
- (CLVerticalLayout *) verticalLayout {
    if (_verticalLayout == nil) {
        _verticalLayout = [[CLVerticalLayout alloc] init];
        __weak __typeof(self) weakSelf = self;
        _verticalLayout.itemCountPerRowBlock = ^NSInteger{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return 0;
            }
            return strongSelf.itemCountPerRow.integerValue;
        };
        _verticalLayout.maxRowCountBlock = ^NSInteger{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return 0;
            }
            return strongSelf.maxRowCount.integerValue;
        };
    }
    return _verticalLayout;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.horizontalLayout];
        }else {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.verticalLayout];
        }
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
