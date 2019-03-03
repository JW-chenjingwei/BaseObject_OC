//
//  FGAdvertiseView.h
//  shopex
//
//  Created by 陈经纬 on 17/3/28.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAdscreenWidth [UIScreen mainScreen].bounds.size.width
#define kAdscreenHeight [UIScreen mainScreen].bounds.size.height
#define kAdMain_Screen_Bounds [[UIScreen mainScreen] bounds]
#define kAdUserDefaults [NSUserDefaults standardUserDefaults]

static NSString *const adImageName = @"adImageName";
static NSString *const adVedioName = @"adVedioName";


@interface FGAdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@end
