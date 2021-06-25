//
//  UIImage+ScaleToSize.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/1.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CLScaleToSize)


/**
 重新绘制图片大小

 @param image 原始图片
 @param size  需要的大小

 @return 返回改变大小后图片
 */
+ (UIImage*) originImage:(UIImage*)image scaleToSize:(CGSize)size;

@end
