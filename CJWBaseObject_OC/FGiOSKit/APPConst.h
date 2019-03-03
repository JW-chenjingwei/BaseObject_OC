//
//  APPConst.h
//  shopex
//
//  Created by 陈经纬 on 17/3/31.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 登录成功的通知  */
static NSString *const kLoginSucceedNotification = @"kLoginSucceedNotification";
/**  退出登录的通知  */
static NSString *const kLogoutSucceedNotification = @"kLogoutSucceedNotification";

static NSString *const kDidegisterUserNotification = @"kDidegisterUserNotification";

static CGFloat const k12 = 12.0;





@interface APPConst : NSObject


/**
 后台状态
 订单已提交待支付: 100
 已支付待发货: 200
 已发货待收货: 210
 已收货: 220
 已收货待评价: 230
 申请退款: 300
 退款中: 310
 退款完成: 320
 订单完成: 800(待定)
 订单关闭: 900
 订单取消: 910(待定)
 */
typedef NS_ENUM(NSUInteger, OrderListType) {
    AllOrderListType = 0, ///< 全部
    PaymentListType = 100, ///< 待付款
    SendListType = 200, ///< 待发货
    ReceiveListType = 210, ///< 待收货
    CommentListType = 230, ///< 待评价
    FinishListType = 240, ///< 已评价
    CancelListType = 900///< 已取消
};


/**
 后台状态

 - OrderHandleTypePay: <#OrderHandleTypePay description#>
 */
typedef NS_ENUM(NSUInteger, OrderHandleType) {
    OrderHandleTypePay, ///< 立即支付
    OrderHandleTypeCancel, ///< 取消订单
    OrderHandleTypeDelete, ///< 删除订单
    OrderHandleTypeConfirm, ///< 确认收货
    OrderHandleTypeAfterSale, ///< 申请售后
    OrderHandleTypeAgain, ///< 再次购买
    OrderHandleTypeComment, ///< 评价
    OrderHandleTypeLogistics, ///< 查看物流
    OrderHandleTypeContact, ///< 联系客户
    OrderHandleTypeContactStore, ///< 联系商家
    OrderHandleTypeSend, ///< 确认发货
};

@end
