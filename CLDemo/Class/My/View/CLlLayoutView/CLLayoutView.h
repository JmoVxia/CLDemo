//
//  CLLayoutView.h
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLLayoutViewDelegate.h"
#import "CLLayoutViewDataSource.h"


NS_ASSUME_NONNULL_BEGIN

@interface CLLayoutView : UIView

///数据源
@property (nonatomic, weak) id<CLLayoutViewDataSource> dataSource;
///代理
@property (nonatomic, weak) id<CLLayoutViewDelegate> delegate;

///初始化方法
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection;

///刷新
- (void)reloadData;
///注册cell
- (void)registerClass:(Class)cellClass;

///控制器view将要旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

@end

NS_ASSUME_NONNULL_END
