//
//  FGImagePickerView.h
//  lingyuangou
//
//  Created by 陈经纬 on 2018/12/6.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxGridViewFlowLayout.h"
#import "FGImagePickerHelper.h"

typedef NS_ENUM(NSInteger, FGImagePickerViewType) {
    FGImagePickerViewTypeAdd, ///< 添加图片 (图片可删除操作)
    FGImagePickerViewTypeShow, ///< 用于展示 (例如九宫格展示)
};

/*
 
 添加图片 demo
 FGImagePickerView *view = [[FGImagePickerView alloc] initWithType:FGImagePickerViewTypeAdd width:kScreenWidth];
 view.addImageUrl = @"ic_add_merchandise_pictures";
 view.column = 4;
 [self.view addSubview:view];
 [view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.offset(0);
    make.top.equalTo(self.navigationView.mas_bottom);
 }];
 
 九宫格展示 demo
 FGImagePickerView *view = [[FGImagePickerView alloc] initWithType:FGImagePickerViewTypeShow width:kScreenWidth];
 view.column = 4;
 view.isPreview = YES;
 view.dataSourceArray =[NSMutableArray arrayWithArray: @[@"http://ww3.sinaimg.cn/large/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg",@"http://ww3.sinaimg.cn/large/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"]];
 [self.view addSubview:view1];
 [view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.offset(0);
    make.top.equalTo(self.navigationView);
 }];
 
 */



@interface FGImagePickerView : UIView

/**
 初始化

 @param type 类型
 @param width 当前view的宽度
 */

- (instancetype)initWithType:(FGImagePickerViewType)type width:(CGFloat)width;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;  ///< 数据源

@property (nonatomic, strong) NSMutableArray *selectedAssets;  ///< 选中的资源 (需要用到详情资源时,才用到此数据)

@property (nonatomic, assign) NSInteger column;  ///< 列数 (默认为3列)

@property (nonatomic, assign) CGFloat space;  ///< 间距 (默认为10列)

@property (nonatomic, assign) BOOL isPreview;  ///< 是否显示预览

#pragma mark - FGImagePickerViewTypeAdd 类型 使用

@property (nonatomic, copy) NSString *addImageUrl;  ///< 自定义的添加图片 按钮的图片名

@property (nonatomic, assign) NSInteger maxImageNumber;  ///< 最多可添加多少张图片 (默认是添加9张)

/**
 重装
 */
- (void)reloadData;

@end
