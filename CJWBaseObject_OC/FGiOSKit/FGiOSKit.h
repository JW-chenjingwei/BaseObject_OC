//
//  FGiOSKit.h
//  FGiOSKitDemo
//
//  Created by 陈经纬 on 2019/1/17.
//  Copyright © 2019 陈经纬. All rights reserved.
//

#ifndef FGiOSKit_h
#define FGiOSKit_h

#pragma mark - 第三方库

#import <Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <JKUIKit.h>
#import <JKFoundation.h>

#pragma mark - 基类

#import "FGBaseViewController.h"
#import "FGBaseNavigationController.h"
#import "FGEmptyView.h"     //占位图
#import "FGUtilsMacro.h"    //宏
#import "FGAlertView.h"     //提示框
#import "FGTools.h"     //工具类

#pragma mark - 类别

#import "UIView+FGNew.h"
#import "UIView+EdgeLine.h"
#import "UIViewController+FGToast.h"
#import "NSString+FGDate.h"
#import "NSNumber+FGPrice.h"
#import "NSString+FGNormalRegex.h"

#pragma mark - 需要手动导入项目中的

#import "APPConst.h"
#import "APPConfig.h"

#endif /* FGiOSKit_h */
