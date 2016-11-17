//
//  Tools.h
//  Tools
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**随机颜色*/
#define DGRandomColor [UIColor colorWithRed:arc4random_uniform(256.0)/255.0 green:arc4random_uniform(256.0)/255.0 blue:arc4random_uniform(256.0)/255.0 alpha:1.0]


typedef void(^SureBlock)(UIAlertAction *sureAction);
typedef void(^CancelBlock)(UIAlertAction *cancelAction);

@interface Tools : NSObject

/**单例创建Tools*/
+(Tools *)sharedTools;


/**创建一个textField控件*/
+(UITextField *)createTextFieldPlaceholder:(NSString *)placeholder
                              keyboardType:(UIKeyboardType)kbType;

/**创建一个按钮（文字）*/
+(UIButton *)createButtonTitle:(NSString *)title
                        target:(id)target
                        action:(SEL)action;

/**创建一个按钮 （以图片展现）*/
+(UIButton *)createButtonNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectImage tag:(NSUInteger)tag addTarget:(id)target action:(SEL)action;

/**展示一个只能确定的警示框*/
+(void)showOneAlertMessage:(NSString *)msg andTitle:(NSString *)string byController:(UIViewController *)vc sure:(SureBlock)sure;
/**展示一个可以确定和取消的警示框*/
+(void)showTwoAlertMessage:(NSString *)msg andTitle:(NSString *)string byController:(UIViewController *)vc sure:(SureBlock)sure cancel:(CancelBlock)cancel;

/**显示缓存大小,返回字符串*/
- (NSString *)cacheSize;

/**清除缓存*/
- ( void )clearFile:(NSString *)string andController:(UIViewController *)controller;

/**设置全部tabbaritem常态和选中状态字体以及颜色大小*/
+ (void)setControllerTabBarItem:(UIViewController *)controller
                          Title:(NSString *)title
                    andFoneSize:(CGFloat)size
                   withFoneName:(NSString *)foneName
                  selectedImage:(NSString *)selectedImage
                 withTitleColor:(UIColor *)selectColor
                unselectedImage:(NSString *)unselectedImage
                 withTitleColor:(UIColor *)unselectColor;

/**设置导航条上面的系统item常态和高亮状态以及点击响应事件*/
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

/**随机生成UUID*/
+ (NSString *)uuidString;
/**判断手机具体型号*/
+ (NSString*)deviceVersion;
/**沙盒路径*/
+ (NSString*)pathDocuments;
/**获取明天时间*/
+ (NSString *)getTomorrowDayWithDateFormat:(NSString *)format;
/**字符串转date时间*/
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;
/**判断两个时间大小*/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
/**通过字符串计算Label大小*/
+ (CGRect)getLabelRectWithString:(NSString *)string andSize:(CGSize)size andFont:(UIFont *)font;
/**判断时间在某个时间段内*/
+ (BOOL)compareDate:(NSDate*)date isBeginDate:(NSDate*)beginDate andEndDate:(NSDate*)endDate;
/**将世界时间转化为中国区时间*/
- (NSDate *)worldTimeToChinaTime:(NSDate *)date;
/**获取某个时间某天后的时间*/
+ (NSString *)getSomeDayWithDate:(NSDate *)date Num:(int)num DateFormat:(NSString *)format;
/**将NSDate按格式时间输出*/
+ (NSString*)dateToString:(NSDate *)date withFormat:(NSString *)format;
/**获取两个时间间隔天数*/
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

@end

