//
//  FGAliyunOSSManager.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>

@interface FGAliyunOSSManager : NSObject

+ (instancetype)sharedInstance;

// 同步上传
- (void)uploadImageSyncWithBucket:(NSString *)bucket
                         mimeType:(NSString *)mimeType
                             data:(NSData *)uploadData
                         progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress
                          success:(void (^)(NSString *absoluteUrlString))success
                          failure:(void (^)(NSString *msg))failure;

//异步上传
- (void)uploadImageAsyncWithBucket:(NSString *)bucket
                          mimeType:(NSString *)mimeType
                              data:(NSData *)uploadData
                          progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress
                           success:(void (^)(NSString *absoluteUrlString))success
                           failure:(void (^)(NSString *msg))failure;

- (void)uploadFileAsyncWithBucket:(NSString *)bucket
                         mimeType:(NSString *)mimeType
                          fileUrl:(NSURL *)url
                         progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress
                          success:(void (^)(NSString *absoluteUrlString))success
                          failure:(void (^)(NSString *msg))failure;

@end
