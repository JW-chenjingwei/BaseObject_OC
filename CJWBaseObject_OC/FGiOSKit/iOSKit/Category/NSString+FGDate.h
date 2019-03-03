//
//  NSString+FGDate.h
//  figoioskit
//
//  Created by 陈经纬 on 2018/3/19.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FGDate)

/**
 *  把字符串时间戳 转换成 你要的格式的  时间字符串
 *
 *  @param format 时间格式 yyyy-MM-dd HH:mm:ss
 *
 *  @return 需要的字符串
 */
- (NSString *)fg_stringWithFormat:(NSString *)format;

/**
 * 返回x分钟前/x小时前/x天前/yyyy-MM-dd HH:mm
 */
- (NSString *)fg_timeInfo;

/**
 返回时间间隔 2天 12:21:35 (输入:相差多少的时间戳)
 */
- (NSString *)fg_timeInterval;

@end
