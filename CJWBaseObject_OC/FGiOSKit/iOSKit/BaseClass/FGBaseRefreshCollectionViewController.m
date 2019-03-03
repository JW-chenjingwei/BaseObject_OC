//
//  FGBaseRefreshCollectionViewController.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGBaseRefreshCollectionViewController.h"
#import "FGRefreshHeader.h"
#import "FGBaseNavigationController.h"
#define kOffset  1
@interface FGBaseRefreshCollectionViewController ()

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) UICollectionViewLayout *myLayout;
@property (nonatomic, strong) NSArray *registerCellClasses;

@end

@implementation FGBaseRefreshCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offset = kOffset;
    self.dataSourceArr = [NSMutableArray array];

}

- (void)setupLayout:(UICollectionViewLayout *)layout registerCells:(NSArray *)cells
{
    self.myLayout = layout;
    self.registerCellClasses = cells;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.view addSubview:self.myCollectionView];
    
    //注册cell
    for (Class objClass in cells) {
        if ([objClass isSubclassOfClass:[FGBaseCollectionViewCell class]]) {
            [self.myCollectionView registerClass:objClass forCellWithReuseIdentifier:NSStringFromClass(objClass)];
        }
    }
    
    WeakSelf
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        if ([self.myCollectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
     }
}

- (void)setHeaderRefreshView
{
    // 下拉刷新
//    FGRefreshHeader *header = [FGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.myCollectionView.mj_header = header;
}

- (void)beginRefresh
{
    WeakSelf
    [self.myCollectionView.mj_footer endRefreshing];
    [self getListDataSuccess:^(BOOL isNoMoreData) {
        StrongSelf
        [self.myCollectionView.mj_header endRefreshing];
        if (isNoMoreData) {
            //无数据
            [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            //               [XJEmptyView addEmptyWithStyle:XJEmptyViewStyleCommon onView:self.view position:XJEmptyViewPositionCenter clickCallBack:nil];
        }else{
            [self.myCollectionView.mj_footer resetNoMoreData];
            [self.myCollectionView reloadData];
        }
        
    } failure:^(NSString *msg) {
        StrongSelf
        [self.myCollectionView.mj_header endRefreshing];
        [self.myCollectionView.mj_footer endRefreshing];
        //            [XJNetworkManager sharedInstance].isNetworkNotReachability = YES;
    } isRefresh:YES];
}

- (void)setFooterRefreshView
{
    WeakSelf
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.myCollectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新  MJRefreshBackNormalFooter
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        StrongSelf
        [self.myCollectionView.mj_header endRefreshing];
        [self getListDataSuccess:^(BOOL isNoMoreData) {
            StrongSelf
            if (isNoMoreData) {
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.myCollectionView.mj_footer endRefreshing];
                [self.myCollectionView reloadData];
            }
        } failure:^(NSString *msg) {
            StrongSelf
            [self.myCollectionView.mj_header endRefreshing];
            [self.myCollectionView.mj_footer endRefreshing];
            //            [AZNotification showNotificationWithTitle:msg controller:self notificationType:AZNotificationTypeError];
        } isRefresh:NO];
    }];
    self.myCollectionView.mj_footer.automaticallyChangeAlpha = YES;
    self.myCollectionView.mj_footer.automaticallyHidden = YES;
    
}


- (void)getListDataSuccess:(void (^)(BOOL isNoMoreData))success
                   failure:(void (^)(NSString *msg))failure
                 isRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        self.offset = kOffset;
    }
    
    
    [self requestDataWithOffset:self.offset success:^(NSArray *dataArr) {
  
        if (success) {
            if (!IsEmpty(dataArr)) {
                
                //当连续调用两次刷新时,如果这里没有删除数组,会重复出现数据
                if (isRefresh) {
                    [self.dataSourceArr removeAllObjects];
                    [self didClearDataArr];
                }
                
                [self.dataSourceArr addObjectsFromArray:dataArr];
                self.offset ++;
            }else{
                [self didClearDataArr];
            }
            
            success(IsEmpty(dataArr)?YES:NO);
            
            if (isRefresh && self.enptyView) {
                
                [self.enptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(kScreenWidth);
                }];
                CGSize size = [self.enptyView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                self.enptyView.frame = CGRectMake(0, 0, kScreenWidth, size.height);
                
                

                if(IsEmpty(dataArr) && IsEmpty(self.dataSourceArr)){
                    [self.bgScrollView addSubview:self.enptyView];
                }

            }

        }
        
    } failure:failure];
}

- (void)didClearDataArr
{
    [self.myCollectionView reloadData];
}

//数据请求
- (void)requestDataWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure
{
    
    
}

#pragma mark - dataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FGBaseCollectionViewCell *cell;
    for (Class objClass in self.registerCellClasses) {
        if ([objClass isSubclassOfClass:[FGBaseCollectionViewCell class]]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(objClass) forIndexPath:indexPath];
            if (indexPath.item < self.dataSourceArr.count) {
                [cell configWithModel:self.dataSourceArr[indexPath.item]];
                if ([self respondsToSelector:@selector(configCellSubViewsCallback:indexPath:)]) {
                    [self configCellSubViewsCallback:cell indexPath:indexPath];
                }
            }
        }
    }
    return cell;
}

- (void)configCellSubViewsCallback:(FGBaseCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    
}

//#pragma mark - flowlayout
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    WeakSelf
//    for (Class objClass in self.registerCellClasses) {
//        if ([objClass isSubclassOfClass:[FGBaseCollectionViewCell class]]) {
//            return [collectionView ar_sizeForCellWithIdentifier:NSStringFromClass(objClass)
//                                                      indexPath:indexPath
//                                                  configuration:^(__kindof FGBaseCollectionViewCell * cell) {
//                                                      StrongSelf
//                                                      if (indexPath.item < self.dataSourceArr.count) {
//                                                          [cell configCCellWithModel:self.dataSourceArr[indexPath.item]];
//                                                      }
//                                                  }];
////            return [collectionView ar_sizeForCellWithIdentifier:NSStringFromClass(objClass) indexPath:indexPath fixedWidth:kScreenWidth/2 configuration:^(__kindof FGBaseCollectionViewCell *cell) {
////                StrongSelf
////                if (indexPath.item < self.dataSourceArr.count) {
////                    [cell configCCellWithModel:self.dataSourceArr[indexPath.item]];
////                }
////            }];
//        }
//    }
//    return CGSizeZero;
//}

@end
