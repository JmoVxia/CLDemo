//
//  BankModel.h
//  CLSearchDemo
//
//  Created by AUG on 2018/10/28.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankModel : NSObject

@property (nonatomic, strong) NSArray<BankDataModel *> * data;

@end

NS_ASSUME_NONNULL_END
