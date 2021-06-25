//
//  CLRecordeEncodeController.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLRecordeEncodeController.h"
#import "CLRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "CLVoicePlayer.h"
#import "Masonry.h"

@interface CLRecordeEncodeController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CLRecorder *recorder;
@property (nonatomic, strong) CLVoicePlayer *player;


@end

@implementation CLRecordeEncodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(self) weakSelf = self;
    self.recorder.durationCallback = ^(NSUInteger seconds) {
      __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.timeLabel.text = [strongSelf getMMSSFromSS: seconds];
    };
    [self.view addSubview: self.startButton];
    [self.view addSubview: self.playButton];
    [self.view addSubview: self.timeLabel];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.mas_equalTo(200);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.right.mas_equalTo(-90);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.playButton.mas_bottom).offset(30);
    }];
}
- (void)startAction {
    if (!self.startButton.selected) {
        NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
        [self.recorder startRecorder];
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"%f",end - start);
        NSLog(@"%@",self.recorder.mp3Path);
    }else {
        [self.recorder stopRecorder];
    }
    self.startButton.selected = !self.startButton.selected;
}
- (void)playAction {
    if (self.recorder.mp3Path.length > 0) {
        if (!self.playButton.isSelected) {
            [self.player playWithUrl:[NSURL fileURLWithPath:self.recorder.mp3Path]];
        }else {
            [self.player stop];
        }
        self.playButton.selected = !self.playButton.selected;
    }
}
- (NSString *)getMMSSFromSS:(NSUInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}
- (void)showWaveform {

}
- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [[UIButton alloc] init];
        [_startButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton setTitle:@"结束" forState:UIControlStateSelected];
        [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"停止" forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont monospacedDigitSystemFontOfSize:18 weight:0];
    }
    return _timeLabel;
}
- (CLRecorder *)recorder {
    if (!_recorder) {
        _recorder = [[CLRecorder alloc] init];
        __weak typeof(self) weakSelf = self;
        _recorder.finishCallBack = ^(CGFloat audioDuration, NSData * _Nonnull fileData) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showWaveform];
        };
    }
    return _recorder;
}
- (CLVoicePlayer *)player {
    if (!_player) {
        _player = [[CLVoicePlayer alloc] init];
        __weak __typeof(self) weakSelf = self;
        _player.endCallback = ^{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            strongSelf.playButton.selected = NO;
        };
    }
    return _player;
}
@end
