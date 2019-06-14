//
//  CLCountdownModel.h
//  CLDemo
//
//  Created by AUG on 2019/6/6.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLCountdownModel : NSObject

///行
@property (nonatomic, assign) NSInteger row;
///倒计时时间
@property (nonatomic, assign) NSInteger countdownTime;
///剩余时间
@property (nonatomic, assign, readonly) NSInteger remainingTime;
///是否暂停
@property (nonatomic, assign) BOOL isPause;
///定时器响应次数
@property (nonatomic, assign) NSInteger actionTimes;
///离开时间
@property (nonatomic, assign) NSInteger leaveTime;

@end

NS_ASSUME_NONNULL_END
