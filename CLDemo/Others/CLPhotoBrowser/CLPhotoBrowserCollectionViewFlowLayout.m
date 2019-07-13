//
//  CLPhotoBrowserCollectionViewFlowLayout.m
//  Potato
//
//  Created by AUG on 2019/6/18.
//

#import "CLPhotoBrowserCollectionViewFlowLayout.h"

@interface CLPhotoBrowserCollectionViewFlowLayout ()

@end


@implementation CLPhotoBrowserCollectionViewFlowLayout

- (void)setPage:(NSInteger)page {
    _page = page;
    if (self.pageChange) {
        self.pageChange(_page);
    }
}

-(void)prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsZero;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSInteger page = (NSInteger)(ceil(proposedContentOffset.x / self.collectionView.frame.size.width));
    self.page = page;
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint __unused)proposedContentOffset {
    return CGPointMake(self.page * self.collectionView.frame.size.width, 0);
}
@end
