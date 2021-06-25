//
//  CLPhotoBrowserCollectionViewCell.m
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import "CLPhotoBrowserCollectionViewCell.h"
#import "CLPhotoBrowserImageScaleHelper.h"
#import <SDWebImage/SDWebImage.h>

@interface CLPhotoBrowserCollectionViewCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

///滑动视图
@property (nonatomic, strong) UIScrollView *scrollView;
///imageView
@property (nonatomic, strong) SDAnimatedImageView *imageView;

///记录pan手势开始时imageView的位置
@property (nonatomic, assign) CGRect beganFrame;
///记录pan手势开始时，手势位置
@property (nonatomic, assign) CGPoint beganTouch;

@end

@implementation CLPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addGestureRecognizer];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}
- (void)addGestureRecognizer {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [self.scrollView addGestureRecognizer:singleTapGesture];

    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    panGesture.delegate = self;
    [self.scrollView addGestureRecognizer:panGesture];
}
- (void)singleTapAction {
    if (self.singleTap) {
        self.singleTap([self.imageView.superview convertRect:self.imageView.frame toView:[[UIApplication sharedApplication].delegate window]]);
    }
}
- (void)panAction:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self panGestureRecognizerStateBegan:pan];
            break;
        case UIGestureRecognizerStateChanged:
            [self panGestureRecognizerStateChanged:pan];
            break;
        case UIGestureRecognizerStateEnded:
            [self panGestureRecognizerStateEnded:pan];
            break;
        case UIGestureRecognizerStateCancelled:
            [self panGestureRecognizerStateEnded:pan];
            break;
        default:
            [self resetImageView];
            break;
    }
}
- (void)panGestureRecognizerStateBegan:(UIPanGestureRecognizer *)pan {
    self.beganFrame = self.imageView.frame;
    self.beganTouch = [pan locationInView:self.scrollView];
}
- (void)panGestureRecognizerStateChanged:(UIPanGestureRecognizer *)pan {
    CGRect frame;
    CGFloat scale;
    [self calculationScaleWithPan:pan frame:&frame scale:&scale];
    self.imageView.frame = frame;
    if (self.alphaChange) {
        self.alphaChange(scale);
    }
}
- (void)panGestureRecognizerStateEnded:(UIPanGestureRecognizer *)pan {
    CGRect frame;
    CGFloat scale;
    [self calculationScaleWithPan:pan frame:&frame scale:&scale];
    self.imageView.frame = frame;
    if (self.alphaChange) {
        self.alphaChange(scale);
    }
    if (scale == 1.0) {
        [self resetImageView];
    }else {
        [self singleTapAction];
    }
}
- (void)resetImageView {
    CGRect frame = [CLPhotoBrowserImageScaleHelper calculateScaleFrameWithImageSize:self.imageView.image.size maxSize:[UIScreen mainScreen].bounds.size offset:YES];
    [UIView animateWithDuration:0.25 animations:^{
        if (self.alphaChange) {
            self.alphaChange(1.0);
        }
        self.imageView.frame = frame;
    }];
}
- (void)calculationScaleWithPan:(UIPanGestureRecognizer *)pan  frame:(CGRect *)frame scale:(CGFloat *)scale {
    CGPoint translation = [pan translationInView:self.scrollView];
    CGPoint currentTouch = [pan locationInView:self.scrollView];
    
    CGFloat scaleValue = MIN(1.0, MAX(0.3, (1 - translation.y / self.bounds.size.height)));
    
    CGFloat width = self.beganFrame.size.width * scaleValue;
    CGFloat height = self.beganFrame.size.height * scaleValue;
    
    CGFloat xRate = (self.beganTouch.x - self.beganFrame.origin.x) / self.beganFrame.size.width;
    CGFloat currentTouchDeltaX = xRate * width;
    CGFloat x = currentTouch.x - currentTouchDeltaX;
    
    CGFloat yRate = (self.beganTouch.y - self.beganFrame.origin.y) / self.beganFrame.size.height;
    CGFloat currentTouchDeltaY = yRate * height;
    CGFloat y = currentTouch.y - currentTouchDeltaY;
    *frame = CGRectMake(x, y, width, height);
    *scale = scaleValue;
}
//MARK: - JmoVxia---双击放大
-(void)doubleTapAction:(UITapGestureRecognizer *)tap {
    UIScrollView *scrollView = self.scrollView;
    UIView *zoomView = self.imageView;
    CGPoint point = [tap locationInView:zoomView];
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        [scrollView setZoomScale:1 animated:YES];
    } else {
        [scrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}
- (void)setImageUrl:(NSURL *)imageUrl placeholderImage:(UIImage *)placeholderImage {
    __weak __typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage completed:^(UIImage * __unused image, NSError * __unused error, SDImageCacheType __unused cacheType, NSURL * __unused imageURL) {
        if (image) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf reload];
        }
    }];
}
- (void)setImage:(UIImage *)image {
    self.imageView.image = nil;
    self.imageView.image = image;
    [self.imageView.sd_imageIndicator stopAnimatingIndicator];
    [self reload];
}
- (void)reload {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = [CLPhotoBrowserImageScaleHelper calculateScaleFrameWithImageSize:self.imageView.image.size maxSize:[UIScreen mainScreen].bounds.size offset:YES];
        CGFloat widthZoomScale = self.imageView.image.size.width / frame.size.width;
        CGFloat heightZoomScale = self.imageView.image.size.height / frame.size.height;
        CGFloat maximumZoomScale = MAX(2, MIN(widthZoomScale, heightZoomScale));
        if (self.scrollView.maximumZoomScale != maximumZoomScale) {
            self.scrollView.maximumZoomScale = maximumZoomScale;
        }
        if (self.scrollView.zoomScale != 1.0) {
            [self.scrollView setZoomScale:1.0 animated:NO];
        }
        if (!CGSizeEqualToSize(self.scrollView.contentSize, frame.size)) {
            self.scrollView.contentSize = frame.size;
        }
        if (!CGRectEqualToRect(self.imageView.frame, frame)) {
            self.imageView.frame = frame;
        }
        if (!CGRectEqualToRect(self.scrollView.frame, self.bounds)) {
            self.scrollView.frame = self.bounds;
        }
        if (frame.size.height > self.scrollView.frame.size.height) {
            [self.scrollView setContentOffset:CGPointMake(0, (frame.size.height - self.scrollView.frame.size.height) * 0.5) animated:NO];
        }
        if (frame.size.width > self.scrollView.frame.size.width) {
            [self.scrollView setContentOffset:CGPointMake((frame.size.width - self.scrollView.frame.size.width) * 0.5, 0) animated:NO];
        }
    });
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView __unused*)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }else {
        if (self.scrollView.zoomScale != 1.0) {
            return NO;
        }
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [panGesture velocityInView:self];
        if (velocity.y < 0) {
            return NO;
        }
        if (abs((int)(velocity.x)) > (int)velocity.y) {
            return NO;
        }
        if (self.scrollView.contentOffset.y > 0) {
            return NO;
        }
        return YES;
    }
}
- (UIScrollView *) scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_scrollView addSubview:self.imageView];
    }
    return _scrollView;
}
- (SDAnimatedImageView *) imageView {
    if (_imageView == nil) {
        _imageView = [[SDAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.sd_imageIndicator = [SDWebImageActivityIndicator whiteIndicator];
    }
    return _imageView;
}

@end
