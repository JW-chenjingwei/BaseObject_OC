//
//  NSString+FGDate.m
//  figoioskit
//
//  Created by 陈经纬 on 2018/3/19.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "NSString+FGDate.h"

@implementation NSString (FGDate)

- (NSString *)fg_stringWithFormat:(NSString *)format{
    
    NSTimeInterval timeInterval = (NSTimeInterval)(self.doubleValue);
    if (self.doubleValue > 100000000000 || self.doubleValue < 100000000000) {
        //毫秒表示
        timeInterval = (NSTimeInterval)(self.doubleValue)/1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

- (NSString *)fg_timeInfo
{
    NSTimeInterval timeInterval = (NSTimeInterval)(self.doubleValue);
    if (self.doubleValue > 100000000000 || self.doubleValue < 100000000000) {
        //毫秒表示
        timeInterval = (NSTimeInterval)(self.doubleValue)/1000;
    }
    
    //现在的时间戳
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970] ;
    
    NSTimeInterval coumpareTimeInterval = currentTimeInterval - timeInterval;
    
    unsigned long temp = 0;
    NSString *result;
    if (coumpareTimeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = coumpareTimeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else{
        result = [self fg_stringWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    return result;
}

- (NSString *)fg_timeInterval
{
    long timeInterval = (self.longLongValue);

    //显示时间间隔
    long minute,second,hour,day;
    
    second= timeInterval % 60;
    minute = (timeInterval/60)%60;
    hour = (timeInterval/3600)%24;
    day = (timeInterval/3600/24);
    
    NSString *timeStr;
    if (hour == 0 && day == 0) {
        timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld", minute, second];
    }else if (day == 0){
        timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minute, second];
    }else{
        timeStr = [NSString stringWithFormat:@"%.ld 天 %.2ld:%.2ld:%.2ld", day, hour, minute, second];
    }
    
    return timeStr;
}

@end
