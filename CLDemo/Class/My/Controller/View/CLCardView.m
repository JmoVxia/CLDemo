//
//  CLCardView.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardView.h"

@interface CLCardViewConfigure ()

@end

@implementation CLCardViewConfigure

+ (instancetype)defaultConfig {
    CLCardViewConfigure *configure = [[CLCardViewConfigure alloc] init];
    configure.leftRightMargin = 10;
    configure.bottomMargin = 10;
    configure.showRows = 4;
    return configure;
}

@end



@interface CLCardView ()

///已经划动到边界外的一个view
@property (nonatomic, weak) UITableViewCell *viewRemoved;
///放当前显示的子View的数组
@property (nonatomic, strong) NSMutableArray *caches;
///view总共的数量
@property (nonatomic, assign) NSInteger totalRow;
///当前的下标
@property (nonatomic, assign) NSInteger nowIndex;
///触摸开始的坐标
@property (nonatomic, assign) CGPoint pointStart;
///上一次触摸的坐标
@property (nonatomic, assign) CGPoint pointLast;
///cell数组
@property (nonatomic, strong) NSMutableArray<UITableViewCell *> *cellArray;
///原始frame数组
@property (nonatomic, strong) NSMutableArray<NSValue *> *frameArray;
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

- (CLCardViewConfigure *) configure{
    if (_configure == nil){
        _configure = [CLCardViewConfigure defaultConfig];
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
    self.clipsToBounds = YES;
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
- (void)updateWithConfig:(void(^)(CLCardViewConfigure *configure))configBlock {
    configBlock(self.configure);
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
        UITableViewCell *cell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + i) < self.totalRow ? (self.nowIndex + i) : 0];
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
- (UITableViewCell*)dequeueReusableViewWithIdentifier:(NSString *)identifier {
    UITableViewCell *cell;
    for (UITableViewCell * cacheCell in self.caches) {
        if ([identifier isEqualToString:cacheCell.reuseIdentifier]) {
            [self.caches removeObject:cacheCell];
            cell = cacheCell;
            NSLog(@"我被复用了");
            break;
        }
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [cell addGestureRecognizer:panGestureRecognizer];
    return cell;
}
//MARK:JmoVxia---手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer*)sender {
    if (self.isAnimation) {
        return;
    }
    CGPoint translation = [sender translationInView: self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.pointStart = translation;
        self.pointLast = translation;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat yMove = translation.y - self.pointLast.y;
        self.pointLast = translation;
        [self animationWithGestureEnd:NO move:yMove];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        UITableViewCell *fristCell = [self.cellArray firstObject];
        CGRect fristFrame = [[self.frameArray firstObject] CGRectValue];
        if (!CGRectEqualToRect(fristFrame, fristCell.frame)) {
            [self scrollToNext];
        }
    }
}
//MARK:JmoVxia---动画
- (void)animationWithGestureEnd:(BOOL)end move:(CGFloat)move {
    UITableViewCell *fristCell = [self.cellArray firstObject];
    CGRect fristFrame = [[self.frameArray firstObject] CGRectValue];
    CGPoint center = fristCell.center;
    if (self.pointLast.y < 0) {
        fristCell.center = CGPointMake(center.x, center.y + move);
    }else {
        fristCell.frame = fristFrame;
    }
    CGFloat offset = (CGRectGetMaxY(fristFrame) - CGRectGetMaxY(fristCell.frame));
    CGFloat height = (self.height - self.configure.bottomMargin * (self.configure.showRows - 1)) * 0.5;
    CGFloat alpha = end ? 0 : MIN(1 - MIN((offset / height), 1), 1);
    fristCell.alpha = alpha;
    for (NSInteger i = 1; i < self.cellArray.count; i++) {
        UITableViewCell *cell = [self.cellArray objectAtIndex:i];
        CGRect frame = [[self.frameArray objectAtIndex:i] CGRectValue];
        CGFloat x = frame.origin.x - self.configure.leftRightMargin * (1 - alpha);
        CGFloat y = frame.origin.y - self.configure.bottomMargin * (1 - alpha);
        CGFloat width = frame.size.width + self.configure.leftRightMargin * (1 - alpha) * 2;
        CGFloat height = frame.size.height;
        cell.frame = CGRectMake(x, y, width, height);
        if (i == self.cellArray.count - 1) {
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
    UITableViewCell *fristCell = [self.cellArray firstObject];
    CGFloat move = - fristCell.center.y;
    [UIView animateWithDuration:0.2 animations:^{
        [self animationWithGestureEnd:YES move:move];
    } completion:^(BOOL finished) {
        self.nowIndex++;
        self.nowIndex = self.nowIndex < self.totalRow ? self.nowIndex : 0;
        if (self.viewRemoved && [self isNeedAddToCache:self.viewRemoved]) {
            self.viewRemoved.alpha = 1;
            [self.caches addObject:self.viewRemoved];
            [self.viewRemoved removeFromSuperview];
        }
        self.viewRemoved = fristCell;
        [self.cellArray removeObject:fristCell];
        NSInteger index = ((self.nowIndex + self.configure.showRows - 1) < self.totalRow ? (self.nowIndex + self.configure.showRows - 1) : (self.nowIndex + self.configure.showRows - 1 - self.totalRow));
        UITableViewCell *cell = [self.dataSource cardView:self cellForRowAtIndexIndex:index];
        CGRect lastFrame = [[self.frameArray lastObject] CGRectValue];
        cell.frame = lastFrame;
        cell.alpha = 0;
        [cell removeFromSuperview];
        [self insertSubview:cell atIndex:0];
        [self.cellArray addObject:cell];
        self.isAnimation = NO;
    }];
}
//MARK:JmoVxia---是否需要加入到缓存池
- (BOOL)isNeedAddToCache:(UITableViewCell*)cell {
    for (UITableViewCell * cellIn in self.caches) {
        if ([cellIn.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
            return NO;
        }
    }
    return YES;
}

@end
