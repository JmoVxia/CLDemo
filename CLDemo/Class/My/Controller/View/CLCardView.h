//
//  CLCardView.h
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLCardView;

NS_ASSUME_NONNULL_BEGIN


@interface CLCardViewCell : UIView

///复用标识符
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

///文字
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithReuseIdentifier: (NSString *)reuseIdentifier;

@end



@protocol CLCardViewDataSource <NSObject>

@required

- (NSInteger)cardViewRows:(CLCardView *)cardView;

- (CLCardViewCell *)cardView:(CLCardView *)cardView cellForRowAtIndexIndex:(NSInteger)index;

@end

@interface CLCardViewConfigure : NSObject

///左右间隙
@property (nonatomic, assign) CGFloat leftRightMargin;
///底部间隙
@property (nonatomic, assign) CGFloat bottomMargin;
///显示几层
@property (nonatomic, assign) NSInteger showRows;
///循环滚动
@property (nonatomic, assign) BOOL loopScroll;

@end


@interface CLCardView : UIView

///数据源
@property (nonatomic, weak) id<CLCardViewDataSource> dataSource;

///加载方法
- (void)reloadData;

///根据id获取缓存的cell
- (CLCardViewCell *)dequeueReusableViewWithIdentifier:(NSString *)identifier;

///更新基本配置，block不会造成循环引用
- (void)updateWithConfig:(void(^)(CLCardViewConfigure *configure))configBlock;


@end

NS_ASSUME_NONNULL_END
