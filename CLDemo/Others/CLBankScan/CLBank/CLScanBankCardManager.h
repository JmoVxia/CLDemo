//
//  CLScanBankCardManager.h
//  CLBankCardRecognition
//
//  Created by iOS1 on 2018/6/18.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLScanBankCardBase.h"
@interface CLScanBankCardManager : CLScanBankCardBase

- (void)configIDScan;

- (BOOL)configOutPutAtQue:(dispatch_queue_t)queue;

- (BOOL)configInPutAtQue:(dispatch_queue_t)queue;

- (void)configConnection;





- (void)startSession;

- (void)stopSession;

- (void)resetConfig;

- (void)resetParams;


- (void)parseBankImageBuffer:(CVImageBufferRef)imageBuffer;

//选择前置和后置
- (BOOL)switchCameras;
// 闪关灯
- (void)setFlashMode:(AVCaptureFlashMode)flashMode;
// 手电筒
- (void)setTorchMode:(AVCaptureTorchMode)torchMode;
// 焦距
- (void)focusAtPoint:(CGPoint)point;
// 曝光量
- (void)exposeAtPoint:(CGPoint)point;
//重置曝光
- (void)resetFocusAndExposureModes;




- (BOOL)configBankScanManager;

- (BOOL)configIDScanManager;

@end
