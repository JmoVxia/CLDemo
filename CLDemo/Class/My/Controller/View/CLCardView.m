//
//  CLCardView.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardView.h"

#define degreeTOradians(x) (M_PI * (x) / 180)

///childView距离父View左右的距离
const int LEFT_RIGHT_MARGIN = 10;
///第一个和最后一个View的底部距离
const int BOTTOM_MARGTIN = 8;
///显示几行
const int SHOW_ROWS = 6;

@interface CLCardView ()

///已经划动到边界外的一个view
@property (nonatomic, weak) UITableViewCell * viewRemove;
///放当前显示的子View的数组
@property (nonatomic, strong) NSMutableArray * caches;
///view总共的数量
@property (nonatomic, assign) NSInteger totalRow;
///当前的下标
@property (nonatomic, assign) NSInteger nowIndex;
///触摸开始的坐标
@property (nonatomic, assign) CGPoint pointStart;
///上一次触摸的坐标
@property (nonatomic, assign) CGPoint pointLast;
///第一个cell
//@property (nonatomic, weak) UITableViewCell * fristCell;
///第二个cell
@property (nonatomic, weak) UITableViewCell * secondCell;
///第三个cell
@property (nonatomic, weak) UITableViewCell * thirdCell;
///第一个cell原始位置
//@property (nonatomic, assign) CGRect fristFrame;
///第二个cell原始位置
@property (nonatomic, assign) CGRect secondFrame;
///第三个cell原始位置
@property (nonatomic, assign) CGRect thirdFrame;
///自身的宽度
@property (nonatomic, assign) CGFloat width;
///自身的高度
@property (nonatomic, assign) CGFloat height;
///是否是第一次执行
@property (nonatomic, assign) BOOL isFirstLayoutSub;



///cell数组
@property (nonatomic, strong) NSMutableArray<UITableViewCell *> *cellArray;
///原始frame数组
@property (nonatomic, strong) NSMutableArray<NSValue *> *frameArray;


@end


@implementation CLCardView

//直接用方法初始化
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

//进行一些自身的初始化和设置
-(void)initUI {
    self.clipsToBounds = YES;
    self.caches = [NSMutableArray array];
    self.cellArray = [NSMutableArray array];
    self.frameArray = [NSMutableArray array];
    //手势识别
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    self.backgroundColor = [UIColor lightGrayColor];
}

//布局subview的方法
-(void)layoutSubviews {
    [super layoutSubviews];
    if(!self.isFirstLayoutSub) {
        self.isFirstLayoutSub = YES;
        self.width = self.bounds.size.width;
        self.height = self.bounds.size.height;
        [self reloadData];
    }
}

//重新加载数据方法，会再首次执行layoutSubviews的时候调用
-(void)reloadData {
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(cardView:cellForRowAtIndexIndex:)] || ![self.dataSource respondsToSelector:@selector(cardViewRows:)]) {
        return;
    }
    self.totalRow = [self.dataSource cardViewRows:self];
    self.viewRemove = nil;
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

-(void)pan:(UIPanGestureRecognizer*)sender {
    CGPoint translation = [sender translationInView: self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.pointStart = translation;
        self.pointLast = translation;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat yMove = translation.y - self.pointLast.y;
        self.pointLast = translation;
        UITableViewCell *fristCell = [self.cellArray firstObject];
        CGRect fristFrame = [[self.frameArray firstObject] CGRectValue];
        CGPoint center = fristCell.center;
        if (translation.y < 0) {
            fristCell.center = CGPointMake(center.x, center.y + yMove);
        }else {
            fristCell.frame = fristFrame;
        }
        CGFloat offset = (fristFrame.origin.y + fristFrame.size.height - center.y);
        CGFloat height = (self.height - BOTTOM_MARGTIN * (SHOW_ROWS - 1)) * 0.5;
        CGFloat alpha = MIN(1 - MIN((offset / height), 1), 1);
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
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat yTotalMove = translation.y - self.pointStart.y;
        if (yTotalMove < 0) {
            [self swipeEnd];
        }else{
            [self swipeGoBack];
        }
    }
}

-(UITableViewCell*)dequeueReusableViewWithIdentifier:(NSString *)identifier {
    for (UITableViewCell * cell in self.caches) {
        if ([identifier isEqualToString:cell.reuseIdentifier]) {
            [self.caches removeObject:cell];
            NSLog(@"我被复用了");
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
}

//滑动到下一个界面
-(void)swipeEnd {
    UITableViewCell *fristCell = [self.cellArray firstObject];
    CGPoint center = fristCell.center;
    [UIView animateWithDuration:0.3 animations:^{
        fristCell.center = CGPointMake(center.x, center.y - self.height);
        fristCell.alpha = 0;
    } completion:^(BOOL finished) {
//        self.nowIndex++;
//        self.nowIndex = self.nowIndex < self.totalRow ? self.nowIndex : 0;
//        if (self.viewRemove && [self isNeedAddToCache:self.viewRemove]) {
//            [self.caches addObject:self.viewRemove];
//            [self.viewRemove removeFromSuperview];
//        }
//        self.viewRemove = fristCell;
//        self.viewRemove.alpha = 1;
//
////        fristCell = self.secondCell;
////        self.secondCell = self.thirdCell;
//
//        NSInteger index = ((self.nowIndex + SHOW_ROWS - 1) < self.totalRow ? (self.nowIndex + SHOW_ROWS - 1) : (self.nowIndex + SHOW_ROWS - 1 - self.totalRow));
//        NSLog(@"===   %ld   ===",index);
//        UITableViewCell * thirdCell = [self.dataSource cardView:self cellForRowAtIndexIndex:index];
//        [thirdCell removeFromSuperview];
//        thirdCell.layer.anchorPoint = CGPointMake(1, 1);
//        thirdCell.frame = CGRectMake(LEFT_RIGHT_MARGIN * 2, (self.height * 0.5) + BOTTOM_MARGTIN * 0.5, self.width - 2 * 2 * LEFT_RIGHT_MARGIN, ((self.height - BOTTOM_MARGTIN ) * 0.5));
//        self.thirdCell = thirdCell;
//
//        [self insertSubview:thirdCell belowSubview:self.secondCell];
//        [UIView animateWithDuration:0.1 animations:^{
//            fristCell.frame = CGRectMake(0, (self.height * 0.5) - BOTTOM_MARGTIN * 1.5, self.width, ((self.height - BOTTOM_MARGTIN ) * 0.5));
//            self.secondCell.frame = CGRectMake(LEFT_RIGHT_MARGIN, (self.height * 0.5) - BOTTOM_MARGTIN * 0.5, self.width - 2 * LEFT_RIGHT_MARGIN, ((self.height - BOTTOM_MARGTIN ) * 0.5));
//        }];
    }];
}

//滑动到上一个界面
-(void)swipeGoBack {
    
}

//是否需要加入到缓存中去
-(BOOL)isNeedAddToCache:(UITableViewCell*)cell {
    for (UITableViewCell * cellIn in self.caches) {
        if ([cellIn.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
            return NO;
        }
    }
    return YES;
}

@end
