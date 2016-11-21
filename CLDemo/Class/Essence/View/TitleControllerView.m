//
//  TitleControllerView.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/21.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "TitleControllerView.h"
@interface TitleControllerView ()<UIScrollViewDelegate>

/**标题滑动视图*/
@property (nonatomic, weak) UIScrollView *titlesView;
/**滑动视图*/
@property (nonatomic, weak) UIScrollView *scrollView;
/**标题数组*/
@property (nonatomic, strong) NSArray *titlesArray;
/**父控制器*/
@property (nonatomic,weak) UIViewController *fatherController;
/**标题按钮选中标记*/
@property (nonatomic,weak) UIButton *selectedButton;
/**选中下标控件*/
@property (nonatomic,weak) UIView *selectedView;


@end


@implementation TitleControllerView

- (void)initWithTitleArray:(NSArray *)titleArray fatherController:(UIViewController *)fatherController
{
        _fatherController = fatherController;
        _titlesArray = titleArray;
        [self initUI];
}

- (void)initUI
{
    self.titlesView.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor = [UIColor clearColor];
}
#pragma mark - 标题按钮点击事件
- (void)buttonAction:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectedView.width = button.titleLabel.width;
        self.selectedView.centerX = button.centerX;
    }];
    
    //计算按钮和屏幕中间需要的偏移量
    CGFloat offsetX = button.centerX - ScreenWidth / 2.0;
    //屏幕左边按钮,重置偏移
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    else
    {
        //得到最大偏移量
        CGFloat maxOffsetX = _titlesView.contentSize.width - ScreenWidth;
        // 处理最大偏移量
        if (offsetX > maxOffsetX)
        {
            offsetX = maxOffsetX;
        }
    }
    //设置偏移
    [_titlesView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    // 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = (button.tag - 1234) * _scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 取出子控制器
    UIViewController *vc = _fatherController.childViewControllers[index];
    
    vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self buttonAction:self.titlesView.subviews[index]];
}
#pragma mark - 懒加载
- (UIScrollView *) scrollView
{
    if (_scrollView == nil)
    {
        // 不要自动调整inset
        _fatherController.automaticallyAdjustsScrollViewInsets = NO;
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, self.titlesView.bottom, self.width, self.height - self.titlesView.height);
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * _fatherController.childViewControllers.count, 0);
        _scrollView = scrollView;
        // 添加第一个控制器的view
        [self scrollViewDidEndScrollingAnimation:_scrollView];
    }
    return _scrollView;
}

- (UIScrollView *) titlesView
{
    if (_titlesView == nil)
    {
        UIScrollView *titlesView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        CGFloat width = self.width/5.0;
        titlesView.contentSize = CGSizeMake(width * _titlesArray.count, titlesView.height);
        titlesView.bounces = NO;
        titlesView.showsHorizontalScrollIndicator = NO;
        titlesView.showsVerticalScrollIndicator = NO;
        [self addSubview:titlesView];
        
        _titlesView = titlesView;
        
        [_titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * button = [[UIButton alloc]init];
            button.frame = CGRectMake(idx * width, 0, width, titlesView.height);
            button.tag = 1234 + idx;
            [button setTitle:_titlesArray[idx] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [titlesView addSubview:button];
        }];
        
        UIButton *fristButton = titlesView.subviews.firstObject;
        UIView *view = [[UIView alloc]init];
        view.height = 2;
        view.top = titlesView.height-view.height;
        view.backgroundColor = [fristButton titleColorForState:UIControlStateSelected];
        [titlesView addSubview:view];
        self.selectedView = view;
        //根据文字内容计算宽高
        [fristButton.titleLabel sizeToFit];
        //设置位置
        view.width = fristButton.titleLabel.width;
        view.centerX = fristButton.centerX;
        //默认选中第一个按钮
        [self buttonAction:fristButton];
    }
    return _titlesView;
}






@end
