//
//  CLBankCardModel.h
//  CLBankCardRecognition
//
//  Created by iOS1 on 2018/6/18.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLBankCardModel : NSObject
@property (nonatomic, copy) NSString *bankNumber;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, strong) UIImage *bankImage;
@end
