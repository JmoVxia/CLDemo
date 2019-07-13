//
//  CLPhotoBrowserCollectionViewCell.h
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import <UIKit/UIKit.h>

@class SDAnimatedImageView;

NS_ASSUME_NONNULL_BEGIN

@interface CLPhotoBrowserCollectionViewCell : UICollectionViewCell

///单击响应
@property (nonatomic, copy) void (^singleTap)(CGRect imageViewFrame);
///透明度改变
@property (nonatomic, copy) void (^alphaChange)(CGFloat alpha);
///imageView
@property (nonatomic, strong, readonly) SDAnimatedImageView *imageView;

- (void)setImageUrl:(NSURL *)imageUrl placeholderImage:(UIImage *)placeholderImage;

- (void)setImage:(UIImage *)image;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
