//
//  CLPhotoCollectionViewCell.h
//  CLDemo
//
//  Created by AUG on 2019/7/13.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPhotoCollectionViewCell : UICollectionViewCell

///imageView
@property (nonatomic, strong) SDAnimatedImageView *imageView;


///url
@property (nonatomic, strong) NSURL *url;

///image
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
