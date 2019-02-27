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

@protocol CLCardViewDataSource <NSObject>

@required


-(NSInteger)cardViewRows:(CLCardView *)cardView;

-(UITableViewCell *)cardView:(CLCardView *)cardView cellForRowAtIndexIndex:(NSInteger)index;


@end

@interface CLCardView : UIView

///数据源
@property (nonatomic, weak) id<CLCardViewDataSource> dataSource;

///层叠透明方式显示 默认NO
@property (nonatomic, assign) BOOL isStackCard;

///加载方法
-(void)reloadData;

///根据id获取缓存的cell
-(UITableViewCell*)dequeueReusableViewWithIdentifier:(NSString*)identifier;

@end

NS_ASSUME_NONNULL_END
