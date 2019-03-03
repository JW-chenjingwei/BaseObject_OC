//
//  UIColor+FGGradient.h
//  yulala
//
//  Created by 陈经纬 on 2018/10/15.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIColor+JKGradient.h>
/**
 颜色渐变分类 左到右
 JKGradient 上到下 渐变
 */
@interface UIColor (FGGradient)

/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param width 渐变宽度度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)fg_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width;

@end
