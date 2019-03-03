//
//  FGAddressModel.h
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGAddressModel : NSObject
@property (nonatomic,copy) NSString *user_id;///<name
@property (nonatomic,copy) NSString *province;///<<#name#>
@property (nonatomic,copy) NSString *city;///<name
@property (nonatomic, copy) NSString *district;  ///< <#name#>
@property (nonatomic,copy) NSString *address;///<name
@property (nonatomic,copy) NSString *contact_name;///<name
@property (nonatomic, copy) NSString *contact_phone;  ///< <#name#>
@property (nonatomic,assign) BOOL is_default;///<name
@end

NS_ASSUME_NONNULL_END
