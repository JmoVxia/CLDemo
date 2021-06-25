//
//  CLCardController.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardController.h"
#import "CLCardView.h"
#import "UIView+CLSetRect.h"

@interface CLCardController ()<CLCardViewDataSource>
///卡片视图
@property (nonatomic, strong) CLCardView *cardView;

@end

@implementation CLCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cardView];
}
- (CLCardView *) cardView{
    if (_cardView == nil){
        _cardView = [[CLCardView alloc] initWithFrame:CGRectMake(10, 200, self.view.cl_width - 20, 200)];
        [_cardView updateWithConfig:^(CLCardViewConfigure * _Nonnull configure) {
            configure.showRows = 3;
            configure.loopScroll = YES;
        }];
        _cardView.dataSource = self;
    }
    return _cardView;
}
-(NSInteger)cardViewRows:(CLCardView *)cardView {
    return 7;
}
-(CLCardViewCell *)cardView:(CLCardView *)cardView cellForRowAtIndexIndex:(NSInteger)index {
    CLCardViewCell * cell = [cardView dequeueReusableViewWithIdentifier:@"Identifier"];
    cell.backgroundColor = cl_RandomColor;
    cell.layer.cornerRadius = 10;
    cell.text = [NSString stringWithFormat:@"我是第%ld个",index];
    return cell;
}
-(void)dealloc {
    NSLog(@"卡片控制器销毁了");
}

@end
