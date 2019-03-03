//
//  LocationHelper.h
//  inManNew
//
//  Created by 杨为聪 on 14-6-23.
//  Copyright (c) 2014年 杨为聪. All rights reserved.
//

/*使用此方法
 
        需要添加CoreLocation.framework库
        在plis文件里添加 NSLocationWhenInUseUsageDescription
 */



#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^DidGetGeolocationsCompledBlock)(NSDictionary * addressDictionary, NSString *province, NSString * city);

@interface LocationHelper : NSObject

+ (instancetype)helper;

- (void)getCurrentGeolocationsCompled:(DidGetGeolocationsCompledBlock)compled;

//判断是否开启定位功能
+ (BOOL)isStartLocationWithShow:(BOOL)show;

@end
