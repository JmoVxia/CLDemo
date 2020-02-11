

//
//  MeController.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLHomepageController.h"
#import "CLDemo-Swift.h"
#import "CLChangeLanguageController.h"
#import "CLChangeFontSizeController.h"
#import "CLRotateAnimationController.h"
#import "CLPasswordViewController.h"
#import "CLLogViewController.h"
#import "CLInputToolbarController.h"
#import "CLBankCardScanController.h"
#import "CLCardController.h"
#import "CLWaveViewController.h"
#import "CLBubbleViewViewController.h"
#import "CLCustomQRCodeViewController.h"
#import "CLPopArrowViewController.h"
#import "CLCountdownController.h"
#import "CLLayoutController.h"
#import "CLPhotoBrowserTableViewController.h"
#import "CLTransitionController.h"
#import "CLMailboxAutoCompletionViewController.h"
#import "CLCustomTransitionViewController.h"
#import "CLLineChartViewController.h"
#import "CLBroadcastViewController.h"
#import "CLInputPasswordViewController.h"
#import "CLDrawImageController.h"
#import "CLPhoneNumberVerificationController.h"

@interface CLHomepageController ()<UITableViewDelegate,UITableViewDataSource>

/**tableview*/
@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayDS;
///控制器数组
@property (nonatomic, strong) NSMutableArray<Class> *controllerArray;

@end

@implementation CLHomepageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"主页", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDS.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.arrayDS[indexPath.row];
    cell.textLabel.font = [UIFont clFontOfSize:18];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    });
    Class class = [self.controllerArray objectAtIndex:indexPath.row];
    UIViewController *controller =  (UIViewController *)[[class alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableView *) tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *) arrayDS {
    if (_arrayDS == nil) {
        _arrayDS = [[NSMutableArray alloc] init];
        [_arrayDS addObject:NSLocalizedString(@"切换语言", nil)];
        [_arrayDS addObject:NSLocalizedString(@"修改字号", nil)];
        [_arrayDS addObject:NSLocalizedString(@"绘制头像", nil)];
        [_arrayDS addObject:NSLocalizedString(@"水平布局", nil)];
        [_arrayDS addObject:NSLocalizedString(@"标签动态排布", nil)];
        [_arrayDS addObject:NSLocalizedString(@"自定义弹窗", nil)];
        [_arrayDS addObject:NSLocalizedString(@"游标卡尺", nil)];
        [_arrayDS addObject:NSLocalizedString(@"翻转动画", nil)];
        [_arrayDS addObject:NSLocalizedString(@"聊天框架", nil)];
        [_arrayDS addObject:NSLocalizedString(@"广播轮播", nil)];
        [_arrayDS addObject:NSLocalizedString(@"折线图", nil)];
        [_arrayDS addObject:NSLocalizedString(@"手机号码验证", nil)];
        [_arrayDS addObject:NSLocalizedString(@"自定义转场动画", nil)];
        [_arrayDS addObject:NSLocalizedString(@"模态交互式转场", nil)];
        [_arrayDS addObject:NSLocalizedString(@"Cell倒计时", nil)];
        [_arrayDS addObject:NSLocalizedString(@"图片浏览器", nil)];
        [_arrayDS addObject:NSLocalizedString(@"邮箱自动补全", nil)];
        [_arrayDS addObject:[NSLocalizedString(@"转子动画", nil) stringByAppendingString:@"-OC"]];
        [_arrayDS addObject:[NSLocalizedString(@"转子动画", nil) stringByAppendingString:@"-Swift"]];
        [_arrayDS addObject:[NSLocalizedString(@"自定义密码框", nil) stringByAppendingString:@"-OC"]];
        [_arrayDS addObject:[NSLocalizedString(@"自定义密码框", nil) stringByAppendingString:@"-Swift"]];
        [_arrayDS addObject:NSLocalizedString(@"键盘密码工具条", nil)];
        [_arrayDS addObject:NSLocalizedString(@"自定义输入工具条", nil)];
        [_arrayDS addObject:NSLocalizedString(@"自定义输入框-限制字数", nil)];
        [_arrayDS addObject:NSLocalizedString(@"银行卡识别", nil)];
        [_arrayDS addObject:NSLocalizedString(@"卡片视图", nil)];
        [_arrayDS addObject:[NSLocalizedString(@"波浪视图", nil) stringByAppendingString:@"-OC"]];
        [_arrayDS addObject:[NSLocalizedString(@"波浪视图", nil) stringByAppendingString:@"-Swift"]];
        [_arrayDS addObject:NSLocalizedString(@"气泡拖拽", nil)];
        [_arrayDS addObject:NSLocalizedString(@"自定义二维码", nil)];
        [_arrayDS addObject:NSLocalizedString(@"箭头弹出框", nil)];
        [_arrayDS addObject:NSLocalizedString(@"旋转图片", nil)];
        [_arrayDS addObject:NSLocalizedString(@"日志", nil)];
        [_arrayDS addObject:NSLocalizedString(@"过渡动画", nil)];
    }
    return _arrayDS;
}

- (NSMutableArray *) controllerArray {
    if (_controllerArray == nil) {
        _controllerArray = [[NSMutableArray alloc] init];
        [_controllerArray addObject:[CLChangeLanguageController class]];
        [_controllerArray addObject:[CLChangeFontSizeController class]];
        [_controllerArray addObject:[CLDrawImageController class]];
        [_controllerArray addObject:[CLLayoutController class]];
        [_controllerArray addObject:[CLTagsController class]];
        [_controllerArray addObject:[CLPopupController class]];
        [_controllerArray addObject:[CLVernierCaliperController class]];
        [_controllerArray addObject:[CLFlipController class]];
        [_controllerArray addObject:[CLChatController class]];
        [_controllerArray addObject:[CLBroadcastViewController class]];
        [_controllerArray addObject:[CLLineChartViewController class]];
        [_controllerArray addObject:[CLPhoneNumberVerificationController class]];
        [_controllerArray addObject:[CLCustomTransitionViewController class]];
        [_controllerArray addObject:[CLTransitionController class]];
        [_controllerArray addObject:[CLCountdownController class]];
        [_controllerArray addObject:[CLPhotoBrowserTableViewController class]];
        [_controllerArray addObject:[CLMailboxAutoCompletionViewController class]];
        [_controllerArray addObject:[CLRotateAnimationController class]];
        [_controllerArray addObject:[CLRotateAnimationSwiftController class]];
        [_controllerArray addObject:[CLPasswordViewController class]];
        [_controllerArray addObject:[CLPasswordViewSwiftController class]];
        [_controllerArray addObject:[CLInputPasswordViewController class]];
        [_controllerArray addObject:[CLInputToolbarController class]];
        [_controllerArray addObject:[CLTextViewViewController class]];
        [_controllerArray addObject:[CLBankCardScanController class]];
        [_controllerArray addObject:[CLCardController class]];
        [_controllerArray addObject:[CLWaveViewController class]];
        [_controllerArray addObject:[CLWaveSwiftViewController class]];
        [_controllerArray addObject:[CLBubbleViewViewController class]];
        [_controllerArray addObject:[CLCustomQRCodeViewController class]];
        [_controllerArray addObject:[CLPopArrowViewController class]];
        [_controllerArray addObject:[CLRotatingPictureViewController class]];
        [_controllerArray addObject:[CLLogViewController class]];
        [_controllerArray addObject:[CLTransitionViewController class]];
    }
    return _controllerArray;
}

-(void)dealloc {
    CLLog(@"我的页面销毁了");
}

@end
