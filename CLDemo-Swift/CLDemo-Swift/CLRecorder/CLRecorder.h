//
//  CLRecorder.h
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLRecorder : NSObject

@property (nonatomic, copy, readonly) NSString *mp3Path;

@property (nonatomic, assign, readonly) CGFloat audioDuration;

@property (nonatomic, copy) void (^durationCallback)(NSUInteger seconds);

@property (nonatomic, copy) void (^finishCallBack)(CGFloat audioDuration, NSData *fileData);

- (void)startRecorder;

- (void)cancelRecorder;

- (void)stopRecorder;

@end

NS_ASSUME_NONNULL_END
