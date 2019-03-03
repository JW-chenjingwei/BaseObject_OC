//
//  FGBaseRefreshTableViewController.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGBaseRefreshTableViewController.h"
#import "FGBaseTableViewCell.h"
#import "FGRefreshHeader.h"
#import "FGBaseNavigationController.h"

#define kOffset  1
@interface FGBaseRefreshTableViewController ()

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSArray *registerCellClasses;

@end

@implementation FGBaseRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.offset = kOffset;
    
    self.dataSourceArr = [NSMutableArray new];
    [self.view addSubview:self.myTableView];
    
    UIView *footer = [UIView new];
    self.myTableView.tableFooterView = footer;
    
    
    WeakSelf
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.right.bottom.offset(0);
        
        if (self.parentViewController &&  [self.parentViewController isMemberOfClass:[FGBaseNavigationController class]]) {
            make.top.equalTo(self.navigationView.mas_bottom);
        }else{
            make.top.offset(0);
        }
    }];

    
    [self setHeaderRefreshView];
    
    [self setFooterRefreshView];
    
     if (@available(iOS 11.0, *)) {
        if ([self.myTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
     }
    
    
    
}

#pragma mark - public
- (void)setRegisterCellClasses:(NSArray *)registerCellClasses
{
    _registerCellClasses = registerCellClasses;
    
    //注册cell
    for (Class objClass in registerCellClasses) {
        if ([objClass isSubclassOfClass:[FGBaseTableViewCell class]]) {
            [self.myTableView registerClass:objClass forCellReuseIdentifier:NSStringFromClass(objClass)];
        }
    }
}

- (void)setupEstimatedRowHeight:(CGFloat)height cellClasses:(NSArray *)cellClasses
{
    self.myTableView.estimatedRowHeight = height;
    self.registerCellClasses = cellClasses;
}

- (void)configCellSubViewsCallback:(FGBaseTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    
}

/**
 设置 tabler headerView (适用于约束布局的view)
 */
- (void)setupHeaderView:(UIView *)headerView
{
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, size.height);
    self.myTableView.tableHeaderView = headerView;
}


#pragma mark - refresh(刷新)
- (void)setHeaderRefreshView
{
    // 下拉刷新
//    FGRefreshHeader *header = [FGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myTableView.mj_header = header;
}

- (void)beginRefreshing{
    [self.myTableView.mj_header beginRefreshing];
}
- (void)beginRefresh
{
    
    WeakSelf
    [self.myTableView.mj_footer endRefreshing];
    [self getListDataSuccess:^(BOOL isNoMoreData) {
        StrongSelf
        [self.myTableView.mj_header endRefreshing];
        if (isNoMoreData) {
            //无数据
            [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            //               [XJEmptyView addEmptyWithStyle:XJEmptyViewStyleCommon onView:self.view position:XJEmptyViewPositionCenter clickCallBack:nil];
        }else{
            [self.myTableView.mj_footer resetNoMoreData];
        }
        [self.myTableView reloadData];
    } failure:^(NSString *msg) {
        StrongSelf
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        //            [XJNetworkManager sharedInstance].isNetworkNotReachability = YES;
    } isRefresh:YES];
}

- (void)setFooterRefreshView
{
    WeakSelf
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新  MJRefreshBackNormalFooter
    
   MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        StrongSelf
        [self.myTableView.mj_header endRefreshing];
        [self getListDataSuccess:^(BOOL isNoMoreData) {
            StrongSelf
            if (isNoMoreData) {
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.myTableView.mj_footer endRefreshing];
                [self.myTableView reloadData];
            }
        } failure:^(NSString *msg) {
            StrongSelf
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
            //            [AZNotification showNotificationWithTitle:msg controller:self notificationType:AZNotificationTypeError];
        } isRefresh:NO];
    }];
    footer.stateLabel.hidden = self.chatType;
    self.myTableView.mj_footer = footer;
    self.myTableView.mj_footer.automaticallyChangeAlpha = YES;
    self.myTableView.mj_footer.automaticallyHidden = YES;
    
    
}

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _myTableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
//        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.estimatedRowHeight = 60;//根据需要重写
        
        //此方法TableView的分割线顶边
        if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
        }

        if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _myTableView;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGBaseTableViewCell *cell;
    for (Class objClass in self.registerCellClasses) {
        if ([objClass isSubclassOfClass:[FGBaseTableViewCell class]]) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(objClass)];
            if (indexPath.row < self.dataSourceArr.count) {
                [cell configWithModel:self.dataSourceArr[indexPath.row]];
                [self configCellSubViewsCallback:cell indexPath:indexPath];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    for (Class objClass in self.registerCellClasses) {
        if ([objClass isSubclassOfClass:[FGBaseTableViewCell class]]) {
        
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(objClass)  cacheByIndexPath:indexPath configuration:^(FGBaseTableViewCell *cell) {
                StrongSelf
                if (indexPath.row < self.dataSourceArr.count) {
                    [cell configWithModel:self.dataSourceArr[indexPath.row]];
                }
            }];
        }
    }
    return 0;
}

//此方法TableView的分割线顶边
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - private

- (void)getListDataSuccess:(void (^)(BOOL isNoMoreData))success
                   failure:(void (^)(NSString *msg))failure
                 isRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        self.offset = kOffset;
    }
    
    WeakSelf
    [self requestDataWithOffset:self.offset success:^(NSArray *dataArr) {
        //当连续调用两次刷新时,如果这里没有删除数组,会重复出现数据
        StrongSelf
        if (isRefresh) {
            @synchronized (@"isRefresh") {
                [self.dataSourceArr removeAllObjects];
            }
            
        }
        if (!IsEmpty(dataArr)) {
            
            @synchronized (@"addObjectsFromArray") {
                [self.dataSourceArr addObjectsFromArray:dataArr];
                self.offset ++;
            }
        }
        
        if (success) {
            success(IsEmpty(dataArr)?YES:NO);
            
            //添加占位图
            if (isRefresh && self.enptyView) {
                //计算 frame
                [self.enptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(kScreenWidth);
                }];
                CGSize size = [self.enptyView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                
                UIView *footerView = [UIView new];
                [footerView addSubview:self.enptyView];
                [self.enptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.offset(0);
                }];
                footerView.frame = CGRectMake(0, 0, kScreenWidth, size.height);
                self.myTableView.tableFooterView = IsEmpty(dataArr) ? footerView : [UIView new];
            }
        }
        
    } failure:failure];
}



//数据请求
- (void)requestDataWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure
{
    
    
}



@end
