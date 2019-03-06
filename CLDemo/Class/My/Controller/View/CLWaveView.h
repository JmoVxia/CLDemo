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
@property (nonatomic, strong) UIColor *waveColor;
///水纹振幅
@property (nonatomic, assign) CGFloat waveA;
///水纹周期
@property (nonatomic, assign) CGFloat waveW;
///波浪Y
@property (nonatomic, assign) CGFloat waveY;
///水纹速度
@property (nonatomic, assign) CGFloat waveSpeed;
///水纹宽度
@property (nonatomic, assign) CGFloat waveWidth;

@end


@interface CLWaveView : UIView



///更新基本配置，block不会造成循环引用
- (void)updateWithConfig:(void(^)(CLWaveViewConfigure *configure))configBlock;

///销毁
- (void)invalidate;


@end

NS_ASSUME_NONNULL_END
