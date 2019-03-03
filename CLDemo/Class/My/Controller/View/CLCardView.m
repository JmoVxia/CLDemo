//
//  CLCardView.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardView.h"

#define degreeTOradians(x) (M_PI * (x) / 180)

//childView距离父View左右的距离
const int LEFT_RIGHT_MARGIN = 10;
//第一个和最后一个View的底部距离
const int BOTTOM_MARGTIN = 8;

@interface CLCardView ()

//已经划动到边界外的一个view
@property (nonatomic, weak) UITableViewCell * viewRemove;
//放当前显示的子View的数组
@property (nonatomic, strong) NSMutableArray * caches;
//view总共的数量
@property (nonatomic, assign) NSInteger totalRow;
//当前的下标
@property (nonatomic, assign) NSInteger nowIndex;
//触摸开始的坐标
@property (nonatomic, assign) CGPoint pointStart;
//上一次触摸的坐标
@property (nonatomic, assign) CGPoint pointLast;
//正在显示的cell
@property (nonatomic, weak) UITableViewCell * fristCell;
//下一个cell
@property (nonatomic, weak) UITableViewCell * secondCell;
//第三个cell
@property (nonatomic, weak) UITableViewCell * thirdCell;
///第一个cell原始位置
@property (nonatomic, assign) CGRect fristFrame;
///第二个cell原始位置
@property (nonatomic, assign) CGRect secondFrame;
//自身的宽度
@property (nonatomic, assign) CGFloat width;
//自身的高度
@property (nonatomic, assign) CGFloat height;
//是否是第一次执行
@property (nonatomic, assign) BOOL isFirstLayoutSub;

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
    self.caches = [[NSMutableArray alloc]init];
    //手势识别
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
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
    
    UITableViewCell * fristCell = [self.dataSource cardView:self cellForRowAtIndexIndex:self.nowIndex];
    
    UITableViewCell * secondCell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + 1 < self.totalRow ? self.nowIndex + 1 : 0)];
    
    UITableViewCell * thirdCell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + 2 < self.totalRow ? self.nowIndex + 2 : 0)];
    
    [thirdCell removeFromSuperview];
    thirdCell.layer.anchorPoint = CGPointMake(1, 1);
    thirdCell.frame = CGRectMake(LEFT_RIGHT_MARGIN * 2, (self.height * 0.5) + BOTTOM_MARGTIN * 0.5, self.width - 2 * 2 * LEFT_RIGHT_MARGIN, ((self.height - BOTTOM_MARGTIN ) * 0.5));
    [self addSubview:thirdCell];
    self.thirdCell = thirdCell;
    
    [secondCell removeFromSuperview];
    secondCell.layer.anchorPoint = CGPointMake(1, 1);
    secondCell.frame = CGRectMake(LEFT_RIGHT_MARGIN, (self.height * 0.5) - BOTTOM_MARGTIN * 0.5, self.width - 2 * LEFT_RIGHT_MARGIN, ((self.height - BOTTOM_MARGTIN ) * 0.5));
    [self addSubview:secondCell];
    self.secondCell = secondCell;
    self.secondFrame = secondCell.frame;
    
    [fristCell removeFromSuperview];
    fristCell.layer.anchorPoint = CGPointMake(1, 1);
    fristCell.frame = CGRectMake(0, (self.height * 0.5) - BOTTOM_MARGTIN * 1.5, self.width, ((self.height - BOTTOM_MARGTIN ) * 0.5));
    [self addSubview:fristCell];
    self.fristCell = fristCell;
    self.fristFrame = fristCell.frame;
}

-(void)pan:(UIPanGestureRecognizer*)sender {
    CGPoint translation = [sender translationInView: self];
    //CGPoint speed=[sender velocityInView:self];//获取速度
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.pointStart = translation;
        self.pointLast = translation;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat yMove = translation.y - self.pointLast.y;
        self.pointLast = translation;
        CGPoint center = self.fristCell.center;
        if (translation.y < 0) {
            self.fristCell.center = CGPointMake(center.x, center.y + yMove);
        }else {
            self.fristCell.frame = self.fristFrame;
        }
        CGFloat offset = (self.fristFrame.origin.y + self.fristFrame.size.height - center.y);
        CGFloat height = (self.height - BOTTOM_MARGTIN ) * 0.5;
        CGFloat alpha = MIN(1 - MIN((offset / (height - BOTTOM_MARGTIN)), 1), 1);
        self.fristCell.alpha = alpha;
        
        CGFloat second_x = self.secondFrame.origin.x * alpha;
        CGFloat second_y = self.secondFrame.origin.y - BOTTOM_MARGTIN * (1 - alpha);
        CGFloat second_width = self.secondFrame.size.width + LEFT_RIGHT_MARGIN * (1 - alpha) * 2;
        CGFloat second_height = self.secondFrame.size.height;
        self.secondCell.frame = CGRectMake(second_x, second_y, second_width, second_height);
        
        
        NSLog(@"==== %f  ====  %f  ==  %f  ==",second_y,second_width,second_height);
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
    CGPoint center = self.fristCell.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.fristCell.center = CGPointMake(center.x, center.y - self.height);
        self.fristCell.alpha = 0;
    } completion:^(BOOL finished) {
        self.nowIndex++;
        self.nowIndex = self.nowIndex < self.totalRow ? self.nowIndex : 0;
        if (self.viewRemove && [self isNeedAddToCache:self.viewRemove]) {
            [self.caches addObject:self.viewRemove];
            [self.viewRemove removeFromSuperview];
        }
        self.viewRemove = self.fristCell;
        self.viewRemove.alpha = 1;
        
        self.fristCell = self.secondCell;
        self.secondCell = self.thirdCell;
        
        UITableViewCell * thirdCell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + 2 < self.totalRow ? (int)self.nowIndex + 2 : (int)self.nowIndex + 2 - (int)self.totalRow)];
        [thirdCell removeFromSuperview];
        thirdCell.layer.anchorPoint = CGPointMake(1, 1);
        thirdCell.frame = CGRectMake(LEFT_RIGHT_MARGIN * 2, (self.height * 0.5) + BOTTOM_MARGTIN * 0.5, self.width - 2 * 2 * LEFT_RIGHT_MARGIN, ((self.height - BOTTOM_MARGTIN ) * 0.5));
        self.thirdCell = thirdCell;

        [self insertSubview:thirdCell belowSubview:self.secondCell];
        [UIView animateWithDuration:0.1 animations:^{
            self.fristCell.frame = CGRectMake(0, (self.height * 0.5) - BOTTOM_MARGTIN * 1.5, self.width, ((self.height - BOTTOM_MARGTIN ) * 0.5));
            self.secondCell.frame = CGRectMake(LEFT_RIGHT_MARGIN, (self.height * 0.5) - BOTTOM_MARGTIN * 0.5, self.width - 2 * LEFT_RIGHT_MARGIN, ((self.height - BOTTOM_MARGTIN ) * 0.5));
        }];
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
