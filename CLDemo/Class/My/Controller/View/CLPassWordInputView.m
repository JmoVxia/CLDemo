//
//  CLPassWordInputView.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPassWordInputView.h"
#import "UIColor+CLHex.h"

static NSString  * const MONEYNUMBERS = @"0123456789";

@interface CLPassWordInputView ()

@property (strong, nonatomic) NSMutableString *textStore;//保存密码的字符串

@end


@implementation CLPassWordInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textStore = [NSMutableString string];
        self.squareWidth = 50;
        self.passWordNum = 6;
        self.pointRadius = 9 * 0.5;
        self.spaceMultiple = 5;
        self.rectColor = [UIColor colorWithRGBHex:0xb2b2b2];
        self.pointColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 *  设置正方形的边长
 */
- (void)setSquareWidth:(CGFloat)squareWidth {
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}

/**
 *  设置键盘的类型
 */
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

/**
 *  设置密码的位数
 */
- (void)setPassWordNum:(NSUInteger)passWordNum {
    _passWordNum = passWordNum;
    [self setNeedsDisplay];
}

- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passWordBeginInput:)]) {
        [self.delegate passWordBeginInput:self];
    }
    return [super becomeFirstResponder];
}

/**
 *  是否能成为第一响应者
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

#pragma mark - UIKeyInput
/**
 *  用于显示的文本对象是否有任何文本
 */
- (BOOL)hasText {
    return self.textStore.length > 0;
}

/**
 *  插入文本
 */
- (void)insertText:(NSString *)text {
    if (self.textStore.length < self.passWordNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
                [self.delegate passWordDidChange:self];
            }
            if (self.textStore.length == self.passWordNum) {
                if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:)]) {
                    [self.delegate passWordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/**
 *  删除文本
 */
- (void)deleteBackward {
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
            [self.delegate passWordDidChange:self];
        }
    }
    [self setNeedsDisplay];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat middleSpace = (width - self.passWordNum * self.squareWidth) / (self.passWordNum - 1 + self.spaceMultiple * 2);
    CGFloat leftSpace = middleSpace * self.spaceMultiple;
    CGFloat y = (height - self.squareWidth) * 0.5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画外框
    for (int i = 0; i < self.passWordNum; i++) {
        CGContextAddRect(context, CGRectMake(leftSpace + i * self.squareWidth + i * middleSpace, y, self.squareWidth, self.squareWidth));
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    //画黑点
    for (int i = 1; i <= self.textStore.length; i++) {
        CGContextAddArc(context,  leftSpace + i * self.squareWidth + (i - 1) * middleSpace - self.squareWidth * 0.5, y + self.squareWidth * 0.5, self.pointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
