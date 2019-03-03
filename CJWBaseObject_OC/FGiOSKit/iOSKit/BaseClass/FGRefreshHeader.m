//
//  FGRefreshHeader.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGRefreshHeader.h"
//#import "UIImage+Size.h"

@implementation FGRefreshHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=88; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading0%003zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
//        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(60, 60)];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 88; i<=215; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading0%003zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
//        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(60, 60)];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    NSMutableArray *startImages = [NSMutableArray array];
    for (NSUInteger i = 215; i<= 305; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading0%003zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
//        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(60, 60)];
        [startImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:startImages forState:MJRefreshStateRefreshing];
    
}
@end
