//
//  FGPageListVC.m
//  demo
//
//  Created by 陈经纬 on 2019/2/13.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "FGPageListVC.h"

@interface FGPageListVC ()

@end

@implementation FGPageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {}

- (void)listDidDisappear {}

@end
