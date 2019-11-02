//
//  CLHorizontalLayout.h
//  CLDemo
//
//  Created by AUG on 2019/11/2.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLHorizontalLayout : UICollectionViewFlowLayout

- (instancetype)initWithItemCountPerRow:(NSInteger)itemCountPerRow maxRowCount:(NSInteger)maxRowCount;

@end

NS_ASSUME_NONNULL_END
