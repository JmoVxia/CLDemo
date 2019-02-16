//
//  CLBankCardView.m
//  CLBankCardRecognition
//
//  Created by iOS1 on 2018/6/18.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLBankCardView.h"

@interface CLBankCardView ()

@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, strong) NSTimer *timer;


@end


@implementation CLBankCardView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self.timer fire];
        _showLine = NO;
        // 提示标签
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"请将左右边对齐扫描线对准银行卡号";
        [tipLabel sizeToFit];
        tipLabel.textColor = [UIColor whiteColor];
        CGSize size = [tipLabel sizeThatFits:CGSizeZero];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        [self addSubview:tipLabel];
        tipLabel.center = CGPointMake(frame.size.width + size.height * 0.5, self.frame.size.height * 0.5);
    }
    return self;
}


-(void)timerFire:(id)notice {
    _showLine = !_showLine;
    [self setNeedsDisplay];
}

-(void)dealloc {
    [self.timer invalidate];
}

//画边框和线
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    CGContextSetRGBStrokeColor(context, .3, 0.8, .3, 1);
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGFloat height = 15;
    
    CGContextMoveToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + height, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y + height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, pt.x + rect.size.width, pt.y);
    CGContextAddLineToPoint(context, pt.x + rect.size.width, pt.y);
    CGContextAddLineToPoint(context, pt.x + rect.size.width - height, pt.y);
    CGContextAddLineToPoint(context, pt.x + rect.size.width, pt.y);
    CGContextAddLineToPoint(context, pt.x + rect.size.width, pt.y + height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, pt.x, pt.y + rect.size.height);
    CGContextAddLineToPoint(context, pt.x, pt.y + rect.size.height);
    CGContextAddLineToPoint(context, pt.x, pt.y + rect.size.height - height);
    CGContextAddLineToPoint(context, pt.x, pt.y + rect.size.height);
    CGContextAddLineToPoint(context, pt.x + height, pt.y + rect.size.height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, pt.x + rect.size.width, pt.y + rect.size.height);
    CGContextAddLineToPoint(context, pt.x + rect.size.width, pt.y + rect.size.height);
    CGContextAddLineToPoint(context, pt.x + rect.size.width, pt.y + rect.size.height - height);
    CGContextAddLineToPoint(context, pt.x + rect.size.width, pt.y + rect.size.height);
    CGContextAddLineToPoint(context, pt.x + rect.size.width - height, pt.y + rect.size.height);
    CGContextStrokePath(context);
    
    if(_showLine)
    {
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1);
        CGPoint p1, p2;
        float x = rect.origin.x + rect.size.width * 22 / 54;
        p1 = CGPointMake(x, rect.origin.y);
        p2 = CGPointMake(x, rect.origin.y + rect.size.height);
        CGContextMoveToPoint(context,p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        CGContextStrokePath(context);
    }
}

+ (CGRect)getOverlayFrame:(CGRect)rect {
    float previewWidth = rect.size.width;
    float previewHeight = rect.size.height;
    float cardh, cardw;
    float left, top;
    cardw = previewWidth * 0.7;
    //if(cardw < 720) cardw = 720;
    if(previewWidth < cardw)
        cardw = previewWidth;
    cardh = (int)(cardw / 0.63084f);
    left = (previewWidth-cardw) * 0.5;
    top = (previewHeight-cardh + 64) * 0.5;
    
    return CGRectMake(left, top, cardw, cardh);
}
@end
