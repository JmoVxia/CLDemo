//
//  BankDataModel.h
//  CLSearchDemo
//
//  Created by AUG on 2018/10/28.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankDataModel : NSObject

/**id*/
@property (nonatomic, strong) NSNumber *bankId;
/**BankCode*/
@property (nonatomic, copy) NSString *bankCode;
/**CreatedAt*/
@property (nonatomic, copy) NSString *createdAt;
/**Name*/
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
