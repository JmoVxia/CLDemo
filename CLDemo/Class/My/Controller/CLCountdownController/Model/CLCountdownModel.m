//
//  CLCountdownModel.m
//  CLDemo
//
//  Created by AUG on 2019/6/6.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCountdownModel.h"

@interface CLCountdownModel ()

///暂停时间
@property (nonatomic, assign) NSInteger pauseTime;
///开始时间
@property (nonatomic, assign) NSInteger startTime;
///剩余时间
@property (nonatomic, assign) NSInteger remainingTime;

@end


@implementation CLCountdownModel

- (void)setIsPause:(BOOL)isPause {
    if (isPause) {
        //暂停
        self.pauseTime = self.remainingTime;
        self.startTime = 0;
    }else {
        //恢复
        _isPause = isPause;
        self.startTime = self.remainingTime;
    }
    _isPause = isPause;
}
//MARK:JmoVxia---剩余时间
- (NSInteger)remainingTime {
    if (_isPause) {
        //已经暂停，直接返回暂停时间
        return self.pauseTime;
    }else {
        if (self.pauseTime != 0 && self.startTime != 0) {
            //恢复计时需要减去已经暂停时间
            return self.countdownTime - self.actionTimes + self.pauseTime - self.startTime - self.leaveTime;
        }else {
            return self.countdownTime - self.actionTimes - self.leaveTime;
        }
    }
}

@end
