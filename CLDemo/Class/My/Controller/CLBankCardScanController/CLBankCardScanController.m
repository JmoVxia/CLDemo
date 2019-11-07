//
//  CLBankCardScanController.m
//  CLDemo
//
//  Created by JmoVxia on 2019/2/17.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBankCardScanController.h"
#import "CLScanBankCardManager.h"
#import "CLBankCardView.h"
#import "CLBankCardDetailController.h"

@interface CLBankCardScanController ()

@property (nonatomic, strong) CLBankCardView *bankCardView;

@property (nonatomic, strong) CLScanBankCardManager *cameraManager;

@end

@implementation CLBankCardScanController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraManager resetParams];
}

- (CLScanBankCardManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[CLScanBankCardManager alloc] init];
    }
    return _cameraManager;
}

- (CLBankCardView *)bankCardView {
    if(!_bankCardView) {
        CGRect rect = [CLBankCardView getOverlayFrame:[UIScreen mainScreen].bounds];
        _bankCardView = [[CLBankCardView alloc] initWithFrame:rect];
    }
    return _bankCardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"银行卡扫描";
    [self.view insertSubview:self.bankCardView atIndex:0];
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:view atIndex:0];
    
    self.cameraManager.sessionPreset = AVCaptureSessionPreset1280x720;
    if ([self.cameraManager configBankScanManager]) {
        // 开启异步子线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraManager.captureSession];
            preLayer.frame = [UIScreen mainScreen].bounds;
            preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.cameraManager startSession];
            // 主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [view.layer addSublayer:preLayer];
            });
        });
    }
    else {
        CLLog(@"打开相机失败");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    __weak __typeof(self) weakSelf = self;
    self.cameraManager.bankScanSuccess = ^(id model) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        [strongSelf showResult:model];
    };
    
    self.cameraManager.scanError = ^(NSError *error) {
        CLLog(@"%@",error);
    };
    
}

- (void)showResult:(id)result {
    CLBankCardModel *model = (CLBankCardModel *)result;
    CLBankCardDetailController *bcdvc = [[CLBankCardDetailController alloc]init];
    bcdvc.bankCardModel = model;
    [self.navigationController pushViewController:bcdvc animated:YES];
}
-(void)dealloc {
    CLLog(@"扫描界面销毁了");
}

@end
