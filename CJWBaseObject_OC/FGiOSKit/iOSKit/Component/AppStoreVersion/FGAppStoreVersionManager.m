//
//  FGAppStoreVersionManager.m
//  DaoShiBiao
//
//  Created by 陈经纬 on 2017/9/4.
//  Copyright © 2017年 陈经纬. All rights reserved.
//

#import "FGAppStoreVersionManager.h"
#import <AFNetworking.h>
#import "FGiOSKit.h"

static NSString *const kFGAppId = kAppleId;  ///< 获取到当前应用的 app id 1049732608(测试用) 1318129281(美云)
static NSString *const kAppStoreVersion = @"appStoreVersion";  ///< userDefaults key


@implementation FGAppStoreVersionManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setup];
    });
    return sharedInstance;
}

#pragma mark - Private Methods

//设置
- (void)setup
{
    //企业版本发布不做appstore上架屏蔽处理
    if (kIsInhouse) {
        self.isNewAppstoreVersion = @(NO);
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [userDefaults objectForKey:kAppStoreVersion];
    
    WeakSelf
    
    if (IsEmpty(version)) {
        [self compareVersionSuccess:^(NSString *version) {
            StrongSelf
            
            BOOL isNewVersion = [self isVersion:kBundleVersion biggerThanVersion:version];
            
            self.isNewAppstoreVersion = [NSNumber numberWithBool:isNewVersion];
            if (_compareBlock) {
                _compareBlock(isNewVersion);
            }
        }];
    }else{
        BOOL isNewVersion = [self isVersion:kBundleVersion biggerThanVersion:version];
        
        self.isNewAppstoreVersion = [NSNumber numberWithBool:isNewVersion];
    }
}

- (void)setCompareBlock:(void (^)(BOOL))compareBlock
{
    if (_compareBlock != compareBlock) {
        _compareBlock = compareBlock;
        
        //当第二次 执行时 NSUserDefaults保存有值 已判断好 就调用此接口
        if (self.isNewAppstoreVersion != nil && compareBlock) {
            _compareBlock(self.isNewAppstoreVersion.boolValue);
        }
    }
}


// 网络请求
- (void)compareVersionSuccess:(void (^)(NSString *version))success
{
    if (IsEmpty(kFGAppId)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还未填写app id " preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
        [kKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
        DLog(@"警告 获取AppStore 版本 还未填写app id");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kFGAppId];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        NSString *version;
        if(!IsEmpty(array)){
            NSDictionary *dict = [array lastObject];
            version = dict[@"version"];
        }else{
            version = @"0";
        }
        
        if (success) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:version forKey:kAppStoreVersion];
            [userDefaults synchronize];
            
            success(version);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(@"0");
        DLog(@"警告 获取AppStore 版本 错误");
    }];
}


// 比较 版本
- (BOOL)isVersion:(NSString*)versionA biggerThanVersion:(NSString*)versionB
{
    NSArray *arrayNow = [versionB componentsSeparatedByString:@"."];
    NSArray *arrayNew = [versionA componentsSeparatedByString:@"."];
    BOOL isBigger = NO;
    NSInteger i = arrayNew.count > arrayNow.count? arrayNow.count : arrayNew.count;
    NSInteger j = 0;
    BOOL hasResult = NO;
    for (j = 0; j < i; j ++) {
        NSString* strNew = [arrayNew objectAtIndex:j];
        NSString* strNow = [arrayNow objectAtIndex:j];
        if ([strNew integerValue] > [strNow integerValue]) {
            hasResult = YES;
            isBigger = YES;
            break;
        }
        if ([strNew integerValue] < [strNow integerValue]) {
            hasResult = YES;
            isBigger = NO;
            break;
        }
    }
    if (!hasResult) {
        if (arrayNew.count > arrayNow.count) {
            NSInteger nTmp = 0;
            NSInteger k = 0;
            for (k = arrayNow.count; k < arrayNew.count; k++) {
                nTmp += [[arrayNew objectAtIndex:k]integerValue];
            }
            if (nTmp > 0) {
                isBigger = YES;
            }
        }
    }
    return isBigger;
}


@end
