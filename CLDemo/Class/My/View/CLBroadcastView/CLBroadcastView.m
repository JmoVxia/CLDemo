//
//  CLBroadcastView.m
//  CLDemo
//
//  Created by AUG on 2019/9/4.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBroadcastView.h"
#import <Masonry/Masonry.h>
#import "CLGCDTimerManager.h"

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
///定时器
@property (nonatomic, strong) CLGCDTimer *timer;
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
        self.rotationTime = 2;
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
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(broadcastView:cellForRowAtIndexIndex:)] || ![self.dataSource respondsToSelector:@selector(broadcastViewRows:)]) {
        return;
    }
    if ([self isNeedAddToCache:self.removedCell] && self.removedCell) {
        [self.cellCaches addObject:self.removedCell];
    }
    self.totalRow = [self.dataSource broadcastViewRows:self];
    if (self.totalRow > 1) {
        __weak __typeof(self) weakSelf = self;
        self.timer = [[CLGCDTimer alloc] initWithInterval:self.rotationTime delaySecs:self.rotationTime queue:dispatch_get_main_queue() repeats:YES action:^(NSInteger __unused actionTimes) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf scrollToNext];
        }];
        [self.timer start];
    }else {
        self.timer = nil;
    }
    if (self.totalRow > 0) {
        if (!self.currentCell) {
            CLBroadcastCell *cell = [self.dataSource broadcastView:self cellForRowAtIndexIndex:self.currentIndex];
            [cell mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(self);
                make.width.mas_equalTo(self.mas_width);
                make.height.mas_equalTo(self.mas_height);
            }];
            self.currentCell = cell;
        }
    }
}
- (void)scrollToNext {
    if (self.isAnimtion) {
        return;
    }
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(broadcastView:cellForRowAtIndexIndex:)] || ![self.dataSource respondsToSelector:@selector(broadcastViewRows:)]) {
        return;
    }
    self.isAnimtion = YES;
    ((self.currentIndex + 1) < self.totalRow) ? (self.currentIndex ++) : (self.currentIndex = 0);
    CLBroadcastCell *nextCell = [self.dataSource broadcastView:self cellForRowAtIndexIndex:self.currentIndex];
    [nextCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.currentCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
            make.bottom.mas_equalTo(self.mas_top);
        }];
        [nextCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
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
    for (CLBroadcastCell *cellIn in self.cellCaches) {
        if ([cellIn.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
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
- (void)setRotationTime:(NSTimeInterval)rotationTime {
    _rotationTime = MAX(rotationTime, 0);
}
@end
