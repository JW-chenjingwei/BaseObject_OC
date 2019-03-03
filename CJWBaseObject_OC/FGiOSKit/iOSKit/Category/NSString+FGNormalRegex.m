//
//  NSString+FGNormalRegex.m
//  yulala
//
//  Created by 陈经纬 on 2018/12/26.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import "NSString+FGNormalRegex.h"

@implementation NSString (FGNormalRegex)

#pragma mark - 正则相关
- (BOOL)jk_isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

//手机号有效性
- (BOOL)fg_isMobileNumber{
    //运营商手机号段划分
    //总汇:13[0-9]、 14[5,7]、 15[0, 1, 2, 3, 5, 6, 7, 8, 9]、166、 17[6, 7, 8]、 18[0-9]、 170[0,5,9]、19[8,9]
    //中国移动: 134（0-8）、135、136、137、138、139、147(无线上网卡)、150、151、152、157、158、159、178、182、183、184、187、188、198(暂未启用)、1705(虚拟运营商号段)
    //中国联通: 130、131、132、145(无线上网卡)、155、156、166（暂未启用）、176、185、186、175（2015年9月10日正式启用，暂只对北京、上海和广东投放办理）、1709(虚拟运营商号段)
    //中国电信: 133、153、173、177、180、181、189、199、1700(虚拟运营商号段)
    
    
    NSString *mobileRegex = @"(^1(3[0-9]|4[57]|5[0-35-9]|66|7[0-8]|8[0-9]|9[8-9])\\d{8}$)|(^170[059]\\d{7}$)";
    //    NSString *MOBILE = @"(^1(3[0-9]|4[57]|5[0-35-9]|66|7[6-8]|8[0-9]|9[8-9])\\d{8}$)|(^170[059]\\d{7}$)";
    
    BOOL ret1 = [self jk_isValidateByRegex:mobileRegex];
    return ret1;
}

@end
