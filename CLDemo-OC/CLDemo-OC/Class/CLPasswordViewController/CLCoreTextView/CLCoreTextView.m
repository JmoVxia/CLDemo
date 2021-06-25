//
//  CLCoreTextView.m
//  CLDemo
//
//  Created by JmoVxia on 2019/1/16.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLCoreTextView.h"
#import "UIView+CLSetRect.h"
#import <CoreText/CoreText.h>
#import "UIFont+CLFont.h"

@interface CLCoreTextView ()

@property (nonatomic,assign) CGRect imgFrm;

@property (nonatomic,assign) CTFrameRef ctFrm;

@property (nonatomic,assign) NSInteger strLength;

@end



@implementation CLCoreTextView


//图片回调函数
static CGFloat ascentCallBacks(void *ref)
{
    //__bridge既是C的结构体转换成OC对象时需要的一个修饰词
    return [[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBacks(void *ref)
{
    return 0;
}

static CGFloat widthCallBacks(void *ref)
{
    return [[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //1.绘制上下文
    //1.1获取绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //1.2.coreText 起初是为OSX设计的，而OSX得坐标原点是左下角，y轴正方向朝上。iOS中坐标原点是左上角，y轴正方向向下。若不进行坐标转换，则文字从下开始，还是倒着的,因此需要设置以下属性
    ////设置字形的变换矩阵为不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //平移方法，将画布向上平移一个屏幕高
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //2.设置图片回调函数
    //2.1创建一个回调结构体，设置相关参数
    CTRunDelegateCallbacks callBacks;
    //memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    //2.2设置回调版本，默认这个
    callBacks.version = kCTRunDelegateVersion1;
    //2.3设置图片顶部距离基线的距离
    callBacks.getAscent = ascentCallBacks;
    //2.4设置图片底部距离基线的距离
    callBacks.getDescent = descentCallBacks;
    //2.5设置图片宽度
    callBacks.getWidth = widthCallBacks;
    //2.6创建一个代理
    NSDictionary *dicPic = @{@"height":@"60",@"width":@"60"};
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void * _Nullable)(dicPic));
    
    //3.插入图片
    //创建空白字符
    unichar placeHolder = 0xFFFC;
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
    NSMutableAttributedString *placeHolderMabString = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    //给字符串中的范围中字符串设置代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderMabString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    
    //4.设置要显示的文字
    NSMutableAttributedString *mabString = [[NSMutableAttributedString alloc] initWithString:@"\n这里在测试图文混排,我是富文本"];
    [mabString insertAttributedString:placeHolderMabString atIndex:12];
    [mabString addAttribute:NSFontAttributeName value:[UIFont clFontOfSize:30] range:NSMakeRange(0, 12)];
    
    
    //5.绘制文本
    //5.1.创建CTFramesetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabString);
    
    //5.2.创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    //5.3.创建CTFrame
    NSInteger length = mabString.length;
    self.strLength = length;
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, length), path, NULL);
    self.ctFrm = frame;
    CTFrameDraw(frame, context);
    
    //6.添加图片并绘制
    UIImage *image = [UIImage imageNamed:@"222"];
    CGRect imgFrm = [self calculateImageRectWithFrame:frame];
    self.imgFrm = imgFrm;
    CGContextDrawImage(context, imgFrm, image.CGImage);
    
    //7.释放
    CFRelease(delegate);
    //    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

#pragma mark 计算图片Frame
- (CGRect)calculateImageRectWithFrame:(CTFrameRef)frame
{
    //根据frame获取需要绘制的线的数组
    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame);
    NSInteger count = arrLines.count;
    CGPoint points[count];
    //获取起始点位置
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    
    for (int i = 0; i < count; i ++) {
        CTLineRef line = (__bridge CTLineRef)(arrLines[i]);
        //CTRun 或者叫做 Glyph Run，是一组共享想相同attributes（属性）的字形的集合体
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j ++) {
            CTRunRef run = (__bridge CTRunRef)(arrGlyphRun[j]);
            //获取CTRun的属性
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary *dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            //获取一个起点
            CGPoint point = points[i];
            //获取上下距
            CGFloat ascent,desecent;
            //创建一个Frame
            CGRect boundsRun;
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desecent, NULL);
            boundsRun.size.height = ascent + desecent;
            //获取偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            boundsRun.origin.x = point.x + xOffset;
            boundsRun.origin.y = point.y - desecent;
            //获取绘制路径
            CGPathRef path = CTFrameGetPath(frame);
            //获取剪裁区域边框
            CGRect colRect = CGPathGetBoundingBox(path);
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            
            return imageBounds;
        }
    }
    return CGRectZero;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self systemPointFromScreenPoint:[touch locationInView:self]];
    //判断点击的是图片还是文字
    if ([self checkIsClickOnImgWithPoint:location]) {
        return;
    }
    [self clickOnStringWithPoint:location];
}

#pragma mark 转化成屏幕坐标
- (CGPoint)systemPointFromScreenPoint:(CGPoint)origin
{
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

#pragma mark 点击图片
- (BOOL)checkIsClickOnImgWithPoint:(CGPoint)location
{
    if ([self isFrame:_imgFrm containsPoint:location]) {
        NSLog(@"你点击到了图片");
        return YES;
    }
    return NO;
}

- (BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(frame, point);
}

/*
 点击文字判断的大致步骤：
 1.根据Frame拿到所有Line
 2.计算每个Line中在全文的range
 3.计算每个字对应line原点的X值
 4.比对对应line的origin求得字对应起点坐标
 5.求得下一个字的横坐标和上一行的origin，结合起点坐标得出字的坐标范围
 6.屏幕坐标与drawRect坐标转换，判断是否在范围内
 */
#pragma mark 点击字符串
- (void)clickOnStringWithPoint:(CGPoint)point
{
    //获取所有CTLine
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrm);
    //初始化范围数组
    CFRange ranges[lines.count];
    //初始化原点数组
    CGPoint origins[lines.count];
    //获取所有CTLine的原点
    CTFrameGetLineOrigins(self.ctFrm, CFRangeMake(0, 0), origins);
    
    //获取每个CTLine中包含的富文本在整串富文本中的范围。将所有CTLine中字符串的范围保存下来放入数组中。
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        CFRange range = CTLineGetStringRange(line);
        ranges[i] = range;
    }
    
    for (int i = 0;i < self.strLength; i ++) {
        long maxLoc;
        int lineNum = 0;
        for (int j = 0; j < lines.count; j ++) {
            CFRange range = ranges[j];
            maxLoc = range.location + range.length - 1;
            if (i <= maxLoc) {
                lineNum = j;
                break;
            }
        }
        
        CTLineRef line = (__bridge CTLineRef)(lines[lineNum]);
        CGPoint origin = origins[lineNum];
        CGRect ctRunFrame = [self frameForCTRunWithIndex:i ctLine:line origin:origin];
        if ([self isFrame:ctRunFrame containsPoint:point]) {
            NSLog(@"您点击到了第 %d 个字符，位于第 %d 行，然而他没有响应事件。",i,lineNum);
            
            return;
        }
    }
    NSLog(@"您没有点击到文字");
}

/**
 字符Frame计算
 @param index  索引
 @param line   索引字符所在CTLine
 @param origin line的起点
 @return 返回Frame
 */
- (CGRect)frameForCTRunWithIndex:(NSInteger)index ctLine:(CTLineRef)line origin:(CGPoint)origin
{
    //获取字符起点相对于CTLine的原点的偏移量
    CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);
    //获取下一个字符的偏移量，两者之间即为字符X范围
    CGFloat offsetX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);
    offsetX += origin.x;
    offsetX2 += origin.x;
    CGFloat offsetY = origin.y;
    CGFloat lineAscent,lineDescent;
    //获取当前点击的CTRun
    NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
    CTRunRef runCurrent;
    for (int k = 0; k < runs.count; k ++) {
        CTRunRef run = (__bridge CTRunRef)(runs[k]);
        CFRange range = CTRunGetStringRange(run);
        NSRange rangeOC = NSMakeRange(range.location, range.length);
        if ([self isIndex:index inRange:rangeOC]) {
            runCurrent = run;
            break;
        }
    }
    //获得对应CTRun的尺寸信息
    CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);
    //计算当前点击的CTRun高度
    CGFloat height = lineAscent + lineDescent;
    return CGRectMake(offsetX, offsetY, offsetX2 - offsetX, height);
}


/**
 范围检测
 @param index 索引
 @param range 范围
 @return 范围内返回yes，否则返回no
 */
- (BOOL)isIndex:(NSInteger)index inRange:(NSRange)range
{
    if ((index <= (range.location + range.length - 1)) && (index >= range.location)) {
        return YES;
    }
    return NO;
}

- (int)getAttributedStringHeightWithString:(NSAttributedString *)string  maxWidth:(CGFloat)maxWidth
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, maxWidth, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) CFBridgingRetain([linesArray objectAtIndex:[linesArray count] - 1]);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}
- (void)dealloc
{
    if (_ctFrm) {
        CFRelease(_ctFrm);
    }
}



@end
