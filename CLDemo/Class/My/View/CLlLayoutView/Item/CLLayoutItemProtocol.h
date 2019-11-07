//
//  CLLayoutItemProtocol.h
//  Potato
//
//  Created by AUG on 2019/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CLLayoutItemProtocol <NSObject>
///复用cell类型
- (Class)dequeueReusableCellClass;

@end

NS_ASSUME_NONNULL_END
