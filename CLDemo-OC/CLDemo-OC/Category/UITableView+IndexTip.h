//
//  UITableView+IndexTip.h
//  CLSearchDemo
//
//  Created by AUG on 2018/10/29.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (IndexTip)
//显示索引字符悬浮提示;在点击或滑动索引时，在UITableView中间显示一个Label显示当前的索引字符

-(void)addIndexTipLabel:(UILabel *)label;

@end

NS_ASSUME_NONNULL_END
