//
//  CLGCDTimerManager.h
//  CLDemo
//
//  Created by AUG on 2019/3/25.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLGCDTimerOC : NSObject

/**
 创建定时器，需要调用开始开启
 @param interval 间隔时间
 @param delaySecs 第一次延迟时间
 @param queue 线程
 @param repeats 是否重复
 @param action 响应
 */
- (instancetype _Nonnull)initWithInterval:(NSTimeInterval)interval
                                delaySecs:(NSTimeInterval)delaySecs
                                    queue:(dispatch_queue_t _Nullable)queue
                                  repeats:(BOOL)repeats
                                   action:( void(^ _Nullable)(NSInteger actionTimes))action;
/*响应次数*/
@property (nonatomic, assign, readonly) NSInteger actionTimes;

/**开始定时器*/
- (void)start;
/**执行一次定时器响应*/
- (void)responseOnce;
/**取消定时器*/
- (void)cancel;
/**暂停定时器*/
- (void)suspend;
/**恢复定时器*/
- (void)resume;
/**替换旧的响应*/
- (void)replaceOldAction:(void(^ _Nonnull)(NSInteger actionTimes))action;

@end

@interface CLGCDTimerManagerOC : NSObject

/**
 创建全局定时器
 @param name 定时器名称
 @param interval 间隔时间
 @param delaySecs 第一次延迟时间
 @param queue 线程
 @param repeats 是否重复
 @param action 响应
 */
+ (void)scheduledTimerWithName:( NSString * _Nonnull)name
                      interval:(NSTimeInterval)interval
                     delaySecs:(NSTimeInterval)delaySecs
                         queue:(dispatch_queue_t _Nullable)queue
                       repeats:(BOOL)repeats
                        action:(void(^ _Nullable)(NSInteger actionTimes))action;

/**开始定时器*/
+ (void)start:(NSString *_Nonnull)name;
/**执行一次定时器响应*/
+ (void)responseOnce:(NSString *_Nonnull)name;
/**取消定时器*/
+ (void)cancel:(NSString *_Nonnull)name;
/**暂停定时器*/
+ (void)suspend:(NSString *_Nonnull)name;
/**恢复定时器*/
+ (void)resume:(NSString *_Nonnull)name;
/**获取定时器*/
+ (CLGCDTimerOC *_Nullable)timer:(NSString *_Nonnull)name;

@end

NS_ASSUME_NONNULL_END
