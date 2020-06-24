//
//  CLMp3Encoder.h
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLMp3Encoder : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign) double inputSampleRate;
@property (nonatomic, assign) double outputSampleRate;
@property (nonatomic, assign) int  outputChannelsPerFrame;
@property (nonatomic, assign) int  bitRate;
@property (nonatomic, assign) int  quality;
@property (nonatomic, copy) void(^processingEncodedData)(NSData *mp3Data);

- (void)run;
 
- (void)stop;
 
- (void)processAudioBufferList:(AudioBufferList)audioBufferList;

@end

NS_ASSUME_NONNULL_END
