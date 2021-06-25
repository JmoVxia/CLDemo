//
//  CLPhotoCollectionViewCell.m
//  CLDemo
//
//  Created by AUG on 2019/7/13.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPhotoCollectionViewCell.h"
#import "Masonry.h"

@interface CLPhotoCollectionViewCell ()


@end


@implementation CLPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}
- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = nil;
    self.imageView.image = _image;
    [self.imageView.sd_imageIndicator stopAnimatingIndicator];
}
- (SDAnimatedImageView *) imageView {
    if (_imageView == nil) {
        _imageView = [[SDAnimatedImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.sd_imageIndicator = [SDWebImageActivityIndicator whiteIndicator];
    }
    return _imageView;
}

@end
