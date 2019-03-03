//
//  FGFGAdvertiseHelper.m
//  shopex
//
//  Created by 陈经纬 on 17/3/28.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGAdvertiseHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "FGAdvertiseVedioView.h"
#import "AppDelegate.h"
#import "FGiOSKit.h"

@implementation FGAdvertiseHelper

+ (instancetype)sharedInstance
{
    static FGAdvertiseHelper* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FGAdvertiseHelper new];
    });
    
    return instance;
}


+(void)showAdvertiserViewShow
{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *fileImagePath = [[FGAdvertiseHelper sharedInstance] getFilePathWithImageName:[kAdUserDefaults valueForKey:adImageName]];
    
    BOOL isImageExist = [[FGAdvertiseHelper sharedInstance] isFileExistWithFilePath:fileImagePath];
    if (isImageExist) {// 图片存在
        FGAdvertiseView *advertiseView = [[FGAdvertiseView alloc] initWithFrame:kAdMain_Screen_Bounds];
        advertiseView.filePath = fileImagePath;
        [advertiseView show];
        [[FGAdvertiseHelper sharedInstance] getAdvertisingImageVedio];
        return;
       
    }
    
    NSString *fileVedioPath = [[FGAdvertiseHelper sharedInstance] getFilePathWithImageName:[kAdUserDefaults valueForKey:adVedioName]];
    
    BOOL isVedioExist = [[FGAdvertiseHelper sharedInstance] isFileExistWithFilePath:fileVedioPath];
    if (isVedioExist) {

        FGAdvertiseVedioView *vedioView = [[FGAdvertiseVedioView alloc]initWithFrame:kKeyWindow.bounds fileVedioPath:fileVedioPath];
        [kKeyWindow addSubview:vedioView];
        [vedioView play];

    }
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [[FGAdvertiseHelper sharedInstance] getAdvertisingImageVedio];
}


/**
 *  初始化广告页面
 */
- (void)getAdvertisingImageVedio
{
    
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}


/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            [self deleteOldImage];
            [kAdUserDefaults setValue:imageName forKey:adImageName];
            [kAdUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
        }
        
    });
}

/**
 *  下载视频
 */
- (void)downloadAdVedioWithUrl:(NSString *)vedioUrl VedioName:(NSString *)vedioName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:vedioUrl]];
        
//        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:vedioName]; // 保存文件的名称
        
        if ([data writeToFile:filePath atomically:YES]) {// 保存成功
            [self deleteOldImage];
            [kAdUserDefaults setValue:vedioName forKey:adVedioName];
            [kAdUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
        }
        
    });
}
/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kAdUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    NSString *vedioName = [kAdUserDefaults valueForKey:adVedioName];
    if (vedioName) {
        NSString *filePath = [self getFilePathWithImageName:vedioName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

@end
