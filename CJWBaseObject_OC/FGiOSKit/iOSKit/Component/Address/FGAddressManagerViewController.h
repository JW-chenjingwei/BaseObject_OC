//
//  FGAddressManagerViewController.h
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import "FGBaseRefreshTableViewController.h"
#import "FGAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGAddressManagerViewController : FGBaseRefreshTableViewController
@property (nonatomic,copy) void ((^didSelect)(FGAddressModel *item));///<<#name#>
@end

NS_ASSUME_NONNULL_END
