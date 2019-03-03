//
//  UIView+EdgeLine.h
//  aiqilv
//
//  Created by 陈经纬 on 17/3/13.
//  Copyright © 2017年 刘剑华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EdgeLine)

- (void)addAllLine;
- (void)addTopLine;
- (void)addBottomLine;
- (void)addLeftLine;
- (void)addRightLine;

- (void)addTopLineWithEdge:(UIEdgeInsets)edge;
- (void)addBottomLineWithEdge:(UIEdgeInsets)edge;
- (void)addLeftLineWithEdge:(UIEdgeInsets)edge;
- (void)addRightLineWithEdge:(UIEdgeInsets)edge;

- (void)addTopLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color;
- (void)addBottomLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color;
- (void)addLeftLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color;
- (void)addRightLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color;

@end
