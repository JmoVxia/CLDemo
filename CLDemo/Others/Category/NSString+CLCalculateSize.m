//
//  NSString+CLCalculateSize.m
//  CLDemo
//
//  Created by JmoVxia on 2016/12/16.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "NSString+CLCalculateSize.h"
#import <CoreText/CoreText.h>

@implementation NSString (CLCalculateSize)

/**
 根据文字计算宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}


- (int)calculateHeightWithFont:(UIFont*)font maxWidth:(CGFloat) maxWidth maxLines:(NSInteger)maxLines {
    NSDictionary *dict = @{NSFontAttributeName: font};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self attributes:dict];
    int total_height = 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);   
    CGRect drawingRect = CGRectMake(0, 0, maxWidth, 1000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    NSInteger bottomline = (maxLines == 0 ? linesArray.count : MIN(linesArray.count, maxLines)) - 1;
    int line_y = (origins[bottomline].y);
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    total_height = 1000 - line_y + (int)descent +1;
    CFRelease(textFrame);
    return total_height;
}


@end
