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
//当前view距离父view的顶部的值
const int TOP_MARGTIN = 15;

@interface CLCardView ()

//已经划动到边界外的一个view
@property (nonatomic, weak) UITableViewCell * viewRemove;
//放当前显示的子View的数组
@property (nonatomic, strong) NSMutableArray * cacheViews;
//view总共的数量
@property (nonatomic, assign) NSInteger totalNum;
//当前的下标
@property (nonatomic, assign) NSInteger nowIndex;
//触摸开始的坐标
@property (nonatomic, assign) CGPoint pointStart;
//上一次触摸的坐标
@property (nonatomic, assign) CGPoint pointLast;
//最后一次触摸的坐标
@property (nonatomic, assign) CGPoint pointEnd;
//正在显示的cell
@property (nonatomic, weak) UITableViewCell * nowCell;
//下一个cell
@property (nonatomic, weak) UITableViewCell * nextCell;
//第三个cell
@property (nonatomic, weak) UITableViewCell * thirdCell;
///第一个cell原始center
@property (nonatomic, assign) CGPoint originalCenter;
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
    self.cacheViews = [[NSMutableArray alloc]init];
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
    self.totalNum = [self.dataSource cardViewRows:self];
    self.viewRemove = nil;
    
    UITableViewCell * nowCell = [self.dataSource cardView:self cellForRowAtIndexIndex:self.nowIndex];
    
    UITableViewCell * nextCell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + 1 < self.totalNum ? self.nowIndex + 1 : 0)];
    
    UITableViewCell * thirdCell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + 2 < self.totalNum ? self.nowIndex + 2 : 0)];
    
    [thirdCell removeFromSuperview];
    thirdCell.layer.anchorPoint = CGPointMake(1, 1);
    thirdCell.frame = CGRectMake(LEFT_RIGHT_MARGIN * 2, (self.height * 0.5), self.width - 2 * 2 * LEFT_RIGHT_MARGIN, (self.height * 0.5));
    [self addSubview:thirdCell];
    self.thirdCell = thirdCell;
    
    [nextCell removeFromSuperview];
    nextCell.layer.anchorPoint = CGPointMake(1, 1);
    nextCell.frame = CGRectMake(LEFT_RIGHT_MARGIN, (self.height * 0.5) - TOP_MARGTIN / 2 * 1, self.width - 2 * LEFT_RIGHT_MARGIN, (self.height * 0.5));
    [self addSubview:nextCell];
    self.nextCell = nextCell;
    
    
    [nowCell removeFromSuperview];
    nowCell.layer.anchorPoint = CGPointMake(1, 1);
    nowCell.frame = CGRectMake(0, (self.height * 0.5) - TOP_MARGTIN, self.width, (self.height * 0.5));
    [self addSubview:nowCell];
    self.nowCell = nowCell;
    self.originalCenter = self.nowCell.center;
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
        CGPoint center = self.nowCell.center;
        if (translation.y < 0) {
            self.nowCell.center = CGPointMake(center.x, center.y + yMove);
        }else {
            self.nowCell.center = self.originalCenter;
        }
        CGFloat offset = (self.originalCenter.y - center.y - ((self.height * 0.5)) * 0.5);
        CGFloat alpha = 1 - MIN((offset / ((self.height * 0.5))) * 1, 1);
        self.nowCell.alpha = alpha;
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
    for (UITableViewCell * cell in self.cacheViews) {
        if ([identifier isEqualToString:cell.reuseIdentifier]) {
            [self.cacheViews removeObject:cell];
            NSLog(@"我被复用了");
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
}

//滑动到下一个界面
-(void)swipeEnd {
    CGPoint center = self.nowCell.center;
    [UIView animateWithDuration:0.2 animations:^{
        self.nowCell.center = CGPointMake(center.x, center.y - self.height);
    } completion:^(BOOL finished) {
        self.nowIndex++;
        self.nowIndex = self.nowIndex < self.totalNum ? self.nowIndex : 0;
        if (self.viewRemove && [self isNeedAddToCache:self.viewRemove]) {
            [self.cacheViews addObject:self.viewRemove];
            [self.viewRemove removeFromSuperview];
        }
        self.viewRemove = self.nowCell;
        self.viewRemove.alpha = 1;
        
        self.nowCell = self.nextCell;
        self.nextCell = self.thirdCell;
        
        UITableViewCell * thirdCell = [self.dataSource cardView:self cellForRowAtIndexIndex:(self.nowIndex + 2 < self.totalNum ? (int)self.nowIndex + 2 : (int)self.nowIndex + 2 - (int)self.totalNum)];
        [thirdCell removeFromSuperview];
        thirdCell.layer.anchorPoint = CGPointMake(1, 1);
        thirdCell.frame = CGRectMake(LEFT_RIGHT_MARGIN * 2, (self.height * 0.5), self.width - 2 * 2 * LEFT_RIGHT_MARGIN, (self.height * 0.5));
        self.thirdCell = thirdCell;

        [self insertSubview:thirdCell belowSubview:self.nextCell];
        [UIView animateWithDuration:0.1 animations:^{
            self.nowCell.frame = CGRectMake(0, (self.height * 0.5) - TOP_MARGTIN, self.width, (self.height * 0.5));
            self.nextCell.frame = CGRectMake(LEFT_RIGHT_MARGIN, (self.height * 0.5) - TOP_MARGTIN / 2 * 1, self.width - 2 * LEFT_RIGHT_MARGIN, (self.height * 0.5));
        }];
    }];
}

//滑动到上一个界面
-(void)swipeGoBack {
    
}

//是否需要加入到缓存中去
-(BOOL)isNeedAddToCache:(UITableViewCell*)cell {
    for (UITableViewCell * cellIn in self.cacheViews) {
        if ([cellIn.reuseIdentifier isEqualToString:cell.reuseIdentifier]) {
            return NO;
        }
    }
    return YES;
}

@end
