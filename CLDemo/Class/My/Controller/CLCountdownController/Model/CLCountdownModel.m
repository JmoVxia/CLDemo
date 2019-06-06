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

@end


@implementation CLCountdownModel

- (void)setIsPause:(BOOL)isPause {
    if (isPause) {
        self.pauseTime = self.remainingTime;
        self.startTime = 0;
    }else {
        _isPause = isPause;
        self.startTime = self.remainingTime;
    }
    _isPause = isPause;
}
- (NSInteger)remainingTime {
    if (_isPause) {
        return self.pauseTime;
    }else {
        if (self.pauseTime != 0 && self.startTime != 0) {
            return self.countdownTime - self.actionTimes + self.pauseTime - self.startTime - (NSInteger)floor(self.leaveTime);
        }else {
            return self.countdownTime - self.actionTimes - (NSInteger)floor(self.leaveTime);
        }
    }
}

@end
