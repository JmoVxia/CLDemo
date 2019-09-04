//
//  CLPasswordInputView.m
//  CLDemo
//
//  Created by AUG on 2019/1/15.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLPasswordInputView.h"
#import "UIColor+CLHex.h"

@implementation CLPasswordInputViewConfigure

+ (instancetype)defaultConfig {
    CLPasswordInputViewConfigure *configure = [[CLPasswordInputViewConfigure alloc] init];
    configure.squareWidth = 50;
    configure.passwordNum = 6;
    configure.pointRadius = 18 * 0.5;
    configure.spaceMultiple = 5;
    configure.rectColor = [UIColor colorWithRGBHex:0xb2b2b2];
    configure.pointColor = [UIColor blackColor];
    configure.rectBackgroundColor = [UIColor whiteColor];
    configure.backgroundColor = [UIColor whiteColor];
    configure.threePartyKeyboard = NO;
    return configure;
}

@end

@interface CLPasswordInputView ()

@property (nonatomic, strong) CLPasswordInputViewConfigure *configure;

@property (nonatomic, strong) NSMutableString *text;

@property (nonatomic, assign) BOOL isShow;

@end


@implementation CLPasswordInputView

- (CLPasswordInputViewConfigure *) configure{
    if (_configure == nil){
        _configure = [CLPasswordInputViewConfigure defaultConfig];
    }
    return _configure;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = [NSMutableString string];
        self.backgroundColor = self.configure.backgroundColor;
    }
    return self;
}
- (void)clearText {
    self.text = [NSMutableString string];
    [self setNeedsLayout];
}
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}
- (BOOL)becomeFirstResponder {
    if (!self.isShow) {
        if ([self.delegate respondsToSelector:@selector(passwordInputViewBeginInput:)]) {
            [self.delegate passwordInputViewBeginInput:self];
        }
    }
    self.isShow = YES;
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    if (self.isShow) {
        if ([self.delegate respondsToSelector:@selector(passwordInputViewEndInput:)]) {
            [self.delegate passwordInputViewEndInput:self];
        }
    }
    self.isShow = NO;
    return [super resignFirstResponder];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return YES;
}
- (BOOL)isSecureTextEntry {
    return !self.configure.threePartyKeyboard;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}
- (void)updateWithConfigure:(void(^)(CLPasswordInputViewConfigure *configure))configBlock {
    if (configBlock) {
        configBlock(self.configure);
    }
    self.backgroundColor = self.configure.backgroundColor;
    [self setNeedsDisplay];
}
//MARK:JmoVxia---UIKeyInput
- (BOOL)hasText {
    return self.text.length > 0;
}
- (void)insertText:(NSString *)text {
    if (self.text.length < self.configure.passwordNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.text appendString:text];
            if ([self.delegate respondsToSelector:@selector(passwordInputViewDidChange:)]) {
                [self.delegate passwordInputViewDidChange:self];
            }
            if (self.text.length == self.configure.passwordNum) {
                if ([self.delegate respondsToSelector:@selector(passwordInputViewCompleteInput:)]) {
                    [self.delegate passwordInputViewCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}
- (void)deleteBackward {
    if (self.text.length > 0) {
        [self.text deleteCharactersInRange:NSMakeRange(self.text.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passwordInputViewDidChange:)]) {
            [self.delegate passwordInputViewDidChange:self];
        }
    }
    if ([self.delegate respondsToSelector:@selector(passwordInputViewDidDeleteBackward:)]) {
        [self.delegate passwordInputViewDidDeleteBackward:self];
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
    CGFloat squareWidth = MIN(MAX(MIN(height, self.configure.squareWidth), (self.configure.pointRadius * 4)), height);
    CGFloat pointRadius = MIN(self.configure.pointRadius, squareWidth * 0.5) * 0.8;
    CGFloat middleSpace = (width - self.configure.passwordNum * squareWidth) / (self.configure.passwordNum - 1 + self.configure.spaceMultiple * 2);
    CGFloat leftSpace = middleSpace * self.configure.spaceMultiple;
    CGFloat y = (height - squareWidth) * 0.5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画外框
    for (NSUInteger i = 0; i < self.configure.passwordNum; i++) {
        CGContextAddRect(context, CGRectMake(leftSpace + i * squareWidth + i * middleSpace, y, squareWidth, squareWidth));
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, self.configure.rectColor.CGColor);
        CGContextSetFillColorWithColor(context, self.configure.rectBackgroundColor.CGColor);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.configure.pointColor.CGColor);
    //画黑点
    for (NSUInteger i = 1; i <= self.text.length; i++) {
        CGContextAddArc(context,  leftSpace + i * squareWidth + (i - 1) * middleSpace - squareWidth * 0.5, y + squareWidth * 0.5, pointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
