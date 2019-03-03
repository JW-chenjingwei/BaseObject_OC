//
//  NSNumber+FGPrice.h
//  yulala
//
//  Created by 陈经纬 on 2018/11/23.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+JKRound.h"

@interface NSNumber (FGPrice)

/**
 显示小数后两位(四舍五入法) 千位加逗号
 */
- (NSString *)fg_price;

/**
 显示小数后两位(四舍五入法) 千位不加逗号
 */
- (NSNumber *)fg_money;

@end
