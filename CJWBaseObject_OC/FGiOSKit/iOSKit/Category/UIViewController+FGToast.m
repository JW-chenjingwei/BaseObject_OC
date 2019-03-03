//
//  UIViewController+FGToast.m
//  figoioskit
//
//  Created by 陈经纬 on 2018/3/2.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "UIViewController+FGToast.h"
#import <objc/runtime.h>
#import "FGiOSKit.h"

static char associateLengthKey;

@implementation UIViewController (FGToast)
@dynamic hud;

- (MBProgressHUD *) hud{
    return (MBProgressHUD *)objc_getAssociatedObject(self, &associateLengthKey);
}

- (void) setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, &associateLengthKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadingHUDWithMessage:(NSString *)message
{
    [self hideLoadingHUD];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = message;
    self.hud.label.font = AdaptedFontSize(13);
    self.hud.contentColor = UIColorFromHex(0xffffff);
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.backgroundColor = [UIColor blackColor];
    self.hud.graceTime = 0.618f;
    //    self.hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}

- (void)hideLoadingHUD
{
    if (self.hud) {
        [self.hud hideAnimated:YES];
    }
}

- (void)showWarningHUDWithMessage:(NSString *)message completion:(completeAction)completion
{
    [self hideLoadingHUD];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.label.text = message;
    self.hud.contentColor = UIColorFromHex(0xffffff);
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.label.font = AdaptedFontSize(13);
    self.hud.bezelView.backgroundColor = [UIColor blackColor];
    self.hud.customView = [[UIImageView alloc] initWithImage:UIImageWithName(@"HUD_alert")];
    //    self.hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //    self.hud.alpha = 0.4;
    [self.hud hideAnimated:YES afterDelay:2];
    if (completion) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)showCompletionHUDWithMessage:(NSString *)message completion:(completeAction)completion
{
    [self hideLoadingHUD];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.label.text = message;
    self.hud.label.font = AdaptedFontSize(13);
    self.hud.contentColor = UIColorFromHex(0xffffff);
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.color = [UIColor blackColor];
    self.hud.customView = [[UIImageView alloc] initWithImage:UIImageWithName(@"HUD_completion")];
    [self.hud hideAnimated:YES afterDelay:2];
    if (completion) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            completion();
        });
    }
}


- (void)showTextHUDWithMessage:(NSString *)message
{
    [self hideLoadingHUD];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.label.text = message;
    self.hud.contentColor = UIColorFromHex(0xffffff);
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.label.font = AdaptedFontSize(13);
    self.hud.bezelView.backgroundColor = [UIColor blackColor];
    [self.hud hideAnimated:YES afterDelay:2];
    
}

@end
