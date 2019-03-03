//
//  FGPaymentManager.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGPaymentManager.h"
#import "FGiOSKit.h"

@implementation FGWXPayModel

@end

@implementation FGPaymentManager

+ (instancetype)sharedInstance
{
    static FGPaymentManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FGPaymentManager alloc] init];
    });
    return sharedInstance;
}

- (void)appHadBeenKilldedWithPaySatus:(NSDictionary *)resultDic
{
    //支付成功后回调
    if ([resultDic[@"resultStatus"] intValue] == 9000) {
        //支付成功，跳转到订单详情
        if (self.AliPayResult) {
            self.AliPayResult(FGPayStatusSuccess);
        }
        
    }else if ([resultDic[@"resultStatus"] intValue] == 6001){
        //中途取消
        if (self.AliPayResult) {
            self.AliPayResult(FGPayStatusCancel);
        }
        
    }else{
        //支付失败
        if (self.AliPayResult) {
            self.AliPayResult(FGPayStatusError);
        }
    }
}

//支付宝支付
- (void)alipayWithSignedString:(NSString *)signedString callback:(AliPayResult)block
{
    if (!IsEmpty(signedString)) {
        
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:kBundleId callback:^(NSDictionary *resultDic) {
            DLog(@"reslut alipay = %@",resultDic);
            
            //支付成功后回调
            if ([resultDic[@"resultStatus"] intValue] == 9000) {
                //支付成功，跳转到订单详情
                if (block) {
                    block(FGPayStatusSuccess);
                }
                
            }else if ([resultDic[@"resultStatus"] intValue] == 6001){
                //中途取消
                if (block) {
                    block(FGPayStatusCancel);
                }
                
            }else{
                //支付失败
                if (block) {
                    block(FGPayStatusError);
                }
            }
        }];
    }
}

//微信支付
- (void)wxpayWithSign:(FGWXPayModel *)sign callback:(WXPayResult)block
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"设备未安装微信,请重新选择支付方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //调起微信支付
    PayReq* req = [[PayReq alloc] init];
    req.openID = sign.appid;
    req.partnerId = sign.partnerid;
    req.prepayId = sign.prepayid;
    req.nonceStr = sign.noncestr;
    req.sign = sign.sign;
    req.timeStamp = sign.timestamp.unsignedIntValue;
    req.package = sign.package;
    
    [WXApi sendReq:req];
    
    if (block) {
        [self setWXPayResult:^(FGPayStatus status) {
            block(status);
        }];
    }
}

//微信支付回调
-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        
        if (resp.errCode == WXSuccess) {
            
            // 成功
            if (self.WXPayResult) {
                self.WXPayResult(FGPayStatusSuccess);
            }
            
        }
        else if (resp.errCode == WXErrCodeUserCancel)
        {
            // 取消
            if (self.WXPayResult) {
                self.WXPayResult(FGPayStatusCancel);
            }
        }
        else
        {
            // 失败
            if (self.WXPayResult) {
                self.WXPayResult(FGPayStatusError);
            }
        }
    }
}

//银联支付
- (void)uppayWithTnString:(NSString *)tnString callback:(UPPayResult)block
{
//    if (![self isUPAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"设备未安装银联支付app,请重新选择支付方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    
//    if (tnString != nil && tnString.length > 0)
//    {
//        /** mode "00"代表接入生产环境（正式版本需要）；
//         "01"代表接入开发测试环境（测试版本需要）；*/
//        [[UPPaymentControl defaultControl] startPay:tnString fromScheme:kBundleId mode:@"01" viewController:nil];
//    }
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    //    NSString* msg = [NSString stringWithFormat:kResult, result];
    //    [self showAlertMessage:msg];
}

- (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

//判断手机上是否安装了银联支付app
//- (BOOL)isUPAppInstalled
//{
//    return [[UPPaymentControl defaultControl] isPaymentAppInstalled];
//}

@end
