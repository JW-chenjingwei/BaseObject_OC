//
//  FGHeaderPageViewController.h
//  demo
//
//  Created by 陈经纬 on 2019/2/13.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import "FGHeaderPagleListVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface FGHeaderPageVC : FGBaseViewController
@property (nonatomic, copy) NSArray <NSString *>*titleArray;  ///< ///< 必传，标题数组
@property (nonatomic, strong) NSArray <FGHeaderPagleListVC *>*listVCArray;  ///< 必传，分页列表控制器，需要继承FGHeaderPagleListVC

@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;  ///< <#Description#>

@property (nonatomic, assign) CGFloat titleViewHeight;  ///< 标题菜单栏高度，默认44
@property (nonatomic, strong) UIView *headerView;  ///< <#Description#>
@property (nonatomic, assign) CGFloat headerHeight;  ///< <#name#>
@end

NS_ASSUME_NONNULL_END
