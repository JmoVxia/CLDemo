//
//  Tools.m
//  CL
//
//  Created by JmoVxia on 2016/12/30.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "Tools.h"
#import "sys/utsname.h"


static Tools * manager = nil;
static NSString *const kAppVersion = @"ADappVersion";

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






/**
 *  设置系统默认标签控制器Item常态和选中状态图片颜色和字体大小
 *
 *  @param controller      要设置的item
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
//    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
//    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
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
+ (NSString *)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([machineString isEqualToString:@"iPhone1,1"])   return @"iPhone_1G";
    if ([machineString isEqualToString:@"iPhone1,2"])   return @"iPhone_3G";
    if ([machineString isEqualToString:@"iPhone2,1"])   return @"iPhone_3GS";
    if ([machineString isEqualToString:@"iPhone3,1"])   return @"iPhone_4";
    if ([machineString isEqualToString:@"iPhone3,3"])   return @"iPhone_4_Verizon";
    if ([machineString isEqualToString:@"iPhone4,1"])   return @"iPhone_4S";
    if ([machineString isEqualToString:@"iPhone5,1"])   return @"iPhone_5_GSM";
    if ([machineString isEqualToString:@"iPhone5,2"])   return @"iPhone_5_CDMA";
    if ([machineString isEqualToString:@"iPhone5,3"])   return @"iPhone_5C_GSM";
    if ([machineString isEqualToString:@"iPhone5,4"])   return @"iPhone_5C_GSM_CDMA";
    if ([machineString isEqualToString:@"iPhone6,1"])   return @"iPhone_5S_GSM";
    if ([machineString isEqualToString:@"iPhone6,2"])   return @"iPhone_5S_GSM_CDMA";
    if ([machineString isEqualToString:@"iPhone7,2"])   return @"iPhone_6";
    if ([machineString isEqualToString:@"iPhone7,1"])   return @"iPhone_6_Plus";
    if ([machineString isEqualToString:@"iPhone8,1"])   return @"iPhone_6S";
    if ([machineString isEqualToString:@"iPhone8,2"])   return @"iPhone_6S_Plus";
    if ([machineString isEqualToString:@"iPhone8,4"])   return @"iPhone_SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([machineString isEqualToString:@"iPhone9,1"])   return @"Chinese_iPhone_7";
    if ([machineString isEqualToString:@"iPhone9,2"])   return @"Chinese_iPhone_7_Plus";
    if ([machineString isEqualToString:@"iPhone9,3"])   return @"American_iPhone_7";
    if ([machineString isEqualToString:@"iPhone9,4"])   return @"American_iPhone_7_Plus";
    if ([machineString isEqualToString:@"iPhone10,1"])  return @"iPhone_8";
    if ([machineString isEqualToString:@"iPhone10,4"])  return @"iPhone_8";
    if ([machineString isEqualToString:@"iPhone10,2"])  return @"iPhone_8_Plus";
    if ([machineString isEqualToString:@"iPhone10,5"])  return @"iPhone_8_Plus";
    if ([machineString isEqualToString:@"iPhone10,3"])  return @"iPhone_X";
    if ([machineString isEqualToString:@"iPhone10,6"])  return @"iPhone_X";
    //Touch
    if ([machineString isEqualToString:@"iPod1,1"])     return @"iPod_Touch_1G";
    if ([machineString isEqualToString:@"iPod2,1"])     return @"iPod_Touch_2G";
    if ([machineString isEqualToString:@"iPod3,1"])     return @"iPod_Touch_3G";
    if ([machineString isEqualToString:@"iPod4,1"])     return @"iPod_Touch_4G";
    if ([machineString isEqualToString:@"iPod5,1"])     return @"iPod_Touch_5Gen";
    if ([machineString isEqualToString:@"iPod7,1"])     return @"iPod_Touch_6G";
    //iPad
    if ([machineString isEqualToString:@"iPad1,1"])     return @"iPad_1";
    if ([machineString isEqualToString:@"iPad1,2"])     return @"iPad_3G";
    if ([machineString isEqualToString:@"iPad2,1"])     return @"iPad_2_WiFi";
    if ([machineString isEqualToString:@"iPad2,2"])     return @"iPad_2_GSM";
    if ([machineString isEqualToString:@"iPad2,3"])     return @"iPad_2_CDMA";
    if ([machineString isEqualToString:@"iPad2,4"])     return @"iPad_2_CDMA";
    if ([machineString isEqualToString:@"iPad2,5"])     return @"iPad_Mini_WiFi";
    if ([machineString isEqualToString:@"iPad2,6"])     return @"iPad_Mini_GSM";
    if ([machineString isEqualToString:@"iPad2,7"])     return @"iPad_Mini_CDMA";
    if ([machineString isEqualToString:@"iPad3,1"])     return @"iPad_3_WiFi";
    if ([machineString isEqualToString:@"iPad3,2"])     return @"iPad_3_GSM";
    if ([machineString isEqualToString:@"iPad3,3"])     return @"iPad_3_CDMA";
    if ([machineString isEqualToString:@"iPad3,4"])     return @"iPad_4_WiFi";
    if ([machineString isEqualToString:@"iPad3,5"])     return @"iPad_4_GSM";
    if ([machineString isEqualToString:@"iPad3,6"])     return @"iPad_4_CDMA";
    if ([machineString isEqualToString:@"iPad4,1"])     return @"iPad_Air";
    if ([machineString isEqualToString:@"iPad4,2"])     return @"iPad_Air_Cellular";
    if ([machineString isEqualToString:@"iPad4,4"])     return @"iPad_Mini_2";
    if ([machineString isEqualToString:@"iPad4,5"])     return @"iPad_Mini_2_Cellular";
    if ([machineString isEqualToString:@"iPad4,7"])     return @"iPad_Mini_3_WiFi";
    if ([machineString isEqualToString:@"iPad4,8"])     return @"iPad_Mini_3_Cellular";
    if ([machineString isEqualToString:@"iPad4,9"])     return @"iPad_Mini_3_Cellular";
    if ([machineString isEqualToString:@"iPad5,1"])     return @"iPad_Mini_4_WiFi";
    if ([machineString isEqualToString:@"iPad5,2"])     return @"iPad_Mini_3_Cellular";
    if ([machineString isEqualToString:@"iPad5,3"])     return @"iPad_Air_2_WiFi";
    if ([machineString isEqualToString:@"iPad5,4"])     return @"iPad_Air_2_Cellular";
    if ([machineString isEqualToString:@"iPad6,3"])     return @"iPad_Pro_97inch_WiFi";
    if ([machineString isEqualToString:@"iPad6,4"])     return @"iPad_Pro_97inch_Cellular";
    if ([machineString isEqualToString:@"iPad6,7"])     return @"iPad_Pro_129inch_WiFi";
    if ([machineString isEqualToString:@"iPad6,8"])     return @"iPad_Pro_129inch_Cellular";
    //TV
    if ([machineString isEqualToString:@"AppleTV2,1"])  return @"appleTV2";
    if ([machineString isEqualToString:@"AppleTV3,1"])  return @"appleTV3";
    if ([machineString isEqualToString:@"AppleTV3,2"])  return @"appleTV3";
    if ([machineString isEqualToString:@"AppleTV5,3"])  return @"appleTV4";
    //模拟器
    if ([machineString isEqualToString:@"i386"])        return @"i386Simulator";
    if ([machineString isEqualToString:@"x86_64"])      return @"x86_64Simulator";
    
    return @"iUnknown";
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
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
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
        //大于
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        //小于
        return -1;
    }
    //NSLog(@"Both dates are the same");
    //等于
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
    
    return dayComponents.day;
}
+ (NSDate *)getLocalDate:(NSDate *)date {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    return destinationDateNow;
}
// 查找路径及其子路径下所有指定类型文件
+ (NSMutableArray *)findAllFileWithType:(NSString *)type andPath:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    //深度遍历路径及其子路径下所有文件以及文件夹
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:path];
    //文件及文件夹名称数组
    NSMutableArray *fileNameListArray = [NSMutableArray array];
    //路径下所有文件和文件夹
    NSString *allPath;
    while ((allPath = [dirEnum nextObject]) != nil)
    {
        [fileNameListArray addObject:allPath];
    }
    //所需文件数组
    NSMutableArray *fileArray = [NSMutableArray array];
    //遍历所有所有文件和文件夹名称数组
    [fileNameListArray enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        //后缀名称
        NSString *lastPath = [filePath pathExtension];
        //判断后缀名称是否是需要类型
        if([lastPath isEqualToString:type]){
            //是
            [fileArray addObject:[NSString stringWithFormat:@"%@/%@",path,filePath]];
        }else{
            //不是
        }
    }];
    return fileArray;
}

+ (NSMutableArray *)findAllFolderWithType:(NSString *)type andPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    //深度遍历路径及其子路径下所有文件以及文件夹
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:path];
    //文件及文件夹名称数组
    NSMutableArray *fileNameListArray = [NSMutableArray array];
    //路径下所有文件和文件夹
    NSString *allPath;
    while ((allPath = [dirEnum nextObject]) != nil)
    {
        [fileNameListArray addObject:allPath];
    }
    //所需文件数组
    NSMutableArray *fileArray = [NSMutableArray array];
    //遍历所有所有文件和文件夹名称数组
    [fileNameListArray enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        //后缀名称
        NSString *lastPath = [filePath pathExtension];
        //判断后缀名称是否是需要类型
        if([lastPath isEqualToString:type]){
            //是
            [fileArray addObject:path];
        }else{
            //不是
        }
    }];
    return fileArray;
}
//判断是不是首次登录或者版本更新
+(BOOL )isFirstLaunch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
/**
 判断是不是第一次进入某个页面
 */
+(BOOL)isFirstWithClassName:(NSString *)className{
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:className];
    if (version == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"isFirst" forKey:className];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}

+ (UIImage *)screenshotImageFromView:(UIView *)view {
    //高清方法
    //第一个参数表示区域大小 第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    CGSize size = CGSizeMake(view.layer.bounds.size.width, view.layer.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
