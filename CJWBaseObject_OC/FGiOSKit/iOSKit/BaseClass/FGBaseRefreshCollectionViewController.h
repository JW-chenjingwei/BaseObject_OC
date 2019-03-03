//
//  FGBaseRefreshCollectionViewController.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGBaseCollectionViewCell.h"
#import <MJRefresh.h>

@interface FGBaseRefreshCollectionViewController : FGBaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

- (void)setupLayout:(UICollectionViewLayout *)layout registerCells:(NSArray *)cells;

/**
 为了清空数据源后,是否加入特殊样式的cell而使用.
 */
- (void)didClearDataArr;

/**
 *  手动触发刷新
 */
- (void)beginRefresh;

/**
 *  必须重写该方法，请求列表数据
 *
 */
- (void)requestDataWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure;

/**
 *  当cell里的子控件需要些block回调时重载该方法
 *
 */
- (void)configCellSubViewsCallback:(FGBaseCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 当数据为空时 占位图(使用时要在刷新前创建)
 */
@property (nonatomic, strong) UIView *enptyView;

@end
