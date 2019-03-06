//
//  CLCardController.m
//  CLDemo
//
//  Created by AUG on 2019/2/26.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLCardController.h"
#import "CLCardView.h"

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
        _cardView = [[CLCardView alloc] initWithFrame:CGRectMake(10, 150, self.view.cl_width - 20, 150)];
        [_cardView updateWithConfig:^(CLCardViewConfigure * _Nonnull configure) {
            configure.showRows = 5;
        }];
        _cardView.dataSource = self;
    }
    return _cardView;
}


-(NSInteger)cardViewRows:(CLCardView *)cardView {
    return 3;
}

-(UITableViewCell *)cardView:(CLCardView *)cardView cellForRowAtIndexIndex:(NSInteger)index {
    UITableViewCell * cell = [cardView dequeueReusableViewWithIdentifier:@"Identifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld个",(long)index];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = cl_RandomColor;
    cell.layer.cornerRadius = 10;
    return cell;
}




@end
