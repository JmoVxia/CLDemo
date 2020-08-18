//
//  CLMp3Encoder.m
//  CLDemo
//
//  Created by JmoVxia on 2020/6/24.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

#import "CLMp3Encoder.h"
#import "lame.h"

const int MP3_BUFF_SIZE = 4096;

@interface CLMp3Encoder ()
{
    lame_t lame;
    unsigned char mp3_buffer[MP3_BUFF_SIZE];
    short int *pcmData1;
    short int *pcmData2;
    dispatch_queue_t _encodeQueue;
}

@end

@implementation CLMp3Encoder

- (instancetype)init {
    self = [super init];
    if (self) {
        _encodeQueue = dispatch_queue_create("CLMp3Encoder.encodeQueue", DISPATCH_QUEUE_SERIAL);
        _inputSampleRate = [AVAudioSession sharedInstance].sampleRate;
        _outputSampleRate = [AVAudioSession sharedInstance].sampleRate;
        _outputChannelsPerFrame = 1;
        _bitRate = 16;
        _quality = 5;
    }
    return self;
}
- (void)run {
    if (lame == NULL) {
        lame = lame_init();
        lame_set_in_samplerate(lame,_inputSampleRate);
        lame_set_quality (lame, _quality);
        lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, _bitRate);
        lame_set_out_samplerate(lame, _outputSampleRate);
        lame_set_num_channels(lame, _outputChannelsPerFrame);
        lame_init_params(lame);
    }
    _isRunning = YES;
}
- (void)stop {
    if (lame) {
        lame_close(lame);
        lame = NULL;
    }
    _isRunning = NO;
}
- (void)processAudioBufferList: (AudioBufferList)audioBufferList {
    if(!_isRunning){
        return;
    }
    dispatch_async(_encodeQueue, ^{
        int channels = audioBufferList.mBuffers[0].mNumberChannels;
        short int *pcmData = audioBufferList.mBuffers[0].mData;
        int size = audioBufferList.mBuffers[0].mDataByteSize / (sizeof(short int) * channels);
        int bytesWritten = 0;
        NSData *data = nil;
        if (channels == 2) {
            bytesWritten = lame_encode_buffer_interleaved(self->lame, pcmData, size, self->mp3_buffer, MP3_BUFF_SIZE);
        }else if (channels == 1) {
            if (self->pcmData1 == NULL) {
                self->pcmData1 = pcmData;
            }
            if (self->pcmData2 == NULL) {
                self->pcmData2 = pcmData;
            }
            if (self->pcmData1 && self->pcmData2) {
                bytesWritten = lame_encode_buffer(self->lame, self->pcmData1, self->pcmData2,size, self->mp3_buffer, MP3_BUFF_SIZE);
                self->pcmData1 = NULL;
                self->pcmData2 = NULL;
            }
        }
        if (bytesWritten && self.processingEncodedData) {
            data = [[NSData alloc] initWithBytes:self->mp3_buffer length:bytesWritten];
            self.processingEncodedData(data);
        }
    });
}
- (void)dealloc {
    [self stop];
}
@end
