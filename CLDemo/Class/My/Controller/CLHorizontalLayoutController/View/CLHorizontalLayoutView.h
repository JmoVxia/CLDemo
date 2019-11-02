//
//  CLHorizontalLayoutView.h
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLHorizontalLayoutItemProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol CLHorizontalLayoutViewDataSource <NSObject>

@required
///item数组
- (NSArray<CLHorizontalLayoutItemProtocol *> *)dataArray;
///注册cell
- (NSArray<Class> *)registerClassArray;
///每行计数
- (NSInteger)itemCountPerRow;
///最大行数
- (NSInteger)maxRowCount;
///item 大小
- (CGSize)itemSize;

@end


@interface CLHorizontalLayoutView : UIView


- (instancetype)initWithDataSource:(id<CLHorizontalLayoutViewDataSource>)dataSource;
///刷新
- (void)reloadData;
///控制器view将要旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

@end

NS_ASSUME_NONNULL_END
