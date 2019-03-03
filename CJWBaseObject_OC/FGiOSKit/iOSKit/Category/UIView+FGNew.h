//
//  UIView+FGNew.h
//  figoioskit
//
//  Created by 陈经纬 on 2018/3/19.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FGNew)

/**
 快速创建 view
 
 @param colorHex 颜色编码 16进制 (colorHex == 0 透明; == 1 白色 == 2 黑色)
 @return view
 */
+ (UIView *)fg_backgroundColor:(NSInteger)colorHex;

- (void)fg_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(NSInteger)colorHex;

@end

@interface UILabel (FGNew)

#pragma mark - +

/**
 快速创建label
 
 @param text text
 @param fontSize 字体大小
 @param colorHex 颜色编码 16进制
 @return label
 */
+ (UILabel *)fg_text:(NSString *)text fontSize:(NSInteger)fontSize colorHex:(NSInteger)colorHex;

#pragma mark - -

/**
 快速创建label
 
 @param text text
 @param textAlignment textAlignment
 @param font font
 @param color color
 */
- (void)fg_text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font color:(UIColor *)color;

@end


@interface UIButton (FGNew)

#pragma mark - +

/**
 快速创建 Button
 
 @param title title
 @param fontSize 字体大小
 @param titleColorHex 颜色编码 16进制
 @return button
 */
+ (UIButton *)fg_title:(NSString *)title fontSize:(NSInteger)fontSize titleColorHex:(NSInteger)titleColorHex;

/**
 快速创建 Button
 
 @param imageString image
 @param imageStringSelected 选择状态 image
 @return button
 */
+ (UIButton *)fg_imageString:(NSString *)imageString imageStringSelected:(NSString *)imageStringSelected;

#pragma mark - -

/**
 设置
 
 @param title title
 @param font font
 @param titleColor titleColor
 */
- (void)fg_title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor;

@end

@interface UIImageView (FGNew)

/**
 快速创建 imageView
 */
+ (UIImageView *)fg_imageString:(NSString *)imageString;


@end
