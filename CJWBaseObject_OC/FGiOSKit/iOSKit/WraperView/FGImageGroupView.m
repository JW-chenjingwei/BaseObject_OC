//
//  FGImageGroupView.m
//  yulala
//
//  Created by Minimac on 2018/10/17.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "FGImageGroupView.h"
#import "FGiOSKit.h"

@interface FGImageGroupView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;  ///< Description
@end
@implementation FGImageGroupView

- (void)setupViews{
    self.columnCout = 3;
    self.space = 5;
    self.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 100);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:self.collectionView];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}



- (void)setDataSource:(NSArray *)dataSource{
    
    if (dataSource.count == 0) {
        self.jk_height = 0;
        return;
    }
    _dataSource = dataSource;
    
    [self.collectionView reloadData];
    
//    CGFloat w = (self.width - (self.columnCout - 1) * self.space - self.edgeInsets.left - self.edgeInsets.right) / self.columnCout;
//    NSInteger row = (self.dataSource.count - 1) / self.columnCout + 1;
//    
//    CGFloat height = row * w + self.space * (row - 1) + self.edgeInsets.top + self.edgeInsets.bottom;
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
}

- (CGFloat)fg_height{
    CGFloat w = (self.width - (self.columnCout - 1) * self.space - self.edgeInsets.left - self.edgeInsets.right) / self.columnCout;
    NSInteger row = (self.dataSource.count - 1) / self.columnCout + 1;
    
    CGFloat height = row * w + self.space * (row - 1) + self.edgeInsets.top + self.edgeInsets.bottom;
    return height;
}

- (void)setSpace:(CGFloat)space{
    _space = space;
    [self.collectionView reloadData];
}
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    [self.collectionView reloadData];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *image = [UIImageView new];
    image.backgroundColor = [UIColor grayColor];
    image.contentMode = 2;
    image.clipsToBounds = YES;
    [image sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row]]];
    image.frame = cell.contentView.bounds;
    [cell.contentView addSubview:image];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (self.width - (self.columnCout - 1) * self.space - self.edgeInsets.left - self.edgeInsets.right) / self.columnCout;
    return CGSizeMake(w, w);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.edgeInsets;
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.space;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.space;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectItem) {
        self.didSelectItem(indexPath);
    }
    
//    HZPhotoBrowser *photoBrowser = [HZPhotoBrowser new];
//    photoBrowser.delegate = self;
//    photoBrowser.currentImageIndex = (int)indexPath.row;
//    photoBrowser.imageCount = self.dataSource.count;
//    photoBrowser.sourceImagesContainerView = collectionView;
//    [photoBrowser show];
}

//- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
//    return [UIImage jk_imageWithColor:[UIColor grayColor]];
//}
//- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//    return [NSURL URLWithString:self.dataSource[index]];
//}
@end


