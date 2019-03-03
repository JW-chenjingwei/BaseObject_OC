//
//  FGPageViewController.h
//  demo
//
//  Created by 陈经纬 on 2019/2/12.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import "FGPageListVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface FGPageVC : FGBaseViewController
@property (nonatomic, copy) NSArray <NSString *>*titleArray;  ///< 必传，标题数组
@property (nonatomic, strong) NSArray <FGPageListVC *>*listVCArray;  ///< 必传，分页列表控制器，需要继承FGPageListVC

@property (nonatomic, assign) CGFloat titleViewHeight;  ///< 标题菜单栏高度默认44

@property (nonatomic, strong)JXCategoryTitleView  *categoryTitleView;  ///< 菜单栏
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;  ///< 下划线

@end

NS_ASSUME_NONNULL_END
