//
//  FGAddressManagerViewController.m
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import "FGAddressManagerViewController.h"
#import "FGAddAddressViewController.h"
#import "FGAddressManagerCell.h"
#import "FGAlertView.h"
#import "FGiOSKit.h"

@interface FGAddressManagerViewController ()

@end

@implementation FGAddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"收货地址"];
    [self setupUIViews];
    self.myTableView.mj_footer = nil;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupEstimatedRowHeight:100 cellClasses:@[[FGAddressManagerCell class]]];
    
    [self beginRefresh];
}

- (void)requestDataWithOffset:(NSInteger)offset success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure
{
    
//    [FGHttpManager getWithPath:NSStringFormat(@"api/users/%@/addresses",kUserId) parameters:nil success:^(id responseObject) {
//        NSArray *arry =  [NSArray modelArrayWithClass:[FGAddressModel class] json:responseObject];
//        success(arry);
//    } failure:^(NSString *error) {
//        [self showTextHUDWithMessage:error];
//    }];
    
}

- (void)configCellSubViewsCallback:(FGAddressManagerCell *)cell indexPath:(NSIndexPath *)indexPath{
    WeakSelf
    FGAddressModel *model = self.dataSourceArr[indexPath.row];
    //编辑
    cell.editBtnClick = ^{
        StrongSelf
        FGAddAddressViewController *vc = [FGAddAddressViewController new];
        vc.addrModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        vc.saveSucess = ^{
            StrongSelf
            [self beginRefresh];
        };
    };
    
    //删除
    cell.deleteBtnClick = ^{
        StrongSelf
        //删除地址
        FGAlertView *alterView = [[FGAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该地址吗" btnNames:@[@"取消",@"确定"]];
        [alterView show];
        alterView.didSelected = ^(BOOL isCancel) {
            StrongSelf
            if (!isCancel) {
//                NSString *url = NSStringFormat(@"api/users/%@/addresses/%@",kUserId,model.ID);
//                [FGHttpManager deleteWithPath:url parameters:nil success:^(id responseObject) {
//                    [self showCompletionHUDWithMessage:@"删除成功" completion:^{
//                        [self beginRefresh];
//                    }];
//                } failure:^(NSString *error) {
//                    [self showTextHUDWithMessage:error];
//                }];
            }
        };
        
    };
    
    cell.defaultAddressBtnClick = ^(UIButton *sender) {
        //更新地址
        
        NSMutableDictionary *paramter = [NSMutableDictionary new];
        paramter[@"province"] = model.province;
        paramter[@"city"] = model.city;
        paramter[@"district"] = model.district;
        paramter[@"address"] = model.address;
        paramter[@"contact_name"] = model.contact_name;
        paramter[@"contact_phone"] = model.contact_phone;
        paramter[@"zip"] = @"000000";
        paramter[@"default"] = @(!model.is_default);
//        NSString *url = NSStringFormat(@"api/users/%@/addresses/%@",kUserId,model.ID);
//        [FGHttpManager patchWithPath:url parameters:paramter success:^(id responseObject) {
//
//            [self showTextHUDWithMessage:@"修改成功"];
//            [self beginRefresh];
//        } failure:^(NSString *error) {
//            [self showTextHUDWithMessage:error];
//        }];
        
    };
}

- (void)addAddress{
    FGAddAddressViewController *vc = [FGAddAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    WeakSelf
    vc.saveSucess = ^{
        StrongSelf
        [self beginRefresh];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelect) {
        self.didSelect(self.dataSourceArr[indexPath.row]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUIViews{
    
    UIButton *addAddressBtn = [UIButton fg_title:@"添加收货地址" fontSize:16 titleColorHex:0x000000];
    [addAddressBtn setBackgroundImage:UIImageWithName(@"btn_orange_4") forState:0];
    [addAddressBtn addTarget:self action:@selector(addAddress ) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *buttomBGView = [UIView new];
    buttomBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomBGView];
    
    [buttomBGView addSubview:addAddressBtn];
    
    [buttomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
    }];
    
    [self setEnptyView:[[FGEmptyView alloc] initWithImageString:@"ic_add_address" text:@"暂无地址~"]];
    
    [addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.offset(AdaptedWidth(10));
        make.bottom.offset(AdaptedScreenBottom(-10));
    }];
    
    [self.myTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.equalTo(buttomBGView.mas_top);
    }];
    
    
}

@end
