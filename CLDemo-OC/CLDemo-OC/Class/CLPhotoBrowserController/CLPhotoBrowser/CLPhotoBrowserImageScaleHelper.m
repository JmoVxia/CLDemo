//
//  CLPhotoBrowserImageScaleHelper.m
//  CLDemo
//
//  Created by AUG on 2019/7/18.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPhotoBrowserImageScaleHelper.h"

@implementation CLPhotoBrowserImageScaleHelper

+ (CGRect)calculateScaleFrameWithImageSize:(CGSize)imageSize maxSize:(CGSize)maxSize offset:(BOOL)offset {
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    CGFloat maxWidth = maxSize.width;
    CGFloat maxHeight = maxSize.height;
    
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat widthSpace = fabsf((float)(maxWidth - imageWidth));
    CGFloat heightSpace = fabsf((float)(maxHeight - imageHeight));
    
    if (widthSpace >= heightSpace) {
        if (maxWidth > imageWidth) {
            width = imageWidth * (maxHeight / imageHeight);
            height = imageHeight * (maxHeight / imageHeight);
        }else {
            width = imageWidth / (imageWidth / maxWidth);
            height = imageHeight / (imageWidth / maxWidth);
        }
    }else {
        if (maxHeight > imageHeight) {
            width = imageWidth * (maxWidth / imageWidth);
            height = imageHeight * (maxWidth / imageWidth);
        }else {
            width = imageWidth / (imageHeight / maxHeight);
            height = imageHeight / (imageHeight / maxHeight);
        }
    }
    
    x = (maxWidth - width) * 0.5;
    y = (maxHeight - height) * 0.5;
    CGRect frame = CGRectMake(x, y, width, height);
    if (x < 0 || y < 0) {
        frame = [CLPhotoBrowserImageScaleHelper calculateScaleFrameWithImageSize:CGSizeMake(width, height) maxSize:maxSize offset: offset];
    }
    
    if (frame.size.height > frame.size.width && frame.size.width < MIN(maxWidth, maxHeight) * 0.25) {
        CGFloat minWidth = MAX(MIN(maxWidth, imageWidth), maxWidth * 2 / 3.0);
        width = imageWidth * (minWidth / imageWidth);
        height = imageHeight * (minWidth / imageWidth);
        x = (maxWidth - width) * 0.5;
        if (!offset) {
            y = (maxHeight - height) * 0.5;
        }
        frame = CGRectMake(x, y, width, height);
    }
    
    if (frame.size.width > frame.size.height && frame.size.height < MIN(maxWidth, maxHeight) * 0.25) {
        CGFloat minHeight = MAX(MIN(maxHeight, imageHeight), maxHeight * 2 / 3.0);
        height = imageHeight * (minHeight / imageHeight);
        width = imageWidth * (minHeight / imageHeight);
        y = (maxHeight - height) * 0.5;
        if (!offset) {
            x = (maxWidth - width) * 0.5;
        }
        frame = CGRectMake(x, y, width, height);
    }
    
    return frame;
}

@end
