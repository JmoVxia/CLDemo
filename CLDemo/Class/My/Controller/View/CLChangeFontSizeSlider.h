//
//  CLChangeFontSizeSlider.h
//  CLDemo
//
//  Created by AUG on 2018/11/12.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLChangeFontSizeSlider : UIView

/**Value变化回掉*/
@property (nonatomic, copy) void (^valueChangeBlock)(NSInteger Value);
/**结束*/
@property (nonatomic, copy) void (^endChangeBlock)(NSInteger Value);

@end

NS_ASSUME_NONNULL_END
