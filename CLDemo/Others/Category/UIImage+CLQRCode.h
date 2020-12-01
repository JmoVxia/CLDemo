//
//  UIImage+CLQRCode.h
//  CLDemo
//
//  Created by AUG on 2019/4/5.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CLQRCodeCorrectionLevel) {
    CLQRCodeCorrectionLevelLow, ///< 低纠正率.
    CLQRCodeCorrectionLevelNormal, ///< 一般纠正率.
    CLQRCodeCorrectionLevelSuperior, ///< 较高纠正率.
    CLQRCodeCorrectionLevelHight, ///< 高纠正率.
};


@interface CLCorrectionConfigure : NSObject

///二维码字符串
@property (nonatomic, copy) NSString *text;
///纠正等级，越高越容易识别，二维码越复杂
@property (nonatomic, assign) CLQRCodeCorrectionLevel correctionLevel;
///对应纠错率二维码矩阵点数宽度倍数(px) 10-100,越大越清晰，消耗资源越多，生成二维码越慢
@property (nonatomic, assign) NSInteger delta;
///随机颜色数组
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorsArray;
///左上定位点内圈颜色
@property (nonatomic, strong) UIColor *leftTopInColor;
///左上定位点外圈颜色
@property (nonatomic, strong) UIColor *leftTopOutColor;
///右上定位点内圈颜色
@property (nonatomic, strong) UIColor *rightTopInColor;
///右上定位点外圈颜色
@property (nonatomic, strong) UIColor *rightTopOutColor;
///左下定位点内圈颜色
@property (nonatomic, strong) UIColor *leftBottomInColor;
///左下定位点外圈颜色
@property (nonatomic, strong) UIColor *leftBottomOutColor;

/**
 初始化配置，不会循环引用
 */
+ (instancetype)initConfigure:(nonnull NSString *)text callBack:(void(^)(CLCorrectionConfigure *configure))callBack;

@end



@interface UIImage (CLQRCode)

/**
 根据配置生成二维码

 @param configure 配置
 @return 二维码图片
 */
+(nullable UIImage *)generateQRCodeWithConfigure:(nonnull CLCorrectionConfigure *)configure;


@end

NS_ASSUME_NONNULL_END
