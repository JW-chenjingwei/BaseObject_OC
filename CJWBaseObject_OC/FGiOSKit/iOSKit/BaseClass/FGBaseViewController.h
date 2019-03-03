//
//  FGBaseViewController.h
//  figoioskit
//
//  Created by 陈经纬 on 2018/2/24.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyNavigation/EasyNavigation.h>
#import "FGScrollView.h"
#import "FGiOSKit.h"

@interface FGBaseViewController : UIViewController

@property (nonatomic, strong) FGScrollView *bgScrollView;

//创建UI
- (void)setupViews;

//UI布局
- (void)setupLayout;

@end
