//
//  FGPageViewController.m
//  demo
//
//  Created by 陈经纬 on 2019/2/12.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "FGPageVC.h"
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>
#import "FGPageListVC.h"
@interface FGPageVC ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;  ///< <#Description#>
@end

@implementation FGPageVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    CGFloat height = self.titleViewHeight == 0? 44: self.titleViewHeight;
    self.categoryTitleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.bounds.size.width, height)];
    self.categoryTitleView.titles = self.titleArray;
    self.categoryTitleView.backgroundColor = [UIColor whiteColor];
    self.categoryTitleView.delegate = self;
    self.categoryTitleView.titleSelectedColor = [UIColor redColor];
    self.categoryTitleView.titleColor = [UIColor blackColor];
    self.categoryTitleView.titleColorGradientEnabled = YES;
    self.categoryTitleView.delegate = self;
    [self.view addSubview:self.categoryTitleView];
    
    //指示器
    self.lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.lineView.indicatorLineViewColor = self.categoryTitleView.titleSelectedColor;
    self.lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    self.categoryTitleView.indicators = @[self.lineView];
    

    self.listContainerView = [[JXCategoryListContainerView alloc] initWithParentVC:self delegate:self];
    CGFloat y = self.categoryTitleView.frame.size.height + kNavBarHeight;
    self.listContainerView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    [self.view addSubview:self.listContainerView];
    self.categoryTitleView.contentScrollView = self.listContainerView.scrollView;

}


#pragma mark - JXCategoryViewDelegate
//为什么会把选中代理分为三个，因为有时候只关心点击选中的，有时候只关心滚动选中的，有时候只关心选中。所以具体情况，使用对应方法。
/**
 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
 
 @param categoryView categoryView description
 @param index 选中的index
 */
//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
//    
//}

/**
 点击选中的情况才会调用该方法
 
 @param categoryView categoryView description
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

/**
 滚动选中的情况才会调用该方法
 
 @param categoryView categoryView description
 @param index 选中的index
 */
//- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{
//
//}


/**
 只有点击的选中才会调用！！！
 因为用户点击，contentScrollView即将过渡到目标index的位置。内部默认实现`[self.contentScrollView setContentOffset:CGPointMake(targetIndex*self.contentScrollView.bounds.size.width, 0) animated:YES];`。如果实现该代理方法，以自定义实现为准。比如将animated设置为NO，点击切换时无需滚动效果。类似于今日头条APP。
 
 @param categoryView categoryView description
 @param index index description
 */
//- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index{
//
//}

/**
 正在滚动中的回调
 
 @param categoryView categoryView description
 @param leftIndex 正在滚动中，相对位置处于左边的index
 @param rightIndex 正在滚动中，相对位置处于右边的index
 @param ratio 从左往右计算的百分比
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}


#pragma mark - JXCategoryListContainerViewDelegate
/**
 返回list的数量
 
 @param listContainerView 列表的容器视图
 @return list的数量
 */
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView{
    return self.categoryTitleView.titles.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXCategoryListContentViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXCategoryListContentViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXCategoryListContentViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！
 
 @param listContainerView 列表的容器视图
 @param index 目标下标
 @return 新的遵从JXCategoryListContentViewDelegate协议的list实例
 */
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index{
    return self.listVCArray[index];
}
@end
