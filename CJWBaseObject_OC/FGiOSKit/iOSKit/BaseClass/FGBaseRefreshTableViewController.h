//
//  FGBaseRefreshTableViewController.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGBaseViewController.h"
#import <MJRefresh.h>
#import <UITableView+FDTemplateLayoutCell.h>

@class FGBaseTableViewCell;
/**
 *  使用该类需要注意
 1.继承该类
 2.重写self.myTableView.estimatedRowHeight = ?;
 3.注册cell,--- self.registerCellClasses = @[cellclass1, cellclass2];
 4.手动触发刷新
 5.重写请求方法
 6.当cell里的子控件需要些block回调时重载configCellSubViewsCallback:(ICBaseTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
 */

@interface FGBaseRefreshTableViewController : FGBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

/**
 当数据为空时 占位图(使用时要在刷新前创建)
 */
@property (nonatomic, strong) UIView *enptyView;

@property (nonatomic, assign) BOOL chatType;  ///< <#name#>

/**
 设置 tabler headerView (适用于约束布局的view)
 */
- (void)setupHeaderView:(UIView *)headerView;

/**
 *  配置tableview的估算行高和注册的cell
 *
 *  @param height      估算行高
 *  @param cellClasses 注册cell,如 =@[cellclass1, cellclass2];
 */
- (void)setupEstimatedRowHeight:(CGFloat)height cellClasses:(NSArray *)cellClasses;


/**
 手动触发刷新（每次会有刷新菊花）
 */
- (void)beginRefreshing;

/**
 *  手动触发刷新（没有刷新菊花，只有下拉刷新才有）
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
- (void)configCellSubViewsCallback:(FGBaseTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;


@end
