//
//  CLCardView.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardView.h"
#import "CLGCDTimerManagerOC.h"
#import "UIView+CLSetRect.h"

@interface CLCardViewCell ()

@property (nonatomic, copy) NSString *reuseIdentifier;

///label
@property (nonatomic, strong) UILabel *label;

@end


@implementation CLCardViewCell

-(instancetype)initWithReuseIdentifier: (NSString *)reuseIdentifier {
    if (self = [super init]) {
        self.reuseIdentifier = reuseIdentifier;
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
    }
    return self;
}
- (void)setText:(NSString *)text {
    self.label.text = text;
    [self.label sizeToFit];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.center = CGPointMake(self.cl_width * 0.5, self.cl_height * 0.5);
}
@end

@implementation CLCardViewConfigure

+ (instancetype)defaultConfigure {
    CLCardViewConfigure *configure = [[CLCardViewConfigure alloc] init];
    configure.leftRightMargin = 10;
    configure.bottomMargin = 10;
    configure.showRows = 4;
    configure.loopScroll = YES;
    return configure;
}

@end

@interface CLCardView ()

///已经划动到边界外的一个view
@property (nonatomic, weak) CLCardViewCell *viewRemoved;
///放当前显示的子View的数组
@property (nonatomic, strong) NSMutableArray *caches;
///view总共的数量
@property (nonatomic, assign) NSInteger totalRow;
///当前的下标
@property (nonatomic, assign) NSInteger nowIndex;
///cell数组
@property (nonatomic, strong) NSMutableArray<CLCardViewCell *> *cellArray;
///原始frame数组
@property (nonatomic, strong) NSMutableArray<NSValue *> *frameArray;
///定时器
@property (nonatomic, strong) CLGCDTimerOC *timer;
///自身的宽度
@property (nonatomic, assign) CGFloat width;
///自身的高度
@property (nonatomic, assign) CGFloat height;
///是否是第一次执行
@property (nonatomic, assign) BOOL isFirstLayoutSub;
///配置
@property (nonatomic, strong) CLCardViewConfigure *configure;
///是否正在动画
@property (nonatomic, assign) BOOL isAnimation;


@end

@implementation CLCardView

- (CLCardViewConfigure *) configure {
    if (_configure == nil){
        _configure = [CLCardViewConfigure defaultConfigure];
    }
    return _configure;
}
//MARK:JmoVxia---初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.caches = [NSMutableArray array];
    self.cellArray = [NSMutableArray array];
    self.frameArray = [NSMutableArray array];
}
//MARK:JmoVxia---layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    if(!self.isFirstLayoutSub) {
        self.isFirstLayoutSub = YES;
        self.width = self.bounds.size.width;
        self.height = self.bounds.size.height;
        [self reloadData];
    }
}
//MARK:JmoVxia---更新配置
- (void)updateWithConfig:(void(^)(CLCardViewConfigure *configure))configBlock {
    configBlock(self.configure);
    configBlock = nil;
    self.configure.showRows = self.configure.showRows + 1;
    [self reloadData];
}
//MARK:JmoVxia---刷新
- (void)reloadData {
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(cardView:cellForRowAtIndexIndex:)] || ![self.dataSource respondsToSelector:@selector(cardViewRows:)]) {
        return;
    }
    self.totalRow = [self.dataSource cardViewRows:self];
    self.viewRemoved = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.cellArray removeAllObjects];
    [self.frameArray removeAllObjects];
    self.configure.showRows = MIN(self.configure.showRows, self.totalRow + 1);
    for (NSInteger i = 0; i < self.configure.showRows; i++) {
        CLCardViewCell *cell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + i) < self.totalRow ? (self.nowIndex + i) : 0];
        [cell removeFromSuperview];
        cell.layer.anchorPoint = CGPointMake(1, 1);
        CGFloat x = self.configure.leftRightMargin * i;
        CGFloat y = (self.height * 0.5) + self.configure.bottomMargin * (i - 0.5 * (self.configure.showRows - 1));
        CGFloat width = self.width - 2 * i * self.configure.leftRightMargin;
        CGFloat height = (self.height - self.configure.bottomMargin * (self.configure.showRows - 1)) * 0.5;
        cell.frame = CGRectMake(x, y, width, height);
        if (i == self.configure.showRows - 1) {
            cell.alpha = 0;
        }
        [self insertSubview:cell atIndex:0];
        [self.cellArray addObject:cell];
        [self.frameArray addObject:[NSValue valueWithCGRect:cell.frame]];
    }
}
//MARK:JmoVxia---复用
- (CLCardViewCell *)dequeueReusableViewWithIdentifier:(NSString *)identifier {
    CLCardViewCell *cell;
    for (CLCardViewCell * cacheCell in self.caches) {
        if ([identifier isEqualToString:cacheCell.reuseIdentifier]) {
            [self.caches removeObject:cacheCell];
            cell = cacheCell;
            break;
        }
    }
    if (!cell) {
        cell = [[CLCardViewCell alloc] initWithReuseIdentifier:identifier];
    }
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [cell addGestureRecognizer:panGestureRecognizer];
    return cell;
}
//MARK:JmoVxia---手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender {
    if (self.isAnimation) {
        return;
    }
    CGPoint translation = [sender translationInView: self];
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat yMove = translation.y;
        [self animationWithMove:yMove];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        CLCardViewCell *fristCell = [self.cellArray firstObject];
        CGRect fristFrame = [[self.frameArray firstObject] CGRectValue];
        if (!CGRectEqualToRect(fristFrame, fristCell.frame)) {
            [self scrollToNext];
        }
    }
}
//MARK:JmoVxia---动画
- (void)animationWithMove:(CGFloat)move {
    CLCardViewCell *fristCell = [self.cellArray firstObject];
    CGRect fristFrame = [[self.frameArray firstObject] CGRectValue];
    CGFloat height = (self.height - self.configure.bottomMargin * (self.configure.showRows - 1)) * 0.5;
    move = MIN(MAX(move, - height), 0);
    fristCell.frame = CGRectMake(CGRectGetMinX(fristFrame), (CGRectGetMinY(fristFrame) + move), CGRectGetWidth(fristFrame), CGRectGetHeight(fristFrame));
    CGFloat offset = (CGRectGetMaxY(fristFrame) - CGRectGetMaxY(fristCell.frame));
    CGFloat alpha = MIN(1 - MIN((offset / height), 1), 1);
    fristCell.alpha = alpha;
    for (NSInteger i = 1; i < self.cellArray.count; i++) {
        CLCardViewCell *cell = [self.cellArray objectAtIndex:i];
        CGRect frame = [[self.frameArray objectAtIndex:i] CGRectValue];
        CGFloat x = frame.origin.x - self.configure.leftRightMargin * (1 - alpha);
        CGFloat y = frame.origin.y - self.configure.bottomMargin * (1 - alpha);
        CGFloat width = frame.size.width + self.configure.leftRightMargin * (1 - alpha) * 2;
        CGFloat height = frame.size.height;
        cell.frame = CGRectMake(x, y, width, height);
        if (i == self.cellArray.count - 1 && self.cellArray.count > (self.totalRow - self.configure.showRows)) {
            cell.alpha = 1 - alpha;
        }
    }
}
//MARK:JmoVxia---滑动到下一个界面
- (void)scrollToNext {
    if (self.isAnimation) {
        return;
    }
    self.isAnimation = YES;
    CLCardViewCell *fristCell = [self.cellArray firstObject];
    CGFloat height = (self.height - self.configure.bottomMargin * (self.configure.showRows - 1)) * 0.5;
    __block CGFloat move = height - CGRectGetMinY(fristCell.frame);
    if ((move - height) < 0) {
        __weak __typeof(self) weakSelf = self;
        [self.timer replaceOldAction:^(NSInteger actionTimes) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            CGFloat offset = (CGFloat)(move + 1) < height ? (CGFloat)(move + 0.5) : height;
            move = offset;
            [strongSelf animationWithMove: -move];
            if (offset == height) {
                [strongSelf.timer cancel];
                strongSelf.timer = nil;
                [strongSelf endScrollAnimation];
            }
        }];
        [self.timer start];
    }else {
        [self endScrollAnimation];
    }
}
//MARK:JmoVxia---滑动结束
- (void)endScrollAnimation {
    CLCardViewCell *fristCell = [self.cellArray firstObject];
    self.nowIndex++;
    self.nowIndex = self.nowIndex < self.totalRow ? self.nowIndex : (self.configure.loopScroll ? 0 : self.totalRow);
    if (self.viewRemoved && [self isNeedAddToCache:self.viewRemoved]) {
        self.viewRemoved.alpha = 1;
        [self.caches addObject:self.viewRemoved];
        [self.viewRemoved removeFromSuperview];
    }
    self.viewRemoved = fristCell;
    [self.cellArray removeObject:fristCell];
    if (self.nowIndex <= self.totalRow - self.configure.showRows || self.configure.loopScroll) {
        NSInteger index = ((self.nowIndex + self.configure.showRows - 1) < self.totalRow ? (self.nowIndex + self.configure.showRows - 1) : (self.nowIndex + self.configure.showRows - 1 - self.totalRow));
        CLCardViewCell *cell = [self.dataSource cardView:self cellForRowAtIndexIndex:index];
        CGRect lastFrame = [[self.frameArray lastObject] CGRectValue];
        cell.frame = lastFrame;
        cell.alpha = 0;
        [cell removeFromSuperview];
        [self insertSubview:cell atIndex:0];
        [self.cellArray addObject:cell];
    }
    self.isAnimation = NO;
}
//MARK:JmoVxia---定时器
- (CLGCDTimerOC *) timer {
    if (_timer == nil) {
        _timer = [[CLGCDTimerOC alloc] initWithInterval:0.002 delaySecs:0 queue:dispatch_get_main_queue() repeats:YES action:nil];
    }
    return _timer;
}
//MARK:JmoVxia---是否需要加入到缓存池
- (BOOL)isNeedAddToCache:(CLCardViewCell *)cell {
    for (CLCardViewCell *cellIn in self.caches) {
        if ([cellIn.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
            return NO;
        }
    }
    return YES;
}
-(void)dealloc {
    NSLog(@"卡片视图销毁了");
}
@end
