//
//  CLBankCardDetailController.h
//  CLDemo
//
//  Created by JmoVxia on 2019/2/17.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLBaseViewController.h"
#import "CLBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLBankCardDetailController : CLBaseViewController
// 银行卡信息
@property (nonatomic,strong) CLBankCardModel *bankCardModel;

@end

NS_ASSUME_NONNULL_END
