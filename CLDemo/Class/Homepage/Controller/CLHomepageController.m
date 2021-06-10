

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
#import "CLCardController.h"
#import "CLWaveViewController.h"
#import "CLBubbleViewViewController.h"
#import "CLCustomQRCodeViewController.h"
#import "CLCountdownController.h"
#import "CLLayoutController.h"
#import "CLPhotoBrowserTableViewController.h"
#import "CLTransitionController.h"
#import "CLMailboxAutoCompletionViewController.h"
#import "CLCustomTransitionViewController.h"
#import "CLLineChartViewController.h"
#import "CLInputPasswordViewController.h"
#import "CLDrawImageController.h"
#import "CLPhoneNumberVerificationController.h"
#import "CLRecordeEncodeController.h"
#import "CLHomepageModel.h"

@interface CLHomepageController ()<UITableViewDelegate,UITableViewDataSource>

/**tableview*/
@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray<CLHomepageModel *> *arrayDS;

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
    cell.textLabel.text = self.arrayDS[indexPath.row].name;
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
    Class class = [self.arrayDS objectAtIndex:indexPath.row].controllerClass;
    UIViewController *controller =  (UIViewController *)[[class alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    CLLog(@"%@", NSStringFromClass(class));
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
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"切换语言", nil) controllerClass:[CLChangeLanguageController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"修改字号", nil) controllerClass:[CLChangeFontSizeController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"断点续传", nil) controllerClass:[CLBreakPointResumeController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"UITableView 多视频播放", nil) controllerClass:[CLPlayVideoController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"UITableView 播放Gif", nil) controllerClass:[CLPlayGifController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"抽屉效果", nil) controllerClass:[CLDrawerController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"动画按钮", nil) controllerClass:[CLAnimationButtonController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"动画渐变", nil) controllerClass:[CLAnimatedGradientController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"柱状图", nil) controllerClass:[CLHistogramConroller class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"转盘菜单", nil) controllerClass:[CLWheelMenuController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"滑动动画", nil) controllerClass:[CLScrollAnimationController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"录音转码", nil) controllerClass:[CLRecordeEncodeController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"绘制头像", nil) controllerClass:[CLDrawImageController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"水平布局", nil) controllerClass:[CLLayoutController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"跑马灯", nil) controllerClass:[CLDrawMarqueeController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"评分控件", nil) controllerClass:[CLStartsController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"标签动态排布", nil) controllerClass:[CLTagsController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"自定义弹窗", nil) controllerClass:[CLPopupController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"游标卡尺", nil) controllerClass:[CLVernierCaliperController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"翻转动画", nil) controllerClass:[CLFlipController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"聊天框架", nil) controllerClass:[CLChatController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"广播轮播", nil) controllerClass:[CLBroadcastViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"折线图", nil) controllerClass:[CLLineChartViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"手机号码验证", nil) controllerClass:[CLPhoneNumberVerificationController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"自定义转场动画", nil) controllerClass:[CLCustomTransitionViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"模态交互式转场", nil) controllerClass:[CLTransitionController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"Cell倒计时", nil) controllerClass:[CLCountdownController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"图片浏览器", nil) controllerClass:[CLPhotoBrowserTableViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"邮箱自动补全", nil) controllerClass:[CLMailboxAutoCompletionViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:[NSLocalizedString(@"转子动画", nil) stringByAppendingString:@"-OC"] controllerClass:[CLRotateAnimationController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:[NSLocalizedString(@"转子动画", nil) stringByAppendingString:@"-Swift"] controllerClass:[CLRotateAnimationSwiftController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:[NSLocalizedString(@"自定义密码框", nil) stringByAppendingString:@"-OC"] controllerClass:[CLPasswordViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:[NSLocalizedString(@"自定义密码框", nil) stringByAppendingString:@"-Swift"] controllerClass:[CLPasswordViewSwiftController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"键盘密码工具条", nil) controllerClass:[CLInputPasswordViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"自定义输入工具条", nil) controllerClass:[CLInputToolbarController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"自定义输入框-限制字数", nil) controllerClass:[CLTextViewViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"卡片视图", nil) controllerClass:[CLCardController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:[NSLocalizedString(@"波浪视图", nil) stringByAppendingString:@"-OC"] controllerClass:[CLWaveViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:[NSLocalizedString(@"波浪视图", nil) stringByAppendingString:@"-Swift"] controllerClass:[CLWaveSwiftViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"气泡拖拽", nil) controllerClass:[CLBubbleViewViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"自定义二维码", nil) controllerClass:[CLCustomQRCodeViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"气泡弹框", nil) controllerClass:[CLPopoverController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"旋转图片", nil) controllerClass:[CLRotatingPictureViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"日志", nil) controllerClass:[CLLogViewController class]]];
        [_arrayDS addObject: [[CLHomepageModel alloc] initName:NSLocalizedString(@"过渡动画", nil) controllerClass:[CLTransitionViewController class]]];
    }
    return _arrayDS;
}

-(void)dealloc {
    CLLog(@"我的页面销毁了");
}

@end
