//
//  UIView+FGNew.m
//  figoioskit
//
//  Created by 陈经纬 on 2018/3/19.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "UIView+FGNew.h"
#import "FGiOSKit.h"
#import <JKCategories/UIView+JKVisuals.h>

@implementation UIView (FGNew)

+ (UIView *)fg_backgroundColor:(NSInteger)colorHex
{
    UIView *view = [UIView new];
    
    if (colorHex == 0) {
        view.backgroundColor = [UIColor clearColor];
    }else if (colorHex == 1){
        view.backgroundColor = UIColorFromHex(0xffffff);
    }else if (colorHex == 2){
        view.backgroundColor = UIColorFromHex(0x000000);
    }else{
        view.backgroundColor = UIColorFromHex(colorHex);
    }
    
    return view;
}

- (void)fg_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(NSInteger)colorHex
{
    self.layer.masksToBounds = YES;
    if (radius != 0) {
        self.layer.cornerRadius = radius;
    }
    if (borderWidth != 0) {
        self.layer.borderWidth = borderWidth;
    }
    if (colorHex != 0) {
        self.layer.borderColor = UIColorFromHex(colorHex).CGColor;
    }
}

@end

@implementation UILabel (FGNew)

+ (UILabel *)fg_text:(NSString *)text fontSize:(NSInteger)fontSize colorHex:(NSInteger)colorHex
{
    UILabel *label = [UILabel new];
    [label fg_text:text textAlignment:0 font:AdaptedFontSize(fontSize) color:UIColorFromHex(colorHex)];
    return  label;
}

- (void)fg_text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font color:(UIColor *)color
{
    if (text) { self.text = text;}
    if (font) {self.font = font;}
    if (color) {self.textColor = color;}
    if (textAlignment) {self.textAlignment = textAlignment;}
}

@end



@implementation UIButton (FGNew)

+ (UIButton *)fg_title:(NSString *)title fontSize:(NSInteger)fontSize titleColorHex:(NSInteger)titleColorHex
{
    UIButton *button = [UIButton new];
    [button fg_title:title font:AdaptedFontSize(fontSize) titleColor:UIColorFromHex(titleColorHex)];
    return button;
}

+ (UIButton *)fg_imageString:(NSString *)imageString imageStringSelected:(NSString *)imageStringSelected
{
    UIButton *button = [UIButton new];
    [button fg_image:[UIImage imageNamed:imageString] imageSelected:[UIImage imageNamed:imageStringSelected]];
    return button;
}

- (void)fg_image:(UIImage *)image imageSelected:(UIImage *)imageSelected
{
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
    }
    
    if (imageSelected) {
        [self setImage:imageSelected forState:UIControlStateSelected];
    }
}

- (void)fg_title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor
{
    if (font) {self.titleLabel.font = font;}
    
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
@end

@implementation UIImageView (FGNew)

+ (UIImageView *)fg_imageString:(NSString *)imageString
{
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (!IsEmpty(imageView)) {
        imageView.image = [UIImage imageNamed:imageString];
    }
    
    return imageView;
}

@end
