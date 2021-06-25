//
//  Tools.h
//  CL
//
//  Created by JmoVxia on 2016/12/30.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^SureBlock)(UIAlertAction *sureAction);
typedef void(^CancelBlock)(UIAlertAction *cancelAction);
@interface Tools : NSObject

/**单例创建Tools*/
+(Tools *)sharedTools;


/**
 *  设置全部tabbaritem常态和选中状态字体以及颜色大小
 */
+ (void)setControllerTabBarItem:(UIViewController *)controller
                          Title:(NSString *)title
                    andFoneSize:(CGFloat)size
                   withFoneName:(NSString *)foneName
                  selectedImage:(NSString *)selectedImage
                 withTitleColor:(UIColor *)selectColor
                unselectedImage:(NSString *)unselectedImage
                 withTitleColor:(UIColor *)unselectColor;

/**
 *  设置导航条上面的系统item常态和高亮状态以及点击响应事件
 */
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
/**获取当地时区的时间*/
+ (NSDate *)getLocalDate:(NSDate *)date;
/**
 查找路径及其子路径下所有指定类型文件
 
 @param type 文件类型
 @param path 路径
 @return 所有查找出来的文件路径
 */
+ (NSMutableArray *)findAllFileWithType:(NSString *)type andPath:(NSString *)path;


/**
 查找路径及其子路径下所有指定类型文件所在文件夹路径

 @param type 文件类型
 @param path 文件所在文件夹路径
 @return 文件夹路径数组
 */
+ (NSMutableArray *)findAllFolderWithType:(NSString *)type andPath:(NSString *)path;

/**
 判断是不是第一次启动
 */
+(BOOL)isFirstLaunch;


/**
 判断是不是第一次进入某个页面
 */
+(BOOL)isFirstWithClassName:(NSString *)className;
///截图
+ (UIImage *)screenshotImageFromView:(UIView *)view;

@end
