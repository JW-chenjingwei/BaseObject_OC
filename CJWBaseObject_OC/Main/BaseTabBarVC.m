//
//  BaseTabBarVC.m
//  CJWBaseObject_OC
//
//  Created by 陈经伟 on 2019/3/2.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "BaseTabBarVC.h"
#import "Test1VC.h"
#import "Test2VC.h"
#import "Test3VC.h"
#import "Test4VC.h"
@implementation BaseTabBarVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tabBar.tintColor = UIColorTheme;
    
    //统一调整 导航栏 设置
    EasyNavigationOptions *options = [EasyNavigationOptions shareInstance];
    options.titleColor = UIColorFromHex(0xFFFFFF);
    options.titleFont = [UIFont systemFontOfSize:19];
    options.navigationBackButtonImage = [UIImage imageNamed:@"back_btn"];
    options.buttonTitleColor = UIColorFromHex(0xFFFFFF);
    options.navBackGroundColor = UIColorTheme;
    
    [self addChirdVC];
}

- (void)addChirdVC{
    Test1VC *vc1 = [Test1VC new];
    
    Test2VC *vc2 = [Test2VC new];
    
    Test3VC *vc3 = [Test3VC new];
    
    Test4VC *vc4 = [Test4VC new];
    
    [self setupChirdVC:vc1 :@"tabbar1" imageName:@"home_tabbar"];
    [self setupChirdVC:vc2 :@"tabbar1" imageName:@"home_tabbar"];
    [self setupChirdVC:vc3 :@"tabbar1" imageName:@"home_tabbar"];
    [self setupChirdVC:vc4 :@"tabbar1" imageName:@"home_tabbar"];
}

- (void)setupChirdVC:(FGBaseViewController *)vc :(NSString *)title imageName:(NSString *)imageName{
    vc.title = title;
    
    
    FGBaseNavigationController *navi = [[FGBaseNavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.image = UIImageWithName(imageName);
    vc.tabBarItem.selectedImage = UIImageWithName(NSStringFormat(@"%@_press",imageName));
    [self addChildViewController:navi];
    
}
@end
