//
//  CLPhotoBrowserPresentationController.m
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import "CLPhotoBrowserPresentationController.h"
#import <Masonry/Masonry.h>

@interface CLPhotoBrowserPresentationController()
///遮罩
@property (nonatomic, strong) UIView *maskView;

@end

@implementation CLPhotoBrowserPresentationController

//即将出现调用
- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];

    [self.containerView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.containerView addSubview:self.presentedView];
    [self.presentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 与过渡效果一起执行背景 View 的淡入效果
    [[self.presentingViewController transitionCoordinator] animateAlongsideTransitionInView:self.maskView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull __unused context) {
        self.maskView.alpha = 1.0;
    } completion:nil];
}
//出现调用
- (void)presentationTransitionDidEnd:(BOOL)completed{
    [super presentationTransitionDidEnd:completed];
    // 如果呈现没有完成，那就移除背景 View
    if (!completed){
        [self.maskView removeFromSuperview];
    }
}
//即将销毁调用
- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    // 与过渡效果一起执行背景 View 的淡入效果
    [[self.presentingViewController transitionCoordinator] animateAlongsideTransitionInView:self.maskView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull __unused context) {
        self.maskView.alpha = 0.0;
    } completion:nil];
}
//销毁调用
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    if (completed) {
        //一旦要自定义动画，必须自己手动移除控制器
        [self.presentedView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }
}
- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha {
    _maskViewAlpha = maskViewAlpha;
    self.maskView.alpha = _maskViewAlpha;
}
- (CGFloat)maskAlpha {
    return self.maskView.alpha;
}
- (UIView *) maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
    }
    return _maskView;
}

@end
