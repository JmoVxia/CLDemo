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

///label
@property (nonatomic, strong) UILabel *label;

@end

@implementation CLBroadcastCell

-(instancetype)initWithReuseIdentifier: (NSString *)reuseIdentifier {
    if (self = [super init]) {
        self.reuseIdentifier = reuseIdentifier;
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    return self;
}
- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}
@end

@interface CLBroadcastView ()

///缓存数组
@property (nonatomic, strong) NSMutableArray<CLBroadcastCell *> *cellCaches;
///已经移除边界的cell
@property (nonatomic, weak) CLBroadcastCell *removedCell;
///已经移除边界的cell
@property (nonatomic, weak) CLBroadcastCell *currentCell;
///view总共的数量
@property (nonatomic, assign) NSInteger totalRow;
///当前的下标
@property (nonatomic, assign) NSInteger currentIndex;
///定时器
@property (nonatomic, strong) CLGCDTimer *timer;

@end

@implementation CLBroadcastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cellCaches = [NSMutableArray array];
        self.clipsToBounds = YES;
    }
    return self;
}
//MARK:JmoVxia---复用
- (CLBroadcastCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    CLBroadcastCell *cell;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reuseIdentifier = %@", identifier];
    NSArray<CLBroadcastCell *> *array = [self.cellCaches filteredArrayUsingPredicate:predicate];
    cell = [array firstObject];
    if (!cell) {
        cell = [[CLBroadcastCell alloc] initWithReuseIdentifier:identifier];
        [self addSubview:cell];
        [cell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
    }else {
        [self.cellCaches removeObject:cell];
    }
    return cell;
}
///加载方法
- (void)reloadData {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    __weak __typeof(self) weakSelf = self;
    self.timer = [[CLGCDTimer alloc] initWithInterval:2 delaySecs:2 queue:dispatch_get_main_queue() repeats:YES action:^(NSInteger actionTimes) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        [strongSelf scrollToNext];
    }];
    [self.timer start];
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(broadcastView:cellForRowAtIndexIndex:)] || ![self.dataSource respondsToSelector:@selector(broadcastViewRows:)]) {
        return;
    }
    self.totalRow = [self.dataSource broadcastViewRows:self];
    if (self.totalRow > 0) {
        self.removedCell = nil;
        self.currentIndex = 0;
        CLBroadcastCell *cell = [self.dataSource broadcastView:self cellForRowAtIndexIndex:self.currentIndex];
        self.currentCell = cell;
    }
}
- (void)scrollToNext {
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(broadcastView:cellForRowAtIndexIndex:)] || ![self.dataSource respondsToSelector:@selector(broadcastViewRows:)]) {
        return;
    }
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
    }completion:^(BOOL finished) {
        self.removedCell = self.currentCell;
        self.currentCell = nextCell;
        if ([self isNeedAddToCache:self.removedCell]) {
            [self.cellCaches addObject:self.removedCell];
        }
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
@end
