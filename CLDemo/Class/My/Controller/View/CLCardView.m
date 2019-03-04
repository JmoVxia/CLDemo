//
//  CLCardView.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardView.h"


///childView距离父View左右的距离
const int LEFT_RIGHT_MARGIN = 10;
///第一个和最后一个View的底部距离
const int BOTTOM_MARGTIN = 8;
///显示几行
const int SHOW_ROWS = 4;

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

@end

@implementation CLCardView

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
    for (NSInteger i = 0; i < SHOW_ROWS; i++) {
        UITableViewCell *cell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + i) < self.totalRow ? (self.nowIndex + i) : 0];
        [cell removeFromSuperview];
        cell.layer.anchorPoint = CGPointMake(1, 1);
        CGFloat x = LEFT_RIGHT_MARGIN * i;
        CGFloat y = (self.height * 0.5) + BOTTOM_MARGTIN * (i - 0.5 * (SHOW_ROWS - 1));
        CGFloat width = self.width - 2 * i * LEFT_RIGHT_MARGIN;
        CGFloat height = (self.height - BOTTOM_MARGTIN * (SHOW_ROWS - 1)) * 0.5;
        cell.frame = CGRectMake(x, y, width, height);
        if (i == SHOW_ROWS - 1) {
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
    CGFloat offset = (fristFrame.origin.y + fristFrame.size.height - center.y);
    CGFloat height = (self.height - BOTTOM_MARGTIN * (SHOW_ROWS - 1)) * 0.5;
    CGFloat alpha = end ? 0 : MIN(1 - MIN((offset / height), 1), 1);
    fristCell.alpha = alpha;
    for (NSInteger i = 1; i < self.cellArray.count; i++) {
        UITableViewCell *cell = [self.cellArray objectAtIndex:i];
        CGRect frame = [[self.frameArray objectAtIndex:i] CGRectValue];
        CGFloat x = frame.origin.x - LEFT_RIGHT_MARGIN * (1 - alpha);
        CGFloat y = frame.origin.y - BOTTOM_MARGTIN * (1 - alpha);
        CGFloat width = frame.size.width + LEFT_RIGHT_MARGIN * (1 - alpha) * 2;
        CGFloat height = frame.size.height;
        cell.frame = CGRectMake(x, y, width, height);
        if (i == self.cellArray.count - 1) {
            cell.alpha = 1 - alpha;
        }
    }
}
//MARK:JmoVxia---滑动到下一个界面
- (void)scrollToNext {
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
        NSInteger index = ((self.nowIndex + SHOW_ROWS - 1) < self.totalRow ? (self.nowIndex + SHOW_ROWS - 1) : (self.nowIndex + SHOW_ROWS - 1 - self.totalRow));
        UITableViewCell *cell = [self.dataSource cardView:self cellForRowAtIndexIndex:index];
        CGRect lastFrame = [[self.frameArray lastObject] CGRectValue];
        cell.frame = lastFrame;
        cell.alpha = 0;
        [cell removeFromSuperview];
        [self insertSubview:cell atIndex:0];
        [self.cellArray addObject:cell];
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
