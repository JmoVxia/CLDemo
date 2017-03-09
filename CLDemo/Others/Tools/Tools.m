//
//  Tools.m
//  Tools
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "Tools.h"
#import "sys/utsname.h"


static Tools * manager = nil;

@implementation Tools

+(Tools *)sharedTools
{
    @synchronized(self) {
        if(manager == nil){
            manager = [[Tools alloc] init];
        }
    }
    return manager;
}


// 创建一个textField控件
+(UITextField *)createTextFieldPlaceholder:(NSString *)placeholder
                              keyboardType:(UIKeyboardType)kbType
{
    UITextField * textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = kbType;
    textField.textAlignment = NSTextAlignmentCenter;
    return textField;
}

// 创建一个按钮（文字）
+(UIButton *)createButtonTitle:(NSString *)title
                        target:(id)target
                        action:(SEL)action
{
    UIButton * button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    //    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 创建一个按钮 （以图片展现）
+(UIButton *)createButtonNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectImage tag:(NSUInteger)tag addTarget:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:selectImage forState:UIControlStateSelected];
    [btn setImage:selectImage forState:UIControlStateHighlighted];
    btn.tag = tag;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

// 展示警告框(只能确定)
+(void)showOneAlertMessage:(NSString *)msg andTitle:(NSString *)string byController:(UIViewController *)vc sure:(SureBlock)sure
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:string message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 确定的回调
        if(sure)
        {
            sure(action);
        }
        
    }];
    [alert addAction:sureAction];
    
    [vc presentViewController:alert animated:YES completion:nil];
}
//展示提示框（可以确定和取消）
+(void)showTwoAlertMessage:(NSString *)msg andTitle:(NSString *)string byController:(UIViewController *)vc sure:(SureBlock)sure cancel:(CancelBlock)cancel
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:string message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消的回调
        if (cancel)
        {
            cancel(action);
        }
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 确定的回调
        if(sure)
        {
            sure(action);
        }
        
    }];
    [alert addAction:sureAction];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark----------------清除缓存和显示缓存
/**
 *  清除和显示缓存方法
 */

/**
 *  遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
 */

/**
 *  NSString *str =  [ NSString stringWithFormat : @"清除缓存(%.2fM)" , [ self filePath ]];
 *
 *  @return 显示缓存（字符串）
 */
/**
 *  [self clearFile];
 *
 *  @return 清除缓存并弹出提示框
 */

- (NSString *)cacheSize
{
    NSString *str =  [ NSString stringWithFormat : @"清除缓存(%.2fM)" , [ self filePath ]];
    
    return str;
}

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
        
    }
    
    return 0 ;
    
}
/**
 *  显示缓存大小
 */
- ( float )filePath

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
/**
 *  清理文件缓存
 */
- ( void )clearFile:(NSString *)string andController:(UIViewController *)controller

{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    /**
     *  清理成功弹出提示框
     */
    [Tools showOneAlertMessage:@"清理缓存成功" andTitle:nil byController:controller sure:^(UIAlertAction *sureAction) {
        
    }];
    
}

/**
 *  设置系统默认标签控制器Item常态和选中状态图片颜色和字体大小
 *
 *  @param controller      要设置item的controller
 *  @param title           文字
 *  @param size            字体大小
 *  @param foneName        字体名称（为nil就是系统默认）
 *  @param selectedImage   选中状态图片
 *  @param selectColor     选中字体颜色
 *  @param unselectedImage 未选中状态图片
 *  @param unselectColor   未选中状态字体颜色
 *  需要注意的是使用自定义字体，名称一定不能弄错，否则崩溃
 *
 */
+ (void)setControllerTabBarItem:(UIViewController *)controller
                          Title:(NSString *)title
                    andFoneSize:(CGFloat)size
                   withFoneName:(NSString *)foneName
                  selectedImage:(NSString *)selectedImage
                 withTitleColor:(UIColor *)selectColor
                unselectedImage:(NSString *)unselectedImage
                 withTitleColor:(UIColor *)unselectColor{
    
    //设置图片
    controller.tabBarItem = [controller.tabBarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //未选中字体颜色  system为系统字体
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
}
/**
 *  创建导航条上面的item按钮
 *
 *  @param image     常态图片
 *  @param highImage 高亮图片
 *  @param target    响应（self）
 *  @param action    响应方法
 *
 *  @return 返回UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero, [btn backgroundImageForState:UIControlStateNormal].size};
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

//生成随机UUID
+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

//判断手机具体型号
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3 (China Model)";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";
    
    return platform;
}
//沙盒路径
+ (NSString*)pathDocuments
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return pathDocuments;
}
//获取明天时间
+ (NSString *)getTomorrowDayWithDateFormat:(NSString *)format
{
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:format];
    return [dateday stringFromDate:beginningOfWeek];
}
//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [self worldTimeToChinaTime:date];
}

//将世界时间转化为中国区时间
- (NSDate *)worldTimeToChinaTime:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}
//判断两个时间大小
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

//通过字符串计算label大小
//size 固定高，宽就设置无限大，固定宽，高就设置无线大
+ (CGRect)getLabelRectWithString:(NSString *)string andSize:(CGSize)size andFont:(UIFont *)font
{
    NSDictionary *dic=@{NSFontAttributeName:font};
    CGRect rect=[string boundingRectWithSize:CGSizeMake(size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect;
}
//判断时间在某个时间段内
+ (BOOL)compareDate:(NSDate*)date isBeginDate:(NSDate*)beginDate andEndDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}
//获取某个时间某天后的时间
+ (NSString *)getSomeDayWithDate:(NSDate *)date Num:(int)num DateFormat:(NSString *)format
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:([components day]+num)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:format];
    return [dateday stringFromDate:beginningOfWeek];
}
//将NSDate按格式时间输出NSString
+ (NSString*)dateToString:(NSDate *)date withFormat:(NSString *)format;
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}
//计算两个时间之间差几天
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:7];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day + 1;
}
@end
