//
//  CLDrawImageController.m
//  CLDemo
//
//  Created by AUG on 2019/11/16.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLDrawImageController.h"


@interface CLDrawImageController ()

///imageView
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CLDrawImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"绘制头像", nil);
    CGFloat width = 100;
    CGFloat height = 100;
    self.imageView.frame = CGRectMake(199, 199, width, height);
    [self.view addSubview:self.imageView];
    
    // 异步子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image1 = [self clipImageWithImage:[UIImage imageNamed:@"one"] rect:CGRectMake(width * 0.25, -height * 0.25, width, height) startAngle:-90 endAngle:(30)];
        UIImage *image2 = [self clipImageWithImage:[UIImage imageNamed:@"two"] rect:CGRectMake(0, height * 0.25, width, height) startAngle:30 endAngle:(150)];
        UIImage *image3 = [self clipImageWithImage:[UIImage imageNamed:@"three"] rect:CGRectMake(-width * 0.25, -height * 0.25, width, height) startAngle:150 endAngle:(270)];
        UIImage *image = [self mergeImgaeWithImageArray:@[image1,image2,image3] size:CGSizeMake(width, height)];
        //主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}
- (UIImage *)clipImageWithImage:(UIImage *)image rect:(CGRect)rect startAngle:(CGFloat)startAngle endAngle:(CGFloat )endAngle {
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width * 0.5, size.height * 0.5) radius:size.width * 0.5 startAngle:(M_PI * (startAngle) / 180.0) endAngle:(M_PI * (endAngle) / 180.0) clockwise:YES];
    [path1 addLineToPoint:CGPointMake(size.width * 0.5, size.height * 0.5)];
    [path1 addClip];
    [image drawInRect:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), size.width, size.height)];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipImage;
}
- (UIImage *)mergeImgaeWithImageArray:(NSArray<UIImage *> *)imageArray size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    for (UIImage *image in imageArray) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
}

- (UIImageView *) imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


@end
