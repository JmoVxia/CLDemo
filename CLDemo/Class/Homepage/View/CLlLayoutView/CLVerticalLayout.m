//
//  CLVerticalLayout.m
//  CLDemo
//
//  Created by AUG on 2019/11/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLVerticalLayout.h"

@interface CLVerticalLayout ()

// 存放全部item布局信息的数组
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
// item总数
@property (nonatomic, assign) NSInteger itemCountTotal;
///item每行个数
@property (nonatomic, assign) NSInteger itemCountPerRow;
// 最大行数
@property (nonatomic, assign) NSInteger maxRowCount;
// 页数
@property (nonatomic, assign) NSInteger pageCount;

@end


@implementation CLVerticalLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];
    self.itemCountPerRow = self.itemCountPerRowBlock();
    self.maxRowCount = self.maxRowCountBlock();
    if (self.itemCountPerRow == 0) {
        return;
    }
    self.attributesArray = [NSMutableArray array];
    self.itemCountTotal = [self.collectionView numberOfItemsInSection:0];
    self.pageCount = self.itemCountTotal ? (NSInteger)ceilf(self.itemCountTotal / (float)(self.itemCountPerRow * self.maxRowCount)) : 0;
    for (NSInteger i = 0; i < self.itemCountTotal; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *newAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
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
    return CGSizeMake(0, self.pageCount * CGRectGetHeight(self.collectionView.frame));
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect __unused)rect {
    return self.attributesArray;
}
@end
