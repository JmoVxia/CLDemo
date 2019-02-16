//
//  CLBankCardSearch.h
//  CLBankCardRecognition
//
//  Created by iOS1 on 2018/6/18.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLBankCardSearch : NSObject
/**
 *  查询是哪个银行
 *
 *  @param numbers 获取的numbers
 *  @param nCount  数组个数
 *
 *  @return 所属银行
 */
+ (NSString *)getBankNameByBin:(char *)numbers count:(int)nCount;

@end
