//
//  UIImage+CLQRCode.m
//  CLDemo
//
//  Created by AUG on 2019/4/5.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "UIImage+CLQRCode.h"

@interface CLCorrectionConfigure ()

@end

@implementation CLCorrectionConfigure

+ (instancetype)initConfigure:(nonnull NSString *)text callBack:(void(^)(CLCorrectionConfigure *configure))callBack {
    CLCorrectionConfigure *configure = [[CLCorrectionConfigure alloc] init];
    configure.text = text;
    configure.correctionLevel = CLQRCodeCorrectionLevelSuperior;
    configure.delta = 30;
    configure.colorsArray = [NSMutableArray arrayWithArray:@[[UIColor redColor], [UIColor orangeColor]]];
    configure.leftTopOutColor = [UIColor cyanColor];
    configure.leftTopInColor = [UIColor yellowColor];
    configure.rightTopOutColor = [UIColor redColor];
    configure.rightTopInColor = [UIColor orangeColor];
    configure.leftBottomOutColor = [UIColor blueColor];
    configure.leftBottomInColor = [UIColor greenColor];
    if (callBack) {
        callBack(configure);
    }
    return configure;
}

@end

typedef NS_ENUM(NSInteger, kQRCodeDrawType) {
    CLQRCodeDrawTypeSquare = 0, // 正方形.
    CLQRCodeDrawTypeCircle = 1, // 圆.
};

@implementation UIImage (CLQRCode)

//MARK:JmoVxia---绘制二维码
+(nullable UIImage *)generateQRCodeWithConfigure:(nonnull CLCorrectionConfigure *)configure {
    if (configure.text.length == 0)
        return nil;
    //使用自动释放池，防止内存爆增
    @autoreleasepool {
        CIImage *originalImg = [self createCIImageWithString:configure.text correctionLevel:configure.correctionLevel];
        NSArray<NSArray *> *codePoints = [self getPixelsWithCIImage:originalImg];
        //对应纠错率二维码矩阵点数宽度
        CGFloat extent = originalImg.extent.size.width;
        CGFloat size = MIN(MIN(configure.delta, 10), 100) * extent;
        return [self drawWithCodePoints:codePoints size:size configure:configure];
    }
}
//MARK:JmoVxia---创建原始二维码
+(CIImage *)createCIImageWithString:(NSString *)string correctionLevel:(CLQRCodeCorrectionLevel)corLevel{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    NSString *corLevelString = nil;
    switch (corLevel) {
        case CLQRCodeCorrectionLevelLow:
            corLevelString = @"L";
            break;
        case CLQRCodeCorrectionLevelNormal:
            corLevelString = @"M";
            break;
        case CLQRCodeCorrectionLevelSuperior:
            corLevelString = @"Q";
            break;
        case CLQRCodeCorrectionLevelHight:
            corLevelString = @"H";
            break;
    }
    [filter setValue:corLevelString forKey:@"inputCorrectionLevel"];
    
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}
//MARK:JmoVxia---// 将 `CIImage` 转成 `CGImage`
+(CGImageRef)convertCIImageToCGImageForCIImage:(CIImage *)image {
    CGRect extent = CGRectIntegral(image.extent);
    
    size_t width = CGRectGetWidth(extent);
    size_t height = CGRectGetHeight(extent);
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, 1, 1);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return scaledImage;
}
//MARK:JmoVxia---将原始图片的所有点的色值保存到二维数组
+(NSArray<NSArray *>*)getPixelsWithCIImage:(CIImage *)image {
    NSMutableArray *pixels = [NSMutableArray array];
    
    // 将系统生成的二维码从 `CIImage` 转成 `CGImageRef`.
    CGImageRef imageRef = [self convertCIImageToCGImageForCIImage:image];
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    
    // 创建一个颜色空间.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 开辟一段 unsigned char 的存储空间，用 rawData 指向这段内存.
    // 每个 RGBA 色值的范围是 0-255，所以刚好是一个 unsigned char 的存储大小.
    // 每张图片有 height * width 个点，每个点有 RGBA 4个色值，所以刚好是 height * width * 4.
    // 这段代码的意思是开辟了 height * width * 4 个 unsigned char 的存储大小.
    unsigned char *rawData = (unsigned char *)calloc(height * width * 4, sizeof(unsigned char));
    
    // 每个像素的大小是 4 字节.
    NSUInteger bytesPerPixel = 4;
    // 每行字节数.
    NSUInteger bytesPerRow = width * bytesPerPixel;
    // 一个字节8比特
    NSUInteger bitsPerComponent = 8;
    
    // 将系统的二维码图片和我们创建的 rawData 关联起来，这样我们就可以通过 rawData 拿到指定 pixel 的内存地址.
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    for (int indexY = 0; indexY < height; indexY++) {
        NSMutableArray *tepArrM = [NSMutableArray array];
        for (int indexX = 0; indexX < width; indexX++) {
            // 取出每个 pixel 的 RGBA 值，保存到矩阵中.
            @autoreleasepool {
                NSUInteger byteIndex = bytesPerRow * indexY + indexX * bytesPerPixel;
                CGFloat red = (CGFloat)rawData[byteIndex];
                CGFloat green = (CGFloat)rawData[byteIndex + 1];
                CGFloat blue = (CGFloat)rawData[byteIndex + 2];
                
                BOOL shouldDisplay = red == 0 && green == 0 && blue == 0;
                [tepArrM addObject:@(shouldDisplay)];
                byteIndex += bytesPerPixel;
            }
        }
        [pixels addObject:[tepArrM copy]];
    }
    free(rawData);
    return [pixels copy];
}
//MARK:JmoVxia---根据二维码点数组绘制
+(UIImage *)drawWithCodePoints:(NSArray<NSArray *> *)codePoints size:(CGFloat)size configure:(CLCorrectionConfigure *) configure{
    CGFloat imgWH = size;
    CGFloat delta = imgWH/codePoints.count;
    
    UIGraphicsBeginImageContext(CGSizeMake(imgWH, imgWH));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int indexY = 0; indexY < codePoints.count; indexY++) {
        for (int indexX = 0; indexX < codePoints[indexY].count; indexX++) {
            @autoreleasepool {
                BOOL shouldDisplay = [codePoints[indexY][indexX] boolValue];
                if (shouldDisplay) {
                    //类型随机
                    kQRCodeDrawType drawType = arc4random() % 2;
                    //颜色随机
                    UIColor *color = [self randomColor:configure.colorsArray];
                    //左上定位点
                    if (indexX < 8 && indexY < 8 ) {
                        color = configure.leftTopOutColor;
                        //内圈
                        if ((indexX > 2 && indexX < 6) && (indexY >= 2 && indexY < 6)) {
                            color = configure.leftTopInColor;
                        }
                        drawType = 0;
                    }
                    //右上定位点
                    if (indexY < 8 && indexX >= codePoints.count - 8) {
                        color = configure.rightTopOutColor;
                        //内圈
                        if ((indexY > 2 && indexY < 6) && (indexX >= codePoints.count - 6 && indexX < codePoints.count - 2)) {
                            color = configure.rightTopInColor;
                        }
                        drawType = 0;
                    }
                    //左下定位点
                    if (indexX < 8 && indexY >= codePoints.count - 8) {
                        color = configure.leftBottomOutColor;
                        //内圈
                        if ((indexX > 2 && indexX < 6) && (indexY >= codePoints.count - 6 && indexY < codePoints.count - 2)) {
                            color = configure.leftBottomInColor;
                        }
                        drawType = 0;
                    }
                    //绘制点
                    [self drawPointWithIndexX:indexX indexY:indexY delta:delta color:color drawType:drawType inContext:context];
                }
            }
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//MARK:JmoVxia---绘制点
+(void)drawPointWithIndexX:(CGFloat)indexX indexY:(CGFloat)indexY delta:(CGFloat)delta color:(UIColor *)color drawType:(kQRCodeDrawType)drawType inContext:(CGContextRef)context {
    UIBezierPath *bezierPath;
    if (drawType==CLQRCodeDrawTypeCircle) {
        //圆
        CGFloat centerX = indexX * delta + 0.5 * delta;
        CGFloat centerY = indexY * delta + 0.5 * delta;
        //0.8是增加原点直接间隙
        CGFloat radius = 0.5 * delta * 0.8;
        CGFloat startAngle = 0;
        CGFloat endAngle = 2 * M_PI;
        bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
    }else if (drawType==CLQRCodeDrawTypeSquare){
        //正方形
        bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(indexX * delta, indexY * delta, delta, delta)];
    }
    CGContextSaveGState(context);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
}
//MARK:JmoVxia---随机颜色
+ (UIColor *)randomColor:(NSMutableArray<UIColor *> *)colorsArray {
    NSInteger i = arc4random() % colorsArray.count;
    return [colorsArray objectAtIndex:i];
}

@end
