//
//  FGHeaderPageViewController.m
//  demo
//
//  Created by 陈经纬 on 2019/2/13.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "FGHeaderPageVC.h"
#import <JXPagerView.h>

#import "FGHeaderPagleListVC.h"
@interface FGHeaderPageVC ()<JXPagerViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) JXPagerView *pagingView;

@end

@implementation FGHeaderPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    self.categoryTitleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.headerHeight)];
    self.categoryTitleView.titles = self.titleArray;
    self.categoryTitleView.backgroundColor = [UIColor whiteColor];
    self.categoryTitleView.delegate = self;
    self.categoryTitleView.titleSelectedColor = [UIColor redColor];
    self.categoryTitleView.titleColor = [UIColor blackColor];
    self.categoryTitleView.titleColorGradientEnabled = YES;
    
    self.lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.lineView.indicatorLineViewColor = self.categoryTitleView.titleSelectedColor;
    
    self.categoryTitleView.indicators = @[self.lineView];
    
    _pagingView = [[JXPagerView alloc] initWithDelegate:self];
    self.pagingView.frame = CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarHeight);
    [self.view addSubview:self.pagingView];
    
    self.categoryTitleView.contentScrollView = self.pagingView.listContainerView.collectionView;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryTitleView.selectedIndex == 0);
}
#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.titleViewHeight == 0? 44 : self.titleViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryTitleView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titleArray.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    return self.listVCArray[index];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}
@end
