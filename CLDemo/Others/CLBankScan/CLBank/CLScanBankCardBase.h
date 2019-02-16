//
//  CLScanBankCardBase.h
//  CLBankCardRecognition
//
//  Created by iOS1 on 2018/6/18.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CLDesign.h"
#import "CLBankCardSearch.h"
#import "UIImage+Extend.h"
#import "CLBankCardModel.h"
#import "exbankcard.h"
#import "excards.h"

typedef void(^BankScanSuccessBlock)(id model);
typedef void(^ScanErrorBlock)(NSError *error);


typedef enum : NSUInteger {
    BankScanType,
    IDScanType,
} kScanType;


@interface CLScanBankCardBase : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) BOOL                      verify;

@property (nonatomic, assign) kScanType scanType;

@property (nonatomic, copy) BankScanSuccessBlock bankScanSuccess;
@property (nonatomic, copy) ScanErrorBlock scanError;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, copy) NSString *sessionPreset; // 图片质量

@property (nonatomic, assign) BOOL isInProcessing;

@property (nonatomic, assign) BOOL isHasResult;

//出流
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *activeVideoInput;

// 能否切换前置后置
- (BOOL)canSwitchCameras;

- (AVCaptureDevice *)activeCamera;

- (AVCaptureDevice *)inactiveCamera;
// 闪关灯
- (AVCaptureFlashMode)flashMode;
// 有无手电筒
- (BOOL)cameraHasTorch;

- (AVCaptureTorchMode)torchMode;
// 能否调整焦距
- (BOOL)cameraSupportsTapToFocus;


@end
