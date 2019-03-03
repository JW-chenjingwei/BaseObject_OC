//
//  FGAreaPicker.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSObject+YYModel.h>

@interface FGCityModel : NSObject<YYModel>

@property (nonatomic, strong) NSNumber  *addressId;

@property (nonatomic, strong) NSString *package;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *parentid;

@end

@interface FGAreaPicker : UIControl

@property (nonatomic, copy) void (^didSeclectedDone) (FGCityModel *province, FGCityModel *city, FGCityModel *town);
- (void)show;

@end
