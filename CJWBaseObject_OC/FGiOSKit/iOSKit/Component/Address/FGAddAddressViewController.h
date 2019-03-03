//
//  FGAddAddressViewController.h
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGAddAddressViewController : FGBaseViewController
@property (nonatomic,copy) void ((^saveSucess)(void));///<保存成功的回调
@property (nonatomic, strong) FGAddressModel *addrModel;
@end

NS_ASSUME_NONNULL_END
