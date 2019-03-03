//
//  FGBaseViewController.m
//  figoioskit
//
//  Created by 陈经纬 on 2018/2/24.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "FGBaseViewController.h"
#import <JKCategories/UIView+JKFind.h>
#import "FGBaseNavigationController.h"

@interface FGBaseViewController ()

@end

@implementation FGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //防止 vc作为子控制器 显示 navigationView 的bug
    if (self.parentViewController &&  [self.parentViewController isMemberOfClass:[FGBaseNavigationController class]]) {
        [self.navigationView setTitle:@""]; 
    }

    self.view.backgroundColor = UIColorFromHex(kColorBG);

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupViews];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //自定义任意位置侧滑返回
    self.customBackGestureEnabel = YES;
    
    if (self.navigationController.viewControllers.count>1) {
        self.customBackGestureEdge = ScreenWidth_N();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FGScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [FGScrollView new];
        [self.view addSubview:_bgScrollView];
        
        [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            
            if (self.parentViewController &&  [self.parentViewController isMemberOfClass:[FGBaseNavigationController class]]) {
                make.top.equalTo(self.navigationView.mas_bottom);
            }else{
                make.top.offset(0);
            }
        }];
        
        //如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
         if (@available(iOS 11.0, *)) {
                if ([_bgScrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
                    _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                }
         }
    }
    return _bgScrollView;
}

- (void)setupViews
{
    
}

- (void)setupLayout
{
    
}

- (void)dealloc
{
    if (self)
    {
        NSLog(@"释放内存空间: %@", NSStringFromClass(self.class));
    }
}

@end
