//
//  NSNumber+FGPrice.m
//  yulala
//
//  Created by 陈经纬 on 2018/11/23.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import "NSNumber+FGPrice.h"

@implementation NSNumber (FGPrice)

- (NSString *)fg_price
{
    return [self jk_toDisplayNumberWithDigit:2];
}

- (NSNumber *)fg_money
{
    return [self jk_doRoundWithDigit:2];
}

@end
