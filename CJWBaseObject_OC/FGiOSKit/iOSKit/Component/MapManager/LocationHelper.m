//
//  LocationHelper.h
//  inManNew
//
//  Created by 杨为聪 on 14-6-23.
//  Copyright (c) 2014年 杨为聪. All rights reserved.
//
#import "LocationHelper.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "FGiOSKit.h"

@interface LocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) DidGetGeolocationsCompledBlock didGetGeolocationsCompledBlock;

@end

@implementation LocationHelper

+ (instancetype)helper
{
    static LocationHelper * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LocationHelper alloc]init];
    });
    
    return helper;
}

- (void)setup {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.didGetGeolocationsCompledBlock = nil;
}

- (void)getCurrentGeolocationsCompled:(DidGetGeolocationsCompledBlock)compled {
    self.didGetGeolocationsCompledBlock = compled;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:
     ^(NSArray* placemarks, NSError* error) {
         
         if (placemarks.count > 0) {
             CLPlacemark * placemark = [placemarks objectAtIndex:0];
             //获取城市
             NSString * city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSString *province = placemark.administrativeArea;
             NSDictionary * addressDictionary = placemark.addressDictionary;    //地址详情字典
             
             //储存纬度,经度
             NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:addressDictionary];
             [dict setObject:@(newLocation.coordinate.latitude) forKey:@"latitude"];
             [dict setObject:@(newLocation.coordinate.longitude) forKey:@"longitude"];
             
             if (self.didGetGeolocationsCompledBlock) {
                 self.didGetGeolocationsCompledBlock(dict, province, city);
             }
         }
     }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [manager stopUpdatingLocation];
}

//判断是否开启定位功能
+ (BOOL)isStartLocationWithShow:(BOOL)show
{
    //确定用户的位置服务是否启用,位置服务在设置中是否被禁用
    BOOL enable      =[CLLocationManager locationServicesEnabled];
    NSInteger status =[CLLocationManager authorizationStatus];
    if( !enable || status< 2){
        //尚未授权位置权限
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            //系统位置授权弹窗
           CLLocationManager *locationManager =[[CLLocationManager alloc]init];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
    }else{
        if (status == kCLAuthorizationStatusDenied) {
            //拒绝使用位置
            if (show) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"需要开启位置授权" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
                
                [kAppDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }else{
            return YES;
        }
    }
    return NO;
}


@end
