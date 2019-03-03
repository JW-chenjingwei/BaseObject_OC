//
//  FGImagePickerHelper.h
//  lingyuangou
//
//  Created by 陈经纬 on 2018/12/5.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TZImagePickerController.h>

/**
 注意事项: 使用时发现显示的是英文 ,需要在project中的info文件中的Locallzations加上Chinese(Simplified)
 */



@interface FGImagePickerHelper : NSObject

+ (instancetype)sharedInstance;

//调用相机时
@property (nonatomic, assign) BOOL showTakePhoto;  ///< 允许拍照 (默认YES)
@property (nonatomic, assign) BOOL showTakeVideo;  ///< 允许拍视频
@property (nonatomic, assign) BOOL sortAscending;  ///< 照片排列按修改时间升序

@property (nonatomic, assign) BOOL allowPickingVideo;  ///< 允许选择视频
@property (nonatomic, assign) BOOL allowPickingImage;  ///< 允许选择图片 (默认YES)
@property (nonatomic, assign) BOOL allowPickingGif;  ///< 允许选择Gif
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;  ///< 允许选择原图
@property (nonatomic, assign) BOOL allowCrop;  ///< 照片允许裁剪
@property (nonatomic, assign) BOOL needCircleCrop;  ///< 允许圆形裁剪
@property (nonatomic, assign) BOOL showSelectedIndex;  ///< 允许是否显示图片序号
@property (nonatomic, assign) BOOL allowPickingMuitlpleVideo;  ///< 允许是否可以多选视频

@property (nonatomic, assign) NSInteger maxCount;  ///< 照片最大可选张数，设置为1即为单选模式 (默认为1)
@property (nonatomic, assign) NSInteger columnNumber;  ///< 照片展示列数 (默认为4)

@property (nonatomic, strong) UIViewController *currentVC;  ///< 调用此方法时的当前控制器

@property (nonatomic, strong) NSMutableArray *selectedPhotos;  ///< <#Description#>
@property (nonatomic, strong) NSMutableArray *selectedAssets;  ///< <#Description#>

@property (nonatomic, strong) TZImagePickerController *tzImagePickerController;  ///< pushTZImagePickerController 时选择了视频,需要用此属性调用自带的视频回调方法

/**
 调用相机

 @param currentVC 当前控制器
 */
- (void)takePhotoWithCurrentVC:(UIViewController *)currentVC didFinishPickerPhotoHandle:(void (^) (NSArray<id > *photos,NSArray *assets, BOOL isSelectOriginalPhoto))didFinishPickerPhotoHandle;

/**
 从相册选择照片

 @param currentVC 当前控制器
 @param didFinishPickerPhotoHandle 选择后的回调
 @return 返回选择器
 */
- (TZImagePickerController *)pushTZImagePickerControllerWithCurrentVC:(UIViewController *)currentVC didFinishPickerPhotoHandle:(void (^) (NSArray<id > *photos,NSArray *assets, BOOL isSelectOriginalPhoto))didFinishPickerPhotoHandle;


/**
 展示 sheet 选择调用 相机 还是 相册选择

 @param currentVC 当前控制器
 @param didFinishPickerPhotoHandle 选择后的回调
 */
- (void)showSheetWithCurrentVC:(UIViewController *)currentVC didFinishPickerPhotoHandle:(void (^) (NSArray<id > *photos,NSArray *assets, BOOL isSelectOriginalPhoto))didFinishPickerPhotoHandle;

@end
