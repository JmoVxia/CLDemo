//
//  CLHorizontalLayoutItemProtocol.h
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CLHorizontalLayoutItemProtocol <NSObject>

@required
///复用cell类型
- (Class)dequeueReusableCellClass;

@end

NS_ASSUME_NONNULL_END
