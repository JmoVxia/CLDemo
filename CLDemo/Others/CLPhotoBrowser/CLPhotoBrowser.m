//
//  CLPhotoBrowser.m
//  Potato
//
//  Created by AUG on 2019/6/17.
//

#import "CLPhotoBrowser.h"
#import "CLPhotoBrowserTransitioningDelegate.h"
#import "CLPhotoBrowserCollectionViewFlowLayout.h"
#import "CLPhotoBrowserCollectionViewCell.h"
#import "CLPhotoBrowserImageScaleHelper.h"
#import <Masonry/Masonry.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import <SDWebImage/SDWebImage.h>

@interface CLPhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource>

///转场代理
@property (nonatomic, strong) CLPhotoBrowserTransitioningDelegate *transitioning;
///collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
///layout
@property (nonatomic, strong) CLPhotoBrowserCollectionViewFlowLayout *layout;
///页码
@property (nonatomic, strong) UILabel *indexLabel;
///图片URL数组
@property (nonatomic, strong) NSArray<NSURL *> *imageUrls;
///图片数组
@property (nonatomic, strong) NSArray<UIImage *> *images;
///占位图片数组
@property (nonatomic, strong) NSArray<UIImage *> *placeholderImages;
///固定占位图片
@property (nonatomic, strong) UIImage *placeholder;
///动画View
@property (nonatomic, copy) UIView *(^zoomView)(NSInteger index);
///大图位置
@property (nonatomic, assign) CGRect bigImageFrame;

@end

@implementation CLPhotoBrowser

- (void)showPhotoBrowserWithImageUrls:(nonnull NSArray<NSURL *> *)imageUrls placeholder:(nonnull UIImage *)placeholder index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView {
    [self showPhotoBrowserWithImages:nil imageUrls:imageUrls placeholderImages:nil placeholder:placeholder index:index zoomView:zoomView];
}

- (void)showPhotoBrowserWithImageUrls:(nonnull NSArray<NSURL *> *)imageUrls placeholderImages:(nonnull NSArray<UIImage *> *)placeholderImages index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView {
    [self showPhotoBrowserWithImages:nil imageUrls:imageUrls placeholderImages:placeholderImages placeholder:nil index:index zoomView:zoomView];
}

- (void)showPhotoBrowserWithImages:(nonnull NSArray<UIImage *> *)images index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView {
    [self showPhotoBrowserWithImages:images imageUrls:nil placeholderImages:nil placeholder:nil index:index zoomView:zoomView];
}

- (void)showPhotoBrowserWithImages:(nullable NSArray<UIImage *> *)images imageUrls:(nullable NSArray<NSURL *> *)imageUrls placeholderImages:(nullable NSArray<UIImage *> *)placeholderImages placeholder:(nullable UIImage *)placeholder index:(NSInteger)index zoomView:(nonnull UIView *(^)(NSInteger index))zoomView {
    self.images = images;
    self.imageUrls = imageUrls;
    self.placeholderImages = placeholderImages;
    self.placeholder = placeholder;
    self.zoomView = zoomView;
    UIViewController *controller = [[[[UIApplication  sharedApplication] delegate] window] rootViewController];
    [controller presentViewController:self animated:YES completion:nil];
    self.layout.page = index;
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    [UIView animateWithDuration:0 animations:^{
        [self.collectionView reloadData];
    }completion:^(BOOL finished) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.transitioningDelegate = self.transitioning;
        [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self mas_makeConstraints];
}
- (void)initUI {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.indexLabel];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)mas_makeConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_equalTo(20);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images ? self.images.count : self.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCell:collectionView indexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CLPhotoBrowserCollectionViewCell *photoBrowsercell = (CLPhotoBrowserCollectionViewCell *)cell;
    [photoBrowsercell reload];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.view bounds].size;
}
- (CLPhotoBrowserCollectionViewCell *)dequeueReusableCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    CLPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CLPhotoBrowserCollectionViewCellIdentifier" forIndexPath:indexPath];
    if (self.images) {
        UIImage *image = [self.images objectAtIndex:indexPath.row];
        [cell setImage:image];
    }else {
        NSURL *imageUrl = [self.imageUrls objectAtIndex:indexPath.row];
        UIImage *placeholderImage = self.placeholder ? : [self.placeholderImages objectAtIndex:indexPath.row];
        [cell setImageUrl:imageUrl placeholderImage:placeholderImage];
    }
    __weak __typeof(self) weakSelf = self;
    cell.singleTap = ^(CGRect imageViewFrame) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.bigImageFrame = imageViewFrame;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    cell.alphaChange = ^(CGFloat alpha) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.transitioning.alpha = alpha;
    };
    return cell;
}
//MARK: - JmoVxia---小图片Frame
- (CGRect)smallImageFrame {
    UIView *view = self.zoomView(self.layout.page);
    return [view.superview convertRect:view.frame toView:[[UIApplication sharedApplication].delegate window]];
}
//MARK: - JmoVxia---当前图片url
- (NSURL *)currentImageUrl {
    NSURL *imageUrl = [self.imageUrls objectAtIndex:self.layout.page];
    return imageUrl;
}
//MARK: - JmoVxia---当前图片
- (UIImage *)currentImage {
    return [self.images objectAtIndex:self.layout.page];
}
//MARK: - JmoVxia---占位图
- (UIImage *)currentPlaceholderImage {
    return self.placeholder ? : [self.placeholderImages objectAtIndex:self.layout.page];
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView.collectionViewLayout invalidateLayout];

    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    CLPhotoBrowserCollectionViewCell *cell = (CLPhotoBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.hidden = YES;
    SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] init];
    [self.view addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = [self.view convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    imageView.image = cell.imageView.image;
    
    [cell reload];
    
    CGRect toFrame = [CLPhotoBrowserImageScaleHelper calculateScaleFrameWithImageSize:cell.imageView.image.size maxSize:size offset:NO];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        imageView.frame = toFrame;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        cell.hidden = NO;
        [imageView removeFromSuperview];
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//MARK: - JmoVxia---懒加载
- (CLPhotoBrowserTransitioningDelegate *) transitioning {
    if (_transitioning == nil) {
        _transitioning = [[CLPhotoBrowserTransitioningDelegate alloc] init];
    }
    return _transitioning;
}
- (CLPhotoBrowserCollectionViewFlowLayout *) layout {
    if (_layout == nil) {
        _layout = [[CLPhotoBrowserCollectionViewFlowLayout alloc] init];
        __weak __typeof(self) weakSelf = self;
        _layout.pageChange = ^(NSInteger page) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            strongSelf.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (page + 1), strongSelf.images ? strongSelf.images.count : strongSelf.imageUrls.count];
        };
    }
    return _layout;
}
-(UICollectionView *) collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [_collectionView registerClass:[CLPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"CLPhotoBrowserCollectionViewCellIdentifier"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _collectionView;
}
- (UILabel *) indexLabel {
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:18];
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}
@end
