//
//  NSString+FGNormalRegex.h
//  yulala
//
//  Created by 陈经纬 on 2018/12/26.
//  Copyright © 2018 陈经纬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FGNormalRegex)

/**
 *  手机号有效性
 */
- (BOOL)fg_isMobileNumber;

@end

NS_ASSUME_NONNULL_END
