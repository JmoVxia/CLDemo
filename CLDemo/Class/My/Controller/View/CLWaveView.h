//
//  CLWaveView.h
//  CLDemo
//
//  Created by AUG on 2019/3/6.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CLWaveViewConfigure : NSObject

///波浪颜色
@property (nonatomic, strong) UIColor *color;
///水纹振幅
@property (nonatomic, assign) CGFloat amplitude;
///水纹周期
@property (nonatomic, assign) CGFloat cycle;
///波浪Y
@property (nonatomic, assign) CGFloat y;
///水纹速度
@property (nonatomic, assign) CGFloat speed;
///水纹宽度
@property (nonatomic, assign) CGFloat width;
///水纹速度
@property (nonatomic, assign) CGFloat upSpeed;

@end


@interface CLWaveView : UIView

///更新基本配置，block不会造成循环引用
- (void)updateWithConfigure:(void(^)(CLWaveViewConfigure *configure))configureBlock;

///销毁
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
