//
//  FGAddressManagerCell.h
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import "FGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGAddressManagerCell : FGBaseTableViewCell
@property (nonatomic, copy) void (^defaultAddressBtnClick)(UIButton *sender);
@property (nonatomic, copy) void (^editBtnClick)(void);
@property (nonatomic, copy) void (^deleteBtnClick)(void);
@end

NS_ASSUME_NONNULL_END
