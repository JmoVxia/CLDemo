//
//  CLLayoutViewDataSource.h
//  Potato
//
//  Created by AUG on 2019/11/3.
//

#import <Foundation/Foundation.h>
#import "CLLayoutItemProtocol.h"

@class CLLayoutView;

NS_ASSUME_NONNULL_BEGIN

@protocol CLLayoutViewDataSource <NSObject>

///item数组
- (NSArray<id<CLLayoutItemProtocol>> *)dataArrayInLayout:(CLLayoutView *)layoutView;
///每行计数
- (NSInteger)itemCountPerRowInLayout:(CLLayoutView *)layoutView;
///最大行数
- (NSInteger)maxRowCountInLayout:(CLLayoutView *)layoutView;
///item 大小
- (CGSize)itemSizeInLayout:(CLLayoutView *)layoutView;

@optional
///item左右间距，竖直布局生效
- (CGFloat)minimumInteritemSpacingInVerticalLayout:(CLLayoutView *)layoutView;
///section左侧间距，竖直布局生效
- (CGFloat)sectionLeftSpacingInVerticalLayout:(CLLayoutView *)layoutView;
///section右侧间距，竖直布局生效
- (CGFloat)sectionRightSpacingInVerticalLayout:(CLLayoutView *)layoutView;


@end

NS_ASSUME_NONNULL_END
