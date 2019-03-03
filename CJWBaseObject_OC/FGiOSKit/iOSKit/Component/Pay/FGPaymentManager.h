//
//  FGPaymentManager.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

//#import <WXApi.h>
//#import <WXApiObject.h>
#import "WXApi.h"
//#import "UPPaymentControl.h"

/**
 *  后台返回的微信支付Model
 */
@interface FGWXPayModel : NSObject

@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, strong) NSNumber *timestamp;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *prepayid;
//@property (nonatomic, copy) NSString *package_value;

@end

typedef NS_ENUM(NSInteger, FGPayStatus) {
    FGPayStatusSuccess,
    FGPayStatusCancel,
    FGPayStatusError
};

typedef void(^AliPayResult)(FGPayStatus status);
typedef void(^WXPayResult)(FGPayStatus status);
typedef void(^UPPayResult)(FGPayStatus status);

@interface FGPaymentManager : NSObject<WXApiDelegate>

+ (instancetype)sharedInstance;
- (BOOL)isWXAppInstalled;
- (void)alipayWithSignedString:(NSString *)signedString callback:(AliPayResult)block;
- (void)wxpayWithSign:(FGWXPayModel *)sign callback:(WXPayResult)block;
- (void)uppayWithTnString:(NSString *)tnString callback:(UPPayResult)block;

@property (nonatomic, copy) void (^WXPayResult) (FGPayStatus status);
@property (nonatomic, copy) void (^AliPayResult) (FGPayStatus status);
@property (nonatomic, copy) void (^UPPayResult) (FGPayStatus status);

//由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，
- (void)appHadBeenKilldedWithPaySatus:(NSDictionary *)resultDic;

@end
