//
//  ICShareManager.m
//  ichezhidao
//
//  Created by 陈经纬 on 16/8/29.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGShareManager.h"
#import "UIViewController+FGToast.h"
#import <TencentOpenAPI/QQApiInterface.h>
//#import <WXApi.h>
#import "WXApi.h"
#import "FGTools.h"
#import "FGiOSKit.h"
#import "MBProgressHUD+LMJ.h"


@interface FGShareManager ()

@end

@implementation FGShareManager{
    NSString *parmas;
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//分享到指定平台
- (void)setShareType:(NSString *)typeString shareModel:(FGShareModel *)sModel
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sModel.logo]]];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:sModel.title descr:sModel.body thumImage:image];
   
    //设置网页地址
    shareObject.webpageUrl = sModel.url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    UMSocialPlatformType type;
    /**微信好友 */
    if ([typeString isEqualToString:FGShareToWechatSession]) {
        
        type = UMSocialPlatformType_WechatSession;
        
        if (![WXApi isWXAppInstalled]) {
            [kKeyWindow.rootViewController showWarningHUDWithMessage:@"未安装微信" completion:nil];
            return;
        }
        
        /**微信朋友圈*/
    }else if ([typeString isEqualToString:FGShareToWechatTimeline]){
        
        type = UMSocialPlatformType_WechatTimeLine;
        if (![WXApi isWXAppInstalled]) {
            [kKeyWindow.rootViewController showWarningHUDWithMessage:@"未安装微信" completion:nil];
            return;
        }
        /** 新浪微博 */
    }else if ([typeString isEqualToString:FGShareToSina]){
        
        type = UMSocialPlatformType_Sina;
        
        messageObject.text = [NSString stringWithFormat:@"%@ %@",sModel.title,sModel.url];
        UMShareImageObject *shareObject = [UMShareImageObject new];
        shareObject.thumbImage = [FGTools appIcon];
        [shareObject setShareImage:image];
        messageObject.shareObject = shareObject;
        
        /** QQ */
    }else if ([typeString isEqualToString:FGShareToQQ]){
        
        type = UMSocialPlatformType_QQ;
        if (![QQApiInterface isQQInstalled]) {
            [kKeyWindow.rootViewController showWarningHUDWithMessage:@"未安装QQ" completion:nil];
            return;
        }
        
        /** Facebook */
    }else if ([typeString isEqualToString:FGShareToFacebook]){
        
        type = UMSocialPlatformType_Facebook;
    }
    else{
        type = UMSocialPlatformType_WechatSession;
    }
    
    [self shareMethod:type message:messageObject];
}

//调用分享接口
- (void)shareMethod:(UMSocialPlatformType)type message:(UMSocialMessageObject *)message
{
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:message currentViewController:kKeyWindow.rootViewController completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"分享失败" ToView:nil];
        }else{
            [MBProgressHUD showSuccess:@"分享成功" ToView:nil];
        }
    }];
}

@end
