//
//  CLHorizontalLayoutCellProtocol.h
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLHorizontalLayoutItemProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol CLHorizontalLayoutCellProtocol <NSObject>

- (void)updateItem:(CLHorizontalLayoutItemProtocol *)item;

@end

NS_ASSUME_NONNULL_END
