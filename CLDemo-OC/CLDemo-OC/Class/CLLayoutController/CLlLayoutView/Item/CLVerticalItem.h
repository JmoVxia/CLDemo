//
//  CLVerticalItem.h
//  CLDemo
//
//  Created by AUG on 2019/11/21.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLayoutItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLVerticalItem : NSObject<CLLayoutItemProtocol>

@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
