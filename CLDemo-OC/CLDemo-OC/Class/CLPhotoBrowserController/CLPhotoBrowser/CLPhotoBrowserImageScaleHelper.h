//
//  CLPhotoBrowserImageScaleHelper.h
//  CLDemo
//
//  Created by AUG on 2019/7/18.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPhotoBrowserImageScaleHelper : NSObject


/**
 计算缩放后Frame

 @param imageSize 图片大小
 @param maxSize 最大大小
 @param offset 是否需要偏移
 @return 计算后的Frame
 */
+ (CGRect)calculateScaleFrameWithImageSize:(CGSize)imageSize maxSize:(CGSize)maxSize offset:(BOOL)offset;


@end

NS_ASSUME_NONNULL_END
