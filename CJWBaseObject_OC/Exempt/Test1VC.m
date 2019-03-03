//
//  Test1VC.m
//  CJWBaseObject_OC
//
//  Created by 陈经伟 on 2019/3/2.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "Test1VC.h"
#import "FGPageVC.h"
#import "TestTableViewCell.h"
#import "FGHeaderPageVC.h"
@implementation Test1VC
- (void)viewDidLoad{
    [super viewDidLoad];

    [self.navigationView setTitle:@"分页视图"];
    
    [self setupEstimatedRowHeight:44 cellClasses:@[[TestTableViewCell class]]];
    [self beginRefreshing];
}

- (void)requestDataWithOffset:(NSInteger)offset success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    success(@[@"带头部分页视图",@"分页视图"]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2) {
        FGPageVC *vc = [FGPageVC new];
        [vc.navigationView setTitle:@"分页列表"];
        vc.titleArray = @[@"iphonex",@"iphonexs",@"iphonexs Max"];
        vc.listVCArray = @[[FGPageListVC new],[FGPageListVC new],[FGPageListVC new]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        FGHeaderPageVC *vc = [FGHeaderPageVC new];
        [vc.navigationView setTitle:@"带头部分页列表"];
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor redColor];
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
        vc.headerView = headerView;
        vc.headerHeight = 200;
        vc.titleArray = @[@"能力", @"爱好", @"队友"];
        vc.categoryTitleView.titleSelectedColor = [UIColor redColor];
        vc.categoryTitleView.titleColor = [UIColor blackColor];
        vc.listVCArray = @[[FGHeaderPagleListVC new],[FGHeaderPagleListVC new],[FGHeaderPagleListVC new]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
