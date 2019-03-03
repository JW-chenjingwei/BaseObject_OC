//
//  UIColor+FGGradient.m
//  yulala
//
//  Created by 陈经纬 on 2018/10/15.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import "UIColor+FGGradient.h"

@implementation UIColor (FGGradient)

#pragma mark - Gradient Color
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param width 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)fg_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width
{
    CGSize size = CGSizeMake(width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 0), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
