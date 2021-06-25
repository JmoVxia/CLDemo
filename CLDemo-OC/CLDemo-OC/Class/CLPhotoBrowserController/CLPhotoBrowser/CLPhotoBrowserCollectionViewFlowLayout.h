//
//  CLPhotoBrowserCollectionViewFlowLayout.h
//  Potato
//
//  Created by AUG on 2019/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPhotoBrowserCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger page;

///page变化
@property (nonatomic, copy) void (^pageChange)(NSInteger page);

@end

NS_ASSUME_NONNULL_END
