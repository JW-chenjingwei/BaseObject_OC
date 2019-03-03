//
//  UIView+EdgeLine.m
//  aiqilv
//
//  Created by 陈经纬 on 17/3/13.
//  Copyright © 2017年 刘剑华. All rights reserved.
//

#import "UIView+EdgeLine.h"
#import "FGiOSKit.h"

@implementation UIView (EdgeLine)

- (UIView *)lineViewWithColor:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    return line;
}

- (void)addTopLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color
{
    UIView *line = [self lineViewWithColor:color];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(edge.left);
        make.right.equalTo(self.mas_right).offset(-edge.right);
        make.top.equalTo(self);
        make.height.equalTo(@(kOnePixel));
    }];
}
- (void)addBottomLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color
{
    UIView *line = [self lineViewWithColor:color];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(edge.left);
        make.right.equalTo(self.mas_right).offset(-edge.right);
        make.bottom.equalTo(self);
        make.height.equalTo(@(kOnePixel));
    }];
}

- (void)addLeftLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color
{
    UIView *line = [self lineViewWithColor:color];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(edge.top);
        make.bottom.equalTo(self.mas_bottom).offset(-edge.bottom);
        make.left.equalTo(self);
        make.width.equalTo(@(kOnePixel));
    }];
}

- (void)addRightLineWithEdge:(UIEdgeInsets)edge color:(UIColor *)color
{
    UIView *line = [self lineViewWithColor:color];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(edge.top);
        make.bottom.equalTo(self.mas_bottom).offset(-edge.bottom);
        make.right.equalTo(self);
        make.width.equalTo(@(kOnePixel));
    }];
}


- (void)addTopLineWithEdge:(UIEdgeInsets)edge
{
    [self addTopLineWithEdge:edge color:UIColorFromHex(kColorLine)];
}
- (void)addBottomLineWithEdge:(UIEdgeInsets)edge
{
    [self addBottomLineWithEdge:edge color:UIColorFromHex(kColorLine)];
}
- (void)addLeftLineWithEdge:(UIEdgeInsets)edge
{
    [self addLeftLineWithEdge:edge color:UIColorFromHex(kColorLine)];
}
- (void)addRightLineWithEdge:(UIEdgeInsets)edge
{
    [self addRightLineWithEdge:edge color:UIColorFromHex(kColorLine)];
}

- (void)addAllLine
{
    [self addTopLine];
    [self addLeftLine];
    [self addBottomLine];
    [self addRightLine];
}

- (void)addTopLine
{
    [self addTopLineWithEdge:UIEdgeInsetsZero];
}

- (void)addBottomLine
{
    [self addBottomLineWithEdge:UIEdgeInsetsZero];
}

- (void)addLeftLine
{
    [self addLeftLineWithEdge:UIEdgeInsetsZero];
}

- (void)addRightLine
{
    [self addRightLineWithEdge:UIEdgeInsetsZero];
}


@end
