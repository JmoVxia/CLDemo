//
//  CLHorizontalItem.h
//  Potato
//
//  Created by AUG on 2019/11/4.
//

#import <Foundation/Foundation.h>
#import "CLLayoutItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLHorizontalItem : NSObject<CLLayoutItemProtocol>

@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
