//
//  CLBroadcastView.h
//  CLDemo
//
//  Created by AUG on 2019/9/4.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLBroadcastView;

NS_ASSUME_NONNULL_BEGIN


@interface CLBroadcastCell : UIView

///复用标识符
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

///根据复用标识符创建
- (instancetype)initWithReuseIdentifier: (NSString *)reuseIdentifier;

@end


@protocol CLBroadcastViewDataSource <NSObject>

@required
///广播个数
- (NSInteger)broadcastViewRows:(CLBroadcastView *)broadcast;
///创建cell
- (CLBroadcastCell *)broadcastView:(CLBroadcastView *)broadcast cellForRowAtIndex:(NSInteger)index;

@end


@protocol CLBroadcastViewDelegate <NSObject>

@optional
///点击cell
- (void)broadcastView:(CLBroadcastView *)broadcast didSelectIndex:(NSInteger)index;

@end

@interface CLBroadcastView : UIView

///数据源
@property (nonatomic, weak) id<CLBroadcastViewDataSource> dataSource;
///代理
@property (nonatomic, weak) id<CLBroadcastViewDelegate> delegate;

///注册cell
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

///滑动到下一个
- (void)scrollToNext;

///加载方法
- (void)reloadData;

///根据id获取缓存的cell
- (CLBroadcastCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
