//
//  CLBroadcastView.m
//  CLDemo
//
//  Created by AUG on 2019/9/4.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBroadcastView.h"
#import <Masonry/Masonry.h>

@interface CLBroadcastCell ()

@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation CLBroadcastCell

-(instancetype)initWithReuseIdentifier: (NSString *)reuseIdentifier {
    if (self = [super init]) {
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}
@end

@interface CLBroadcastView ()

///缓存cell数组
@property (nonatomic, strong) NSMutableArray<CLBroadcastCell *> *cellCaches;
///标识符字典
@property (nonatomic, strong) NSMutableDictionary *cellIdentifierCaches;
///已经移除边界的cell
@property (nonatomic, strong) CLBroadcastCell *removedCell;
///当前显示的cell
@property (nonatomic, strong) CLBroadcastCell *currentCell;
///view总共的数量
@property (nonatomic, assign) NSInteger totalRow;
///当前的下标
@property (nonatomic, assign) NSInteger currentIndex;
///正在进行动画
@property (nonatomic, assign) BOOL isAnimtion;

@end

@implementation CLBroadcastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cellIdentifierCaches = [NSMutableDictionary dictionary];
        self.cellCaches = [NSMutableArray array];
        self.clipsToBounds = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCell)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.cellIdentifierCaches setObject:cellClass forKey:identifier];
}
//MARK:JmoVxia---复用
- (CLBroadcastCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    CLBroadcastCell *cell;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reuseIdentifier = %@", identifier];
    NSArray<CLBroadcastCell *> *array = [self.cellCaches filteredArrayUsingPredicate:predicate];
    cell = [array firstObject];
    if (!cell) {
        Class class = [self.cellIdentifierCaches objectForKey:identifier];
        if (!class) {
            NSAssert(NO, @"The cell must be register");
            return nil;
        }
        cell = [[class alloc] initWithReuseIdentifier:identifier];
        [self addSubview:cell];
    }else {
        [self.cellCaches removeObject:cell];
    }
    return cell;
}
///加载方法
- (void)reloadData {
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(broadcastView:cellForRowAtIndex:)] || ![self.dataSource respondsToSelector:@selector(broadcastViewRows:)]) {
        return;
    }
    if ([self isNeedAddToCache:self.removedCell] && self.removedCell) {
        [self.cellCaches addObject:self.removedCell];
    }
    self.totalRow = [self.dataSource broadcastViewRows:self];
    if (self.totalRow == 0) {
        if (self.currentCell) {
            [self.currentCell removeFromSuperview];
            self.currentCell = nil;
        }
        if (self.removedCell) {
            [self.removedCell removeFromSuperview];
            self.removedCell = nil;
        }
    }
    if (self.totalRow > 0 && !self.currentCell) {
        CLBroadcastCell *cell = [self.dataSource broadcastView:self cellForRowAtIndex:self.currentIndex];
        cell.transform = CGAffineTransformIdentity;
        [cell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        self.currentCell = cell;
    }
}
- (void)scrollToNext {
    if (self.isAnimtion || !self.dataSource || ![self.dataSource respondsToSelector:@selector(broadcastView:cellForRowAtIndex:)] || ![self.dataSource respondsToSelector:@selector(broadcastViewRows:)]) {
        return;
    }
    self.isAnimtion = YES;
    self.currentIndex = (self.currentIndex + 1) % self.totalRow;
    CLBroadcastCell *nextCell = [self.dataSource broadcastView:self cellForRowAtIndex:self.currentIndex];
    [nextCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    nextCell.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.currentCell.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
        nextCell.transform = CGAffineTransformIdentity;
    }completion:^(BOOL __unused finished) {
        self.removedCell = self.currentCell;
        self.currentCell = nextCell;
        if ([self isNeedAddToCache:self.removedCell] && self.removedCell) {
            [self.cellCaches addObject:self.removedCell];
        }
        self.isAnimtion = NO;
    }];
}
- (BOOL)isNeedAddToCache:(CLBroadcastCell *)cell {
    for (CLBroadcastCell *cacheCell in self.cellCaches) {
        if ([cacheCell.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
            return NO;
        }
    }
    return YES;
}
- (void)tapCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(broadcastView:didSelectIndex:)]) {
        [self.delegate broadcastView:self didSelectIndex:self.currentIndex];
    }
}
@end
