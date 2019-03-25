//
//  CLGCDTimer.h
//  CLDemo
//
//  Created by AUG on 2019/3/25.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLGCDTimer : NSObject

/**
 创建定时器，需要调用开始开启
 @param interval 间隔时间
 @param delaySecs 第一次延迟时间
 @param queue 线程
 @param repeats 是否重复
 @param action 响应
 */
- (instancetype)initWithInterval:(NSTimeInterval)interval
                       delaySecs:(NSTimeInterval)delaySecs
                           queue:(dispatch_queue_t)queue
                         repeats:(BOOL)repeats
                          action:(nullable void(^)(NSInteger actionTimes))action;
/*响应次数*/
@property (nonatomic, assign, readonly) NSInteger actionTimes;

/**开始定时器*/
- (void)startTimer;
/**执行一次定时器响应*/
- (void)responseOnceTimer;
/**取消定时器*/
- (void)cancelTimer;
/**暂停定时器*/
- (void)suspendTimer;
/**恢复定时器*/
- (void)resumeTimer;
/**替换旧的响应*/
- (void)replaceOldAction:(void(^)(NSInteger actionTimes))action;

@end

NS_ASSUME_NONNULL_END
