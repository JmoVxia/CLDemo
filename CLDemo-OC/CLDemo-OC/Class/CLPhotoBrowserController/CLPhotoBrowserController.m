//
//  CLPhotoBrowserController.m
//  CLDemo
//
//  Created by AUG on 2019/7/13.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import "CLPhotoBrowserController.h"
#import "CLPhotoCollectionViewCell.h"
#import "CLPhotoBrowser.h"
#import "Masonry.h"

@interface CLPhotoBrowserController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *imageDataArray;

@property (nonatomic, strong) NSArray<NSURL *> *urlDataArray;

///浏览器
@property (nonatomic, strong) CLPhotoBrowser *photoBrowser;

@end

@implementation CLPhotoBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    if (self.isImgae) {
        // 异步子线程
        self.imageDataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 13; i++) {
            [self.imageDataArray addObject:[UIImage imageNamed:@"placeholder"]];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *array = @[
//                               [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"localGifImage0" ofType:@"gif"]]],
                               [UIImage imageNamed:@"localImage0.jpeg"],
                               [UIImage imageNamed:@"localImage1.jpeg"],
                               [UIImage imageNamed:@"localImage2.jpeg"],
                               [UIImage imageNamed:@"localImage3.jpeg"],
                               [UIImage imageNamed:@"localLongImage1.jpg"],
//                               [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"localGifImage1" ofType:@"gif"]]],
                               [UIImage imageNamed:@"localImage4.jpeg"],
                               [SDAnimatedImage imageNamed:@"localGifImage1.gif"],
                               [UIImage imageNamed:@"localImage5.jpeg"],
                               [UIImage imageNamed:@"localLongImage0.jpg"],
                               [UIImage imageNamed:@"localBigImage0.jpeg"],
                               [SDAnimatedImage imageNamed:@"localGifImage0.gif"],
                               [UIImage imageNamed:@"localImage6.jpeg"],
                               [UIImage imageNamed:@"localImage7.jpeg"],
                               [UIImage imageNamed:@"localImage8.jpeg"],
                               [UIImage imageNamed:@"localImage9.jpeg"],
                               ];
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageDataArray removeAllObjects];
                [self.imageDataArray addObjectsFromArray:array];
                [self.collectionView reloadData];
            });
        });
    }else {
        self.urlDataArray = @[
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118772581&di=29b994a8fcaaf72498454e6d207bc29a&imgtype=0&src=http%3A%2F%2Fimglf2.ph.126.net%2F_s_WfySuHWpGNA10-LrKEQ%3D%3D%2F1616792266326335483.gif"],
                              [NSURL URLWithString:@"http://c.hiphotos.baidu.com/baike/pic/item/d1a20cf431adcbefd4018f2ea1af2edda3cc9fe5.jpg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118984884&di=7c73ddf9d321ef94a19567337628580b&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201506%2F07%2F20150607185100_XQvYT.jpeg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118823131&di=aa588a997ac0599df4e87ae39ebc7406&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F08%2F20160508154653_AQavc.png"],
                              [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=722693321,3238602439&fm=27&gp=0.jpg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118892596&di=5e8f287b5c62ca0c813a548246faf148&imgtype=0&src=http%3A%2F%2Fwx1.sinaimg.cn%2Fcrop.0.0.1080.606.1000%2F8d7ad99bly1fcte4d1a8kj20u00u0gnb.jpg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118914981&di=7fa3504d8767ab709c4fb519ad67cf09&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201410%2F05%2F20141005221124_awAhx.jpeg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118934390&di=fbb86678336593d38c78878bc33d90c3&imgtype=0&src=http%3A%2F%2Fi2.hdslb.com%2Fbfs%2Farchive%2Fe90aa49ddb2fa345fa588cf098baf7b3d0e27553.jpg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524118984884&di=7c73ddf9d321ef94a19567337628580b&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201506%2F07%2F20150607185100_XQvYT.jpeg"],
                              
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localBigImage0" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localGifImage0" ofType:@"gif"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage1" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage0" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localLongImage1" ofType:@"jpg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage7" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage6" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage5" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localGifImage1" ofType:@"gif"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage4" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localLongImage0" ofType:@"jpg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage8" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage3" ofType:@"jpeg"]],
                              [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"localImage2" ofType:@"jpeg"]],
                              ];
        [self.collectionView reloadData];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isImgae ? self.imageDataArray.count : self.urlDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CLPhotoCollectionViewCell" forIndexPath:indexPath];
    if (self.isImgae) {
        cell.image = self.imageDataArray[indexPath.row];
    }else {
        cell.url = self.urlDataArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    if (self.isImgae) {
        [self.photoBrowser showPhotoBrowserWithImages:self.imageDataArray index:indexPath.row zoomView:^UIView * _Nonnull(NSInteger index) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            return [strongSelf zoomView:index];
        }];
    }else {
        [self.photoBrowser showPhotoBrowserWithImageUrls:self.urlDataArray placeholder:[UIImage imageNamed:@"placeholder"] index:indexPath.row zoomView:^UIView * _Nonnull(NSInteger index) {
            __typeof(&*weakSelf) strongSelf = weakSelf;
            return [strongSelf zoomView:index];
        }];
    }
}

- (UIView *)zoomView:(NSInteger)index {
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    NSArray<NSIndexPath *> *indexPathArray = [self.collectionView indexPathsForVisibleItems];
    CLPhotoCollectionViewCell *cell;
    if (![indexPathArray containsObject:path]) {
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [self.collectionView layoutIfNeeded];
    }
    cell = (CLPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:path];
    return cell.imageView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat padding = 5;
        CGFloat cellLength = ([UIScreen mainScreen].bounds.size.width - padding * 4) / 3;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(cellLength, cellLength);
        layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
        layout.minimumLineSpacing = padding;
        layout.minimumInteritemSpacing = padding;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[CLPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"CLPhotoCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (CLPhotoBrowser *) photoBrowser {
    if (_photoBrowser == nil) {
        _photoBrowser = [[CLPhotoBrowser alloc] init];
    }
    return _photoBrowser;
}
@end
