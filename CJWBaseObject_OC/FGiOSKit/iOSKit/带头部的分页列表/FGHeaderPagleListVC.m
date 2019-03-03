//
//  FGHeaderPagleListVC.m
//  demo
//
//  Created by 陈经纬 on 2019/2/13.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "FGHeaderPagleListVC.h"

@interface FGHeaderPagleListVC ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation FGHeaderPagleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}
#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.myTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

@end
