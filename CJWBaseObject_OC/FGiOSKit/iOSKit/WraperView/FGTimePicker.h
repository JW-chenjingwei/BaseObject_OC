//
//  FGTimePicker.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTimePicker : UIControl

@property (nonatomic, copy) void (^didSeclectedTime) (NSString *timeStamp, NSString *timeFormat);

@property (nonatomic, copy) NSString *dateFormatter;  ///< 返回的时间格式 默认 yyyy.MM.dd HH:mm

- (void)show;
- (void)setDefaultDate:(NSString *)dateString;
- (void)setTitleString:(NSString *)title;

@end
