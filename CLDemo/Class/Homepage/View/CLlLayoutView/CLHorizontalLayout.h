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

///item每行个数
@property (nonatomic, copy) NSInteger (^itemCountPerRowBlock)(void);
///最大行数
@property (nonatomic, copy) NSInteger (^maxRowCountBlock)(void);

@end

NS_ASSUME_NONNULL_END
