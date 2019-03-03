//
//  FGImagePickerView.m
//  lingyuangou
//
//  Created by 陈经纬 on 2018/12/6.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import "FGImagePickerView.h"
#import "FGImagePickerCCell.h"
#import <PYPhotoBrowser.h>

@interface FGImagePickerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LxGridViewDelegateFlowLayout,PYPhotoBrowseViewDelegate>{
    CGFloat _itemWH;
}

@property (nonatomic, assign) FGImagePickerViewType viewType;  ///< <#Description#>
@property (nonatomic, assign) CGFloat viewWidth;  ///< <#Description#>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;

@property (nonatomic, strong) PYPhotoBrowseView *photoBroseView;  ///< 九宫格时  图片浏览器

@end

@implementation FGImagePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithType:(FGImagePickerViewType)type width:(CGFloat)width
{
    self = [super init];
    if (self) {
        _viewType = type;
        _viewWidth = width;
        _column = 3;
        _space = 10;
        
        _maxImageNumber = 9;
        _dataSourceArray = [NSMutableArray new];
        _selectedAssets = [NSMutableArray new];
        
        [self configCollectionView];
    }
    return self;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[FGImagePickerCCell class] forCellWithReuseIdentifier:@"FGImagePickerCCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
    WeakSelf
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(NSValue *_Nullable x) {
        StrongSelf
        if (x.CGSizeValue.height > 10) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(x.CGSizeValue.height);
            }];
            [self layoutIfNeeded];
        }
    }];
}

#pragma mark - get/set

- (void)setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    _dataSourceArray = dataSourceArray;
    [self.collectionView reloadData];
}

- (void)setColumn:(NSInteger)column
{
    _column = column;
    [self.collectionView reloadData];
}

- (void)setSpace:(CGFloat)space
{
    _space = space;
    [self.collectionView reloadData];
}

- (void)setAddImageUrl:(NSString *)addImageUrl
{
    _addImageUrl = addImageUrl;
    [self.collectionView reloadData];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (self.viewType) {
        case FGImagePickerViewTypeAdd:{
            
            //说明有一个添加图片的cell
            if (self.dataSourceArray.count < self.maxImageNumber) {
                return self.dataSourceArray.count + 1;
            }
            //可选择图片的最大值
            else{
                return self.maxImageNumber;
            }
        }
            break;
        case FGImagePickerViewTypeShow:{
            return self.dataSourceArray.count;
        }
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FGImagePickerCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FGImagePickerCCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;

    switch (self.viewType) {
        case FGImagePickerViewTypeAdd:{
            
            //说明有一个添加图片的cell
            if (self.dataSourceArray.count < self.maxImageNumber && self.dataSourceArray.count == indexPath.row) {
                cell.imageView.image = [UIImage imageNamed:self.addImageUrl];
                cell.deleteBtn.hidden = YES;
                cell.gifLable.hidden = YES;
            }else{
                id obj = self.dataSourceArray[indexPath.row];
                if ([obj isKindOfClass:[NSString class]]) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                    cell.asset = nil;
                }else{
                    cell.imageView.image = self.dataSourceArray[indexPath.row];
                    cell.asset = self.selectedAssets[indexPath.row];
                }
                cell.deleteBtn.hidden = NO;
            }
        }
            break;
        case FGImagePickerViewTypeShow:{
            id obj = self.dataSourceArray[indexPath.row];
            if ([obj isKindOfClass:[UIImage class]]) {
                cell.imageView.image = self.dataSourceArray[indexPath.row];
            }else {
                if ([obj hasPrefix:@"http"]) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                }else{
                    cell.imageView.image = UIImageWithName(obj);
                }
            }
            cell.asset = nil;
            cell.gifLable.hidden = YES;
            cell.deleteBtn.hidden = YES;
        }
            break;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewContrller = [collectionView jk_viewController];
    FGImagePickerCCell *cell = (FGImagePickerCCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    switch (self.viewType) {
        case FGImagePickerViewTypeAdd:{
            
            //说明有一个添加图片的cell
            if (self.dataSourceArray.count < self.maxImageNumber && self.dataSourceArray.count == indexPath.row) {
                FGImagePickerHelper *helper = [FGImagePickerHelper sharedInstance];
                helper.maxCount = self.maxImageNumber;
                helper.selectedAssets = self.selectedAssets; //设置用户选中过的图片
                WeakSelf
                [helper pushTZImagePickerControllerWithCurrentVC:viewContrller didFinishPickerPhotoHandle:^(NSArray<id> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    StrongSelf
                    self.dataSourceArray = [NSMutableArray arrayWithArray:photos];
                    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
                    [self.collectionView reloadData];
                }];
                
            }else{
                if (self.isPreview) { // preview photos or video / 预览照片或者视频
                    
                    PHAsset *asset = self.selectedAssets[indexPath.item];
                    BOOL isVideo = NO;
                    FGImagePickerHelper *helper = [FGImagePickerHelper sharedInstance];
                    
                    isVideo = asset.mediaType == PHAssetMediaTypeVideo;
                    if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && helper.allowPickingGif && !helper.allowPickingMuitlpleVideo) {
                        TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
                        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
                        vc.model = model;
                        [viewContrller presentViewController:vc animated:YES completion:nil];
                    } else if (isVideo && !helper.allowPickingMuitlpleVideo) { // perview video / 预览视频
                        TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
                        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
                        vc.model = model;
                        [viewContrller presentViewController:vc animated:YES completion:nil];
                    } else { // preview photos / 预览照片
                        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.dataSourceArray index:indexPath.item];
                        imagePickerVc.maxImagesCount = helper.maxCount;
                        imagePickerVc.allowPickingGif = helper.allowPickingGif;
                        imagePickerVc.allowPickingOriginalPhoto = helper.allowPickingOriginalPhoto;
                        imagePickerVc.allowPickingMultipleVideo = helper.allowPickingMuitlpleVideo;
                        imagePickerVc.showSelectedIndex = helper.showSelectedIndex;
                        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                            self->_dataSourceArray = [NSMutableArray arrayWithArray:photos];
                            self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                            [self->_collectionView reloadData];
                            self->_collectionView.contentSize = CGSizeMake(0, ((self->_dataSourceArray.count + 2) / 3 ) * (self->_space + self->_itemWH));
                        }];
                        [viewContrller presentViewController:imagePickerVc animated:YES completion:nil];
                    }
                }
            }
        }
            break;
        case FGImagePickerViewTypeShow:{
            
            if (self.isPreview) {
                // 1. 创建photoBroseView对象 图片浏览
                PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
                self.photoBroseView = photoBroseView;
                photoBroseView.delegate = self;
                
                id obj = self.dataSourceArray[indexPath.row];
                if ([obj isKindOfClass:[UIImage class]]) {
                    photoBroseView.images = self.dataSourceArray;
                }else {
                    if ([obj hasPrefix:@"http"]) {
                        photoBroseView.imagesURL = self.dataSourceArray;
                    }else{
                        photoBroseView.images = [self.dataSourceArray jk_map:^UIImage *(NSString *object) {
                            return UIImageWithName(object);
                        }];
                    }
                }
                
                photoBroseView.currentIndex = indexPath.row;
                photoBroseView.showFromView = cell;
                [photoBroseView show];
            }
        }
            break;
    }
}

#pragma mark - collectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =  (self.viewWidth - (self.space * (self.column + 1)))/self.column;
    _itemWH = width;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(self.space, self.space, self.space, self.space);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.space;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.dataSourceArray.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.dataSourceArray.count && destinationIndexPath.item < self.dataSourceArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.dataSourceArray[sourceIndexPath.item];
    [self.dataSourceArray removeObjectAtIndex:sourceIndexPath.item];
    [self.dataSourceArray insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark -  PYPhotoBrowseViewDelegate
/**
 * 图片浏览将要隐藏时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willHiddenWithImages:(NSArray *)images index:(NSInteger)index
{
    FGImagePickerCCell *hiddenCell = (FGImagePickerCCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    self.photoBroseView.hiddenToView = hiddenCell;
}

//- (NSMutableArray *)getUrlsArr
//{
//    NSMutableArray *arr = [NSMutableArray array];
//    for (id obj in _selectedMixPhotos) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            [arr addObject:obj];
//        }
//    }
//    return arr;
//}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= self.dataSourceArray.count) {
        [self.dataSourceArray removeObjectAtIndex:sender.tag];
        [self.dataSourceArray removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [self.dataSourceArray removeObjectAtIndex:sender.tag];
    [self.selectedAssets removeObjectAtIndex:sender.tag];
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}
@end
