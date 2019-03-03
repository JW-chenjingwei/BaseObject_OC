//
//  UIViewController+FGToast.h
//  figoioskit
//
//  Created by 陈经纬 on 2018/3/2.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

typedef void(^completeAction)(void);

@interface UIViewController (FGToast)

/*
 菊花+文字提示
 */
- (void)showLoadingHUDWithMessage:(NSString *)message;
/*
 隐藏hud
 */
- (void)hideLoadingHUD;
/*
 文字居中提示
 */
- (void)showTextHUDWithMessage:(NSString *)message;
/*
 警告提示
 */
- (void)showWarningHUDWithMessage:(NSString *)message completion:(completeAction)completion;
/*
 完成提示
 */
- (void)showCompletionHUDWithMessage:(NSString *)message completion:(completeAction)completion;

@property (nonatomic, strong) MBProgressHUD *hud;

@end
