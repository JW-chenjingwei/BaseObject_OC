//
//  FGTools.h
//  dingdingxuefu
//
//  Created by 陈经纬 on 2018/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FGTools : NSObject

/**
 返回 aunch image
 */
+ (UIImage *)getLaunchImage;

/**
 返回 icon
 */
+ (UIImage *)appIcon;

/**
 创建 富文本 字符串
 
 @param string 默认字符串
 @param appendString 添加的字符串
 @param attributes 添加的字符串 的属性
 @return 富文本
 */
+ (NSMutableAttributedString *)attributedWithString:(NSString *)string appendString:(NSString *)appendString attributes:(NSDictionary *)attributes;

/**
 合并两个数组 并且去重 (数组中的元素类型 为 model 或者 字典)
 @param array 数组一
 @param other 数组二
 @param key key是元素的需要对比的属性名(key属性类型暂时只支持 NSString NSNumber)
 @return 重新生成的一个数组
 */
+ (NSMutableArray *)mergeWithArray:(NSArray *)array other:(NSArray *)other key:(NSString *)key;

/**
 模糊搜索 支持拼音
 
 @param source 搜索的来源字符串
 @param search 输入的字符串
 @return 是否有匹配
 */
+ (BOOL)blurrySearchWithSource:(NSString *)source search:(NSString *)search;

@end
