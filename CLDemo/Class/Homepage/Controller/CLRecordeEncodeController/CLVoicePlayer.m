//
//  CLVoicePlayer.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface CLVoicePlayer ()

///playerItem
@property (nonatomic, strong) AVPlayerItem *playerItem;
///player
@property (nonatomic, strong) AVPlayer *player;
///其他设备在播放
@property (nonatomic, assign) BOOL otherAudioPlaying;

@end


@implementation CLVoicePlayer

- (void)playWithItem:(AVPlayerItem *)playerItem {
    if (self.playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
    if (playerItem) {
        self.otherAudioPlaying = [AVAudioSession sharedInstance].otherAudioPlaying;
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.playerItem = playerItem;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [self.player play];
    }
}
///根据url播放
- (void)playWithUrl: (NSURL *)url {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:url]];
    [self playWithItem:playerItem];
}
///停止声音
- (void)stop {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:self.playerItem];
    [self.player pause];
    self.playerItem = nil;
    self.player = nil;
    if (self.otherAudioPlaying) {
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    if (self.endCallback) {
        self.endCallback();
    }
}

@end
