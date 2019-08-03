//
//  CLPhotoBrowserAnimatedTransitioning.m
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import "CLPhotoBrowserAnimatedTransitioning.h"
#import "CLPhotoBrowser.h"
#import <SDWebImage/SDWebImage.h>
#import "CLPhotoBrowserImageScaleHelper.h"

@interface CLPhotoBrowserAnimatedTransitioning ()

@property (nonatomic, assign) CLAnimatedTransitionType animatedType;

@property (nonatomic, assign) NSTimeInterval animatedDuration;

@end

@implementation CLPhotoBrowserAnimatedTransitioning

-(instancetype)initWithAnimatedType:(CLAnimatedTransitionType)type animatedDuration:(NSTimeInterval)duration {
    if (self = [super init]) {
        self.animatedType = type;
        self.animatedDuration = duration;
    }
    return self;
}
//MARK: - JmoVxia---UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning> __unused)transitionContext {
    return self.animatedDuration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVc = (CLPhotoBrowser *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    if (self.animatedType == present) {
        CLPhotoBrowser *photoBrowser = (CLPhotoBrowser *)toVc;
        photoBrowser.view.hidden = YES;
        CGRect fromFrame = photoBrowser.smallImageFrame;
        SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] initWithFrame:fromFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UIImage *image = photoBrowser.currentImage;
        if (image) {
            imageView.image = nil;
            imageView.image = image;
        }else {
            imageView.sd_imageIndicator = [SDWebImageActivityIndicator whiteIndicator];
            [imageView sd_setImageWithURL:photoBrowser.currentImageUrl placeholderImage:photoBrowser.currentPlaceholderImage];
        }
        [containerView addSubview:imageView];
        CGRect toFrame = [CLPhotoBrowserImageScaleHelper calculateScaleFrameWithImageSize:imageView.image.size maxSize:[UIScreen mainScreen].bounds.size offset:NO];
        [UIView animateWithDuration:self.animatedDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.frame = toFrame;
        } completion:^(BOOL finished) {
            photoBrowser.view.hidden = NO;
            [imageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }else {
        CLPhotoBrowser *photoBrowser = (CLPhotoBrowser *)fromVc;
        photoBrowser.view.hidden = YES;
        CGRect fromFrame = photoBrowser.bigImageFrame;
        SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] initWithFrame:fromFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UIImage *image = photoBrowser.currentImage;
        if (image) {
            imageView.image = nil;
            imageView.image = image;
        }else {
            imageView.sd_imageIndicator = [SDWebImageActivityIndicator whiteIndicator];
            [imageView sd_setImageWithURL:photoBrowser.currentImageUrl placeholderImage:photoBrowser.currentPlaceholderImage];
        }
        [containerView addSubview:imageView];
        CGRect toFrame = photoBrowser.smallImageFrame;
        [UIView animateWithDuration:self.animatedDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.frame = toFrame;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
