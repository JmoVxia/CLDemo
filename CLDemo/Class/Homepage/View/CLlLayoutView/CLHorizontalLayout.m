//
//  CLHorizontalLayout.m
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLHorizontalLayout.h"

@interface CLHorizontalLayout ()

// 存放全部item布局信息的数组
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
// 行数
@property (nonatomic, assign) NSInteger rowCount;
// item总数
@property (nonatomic, assign) NSInteger itemCountTotal;
// 页数
@property (nonatomic, assign) NSInteger pageCount;

///item每行个数
@property (nonatomic, assign) NSInteger itemCountPerRow;
// 最大行数
@property (nonatomic, assign) NSInteger maxRowCount;

@end

@implementation CLHorizontalLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];
    self.itemCountPerRow = self.itemCountPerRowBlock();
    self.maxRowCount = self.maxRowCountBlock();
    if (self.itemCountPerRow == 0 || self.maxRowCount == 0) {
        return;
    }
    
    self.attributesArray = [NSMutableArray array];
    self.itemCountTotal = [self.collectionView numberOfItemsInSection:0];
    if (self.itemCountTotal == 0) {
        self.rowCount = 0;
    } else if ((ceilf(self.itemCountTotal / (float)self.itemCountPerRow)) > self.maxRowCount) {
        self.rowCount = self.maxRowCount;
    } else {
        self.rowCount = (NSInteger)ceilf(self.itemCountTotal / (float)self.itemCountPerRow);
    }
    self.pageCount = self.itemCountTotal ? (NSInteger)ceilf(self.itemCountTotal / (float)(self.itemCountPerRow * self.maxRowCount)) : 0;
    for (NSInteger i = 0; i < self.itemCountTotal; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;
    NSInteger page = item / (self.itemCountPerRow * self.maxRowCount);
    NSUInteger x = item % self.itemCountPerRow + page * self.itemCountPerRow;
    NSUInteger y = item / self.itemCountPerRow - page * self.rowCount;
    NSInteger newItem = x * self.rowCount + y;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newItem inSection:indexPath.section];
    UICollectionViewLayoutAttributes *newAttributes = [[super layoutAttributesForItemAtIndexPath:newIndexPath] copy];
    newAttributes.indexPath = indexPath;
    CGFloat width = [self fixSizeBydisplayWidth:self.itemSize.width * self.itemCountPerRow itemCountPerRow:self.itemCountPerRow space:0];
    newAttributes.size = CGSizeMake(width, newAttributes.size.height);
    return newAttributes;
}
- (CGFloat)fixSizeBydisplayWidth:(CGFloat)displayWidth itemCountPerRow:(NSInteger)itemCountPerRow space:(CGFloat)space {
    CGFloat pxWidth = displayWidth * (CGFloat)[UIScreen mainScreen].scale;
    pxWidth = pxWidth - space * (CGFloat)(itemCountPerRow - 1);
    int mo = (int)pxWidth % itemCountPerRow;
    CGFloat width;
    if (mo != 0) {
        CGFloat fixPxWidth = pxWidth - mo;
        CGFloat itemWidth = fixPxWidth / (CGFloat)itemCountPerRow + 1;
        width = itemWidth / (CGFloat)[UIScreen mainScreen].scale;
    }else {
        CGFloat itemWidth = pxWidth / (CGFloat)itemCountPerRow;
        width = itemWidth / (CGFloat)[UIScreen mainScreen].scale;
    }
    return width;
}
- (CGSize)collectionViewContentSize {
    if (!self.itemCountTotal) return CGSizeMake(0, 0);
    return CGSizeMake(self.pageCount * CGRectGetWidth(self.collectionView.frame), 0);
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect __unused)rect {
    return self.attributesArray;
}
@end
