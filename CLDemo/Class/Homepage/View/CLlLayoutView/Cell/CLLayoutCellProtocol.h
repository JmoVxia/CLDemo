//
//  CLLayoutCellProtocol.h
//  Potato
//
//  Created by AUG on 2019/11/4.
//

#import <Foundation/Foundation.h>
#import "CLLayoutItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CLLayoutCellProtocol <NSObject>

- (void)updateItem:(id<CLLayoutItemProtocol>)item;

@end

NS_ASSUME_NONNULL_END
