//
//  FGAliyunOSSManager.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGAliyunOSSManager.h"
#import "FGiOSKit.h"

NSString * const multipartUploadKey = @"multipartUploadObject";

OSSClient * client;

@implementation FGAliyunOSSManager

+ (instancetype)sharedInstance
{
    static FGAliyunOSSManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FGAliyunOSSManager alloc] init];
        [sharedInstance initOSSClient];
    });
    return sharedInstance;
}

- (void)initOSSClient {
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:OSS_ACCESS_KEY
                                                                                                            secretKey:OSS_SECRET_KEY];
    
    // 自实现签名，可以用本地签名也可以远程加签
    //    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
    //        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:XJ_OSS_ACCESS_KEY];
    //        if (signature != nil) {
    //            *error = nil;
    //        } else {
    //            // construct error object
    //            *error = [NSError errorWithDomain:@"<your error domain>" code:OSSClientErrorCodeSignFailed userInfo:nil];
    //            return nil;
    //        }
    //        return [NSString stringWithFormat:@"OSS %@:%@", XJ_OSS_SECRET_KEY, signature];
    //    }];
    
    
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    conf.proxyHost = OSS_DIMAO;
    
    client = [[OSSClient alloc] initWithEndpoint:OSS_HOST credentialProvider:credential clientConfiguration:conf];
}

// get local file dir which is readwrite able
- (NSString *)getDocumentDirectory {
    NSString * path = NSHomeDirectory();
    NSLog(@"NSHomeDirectory:%@",path);
    NSString * userName = NSUserName();
    NSString * rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

#pragma mark work with normal interface

- (void)createBucket {
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = @"<bucketName>";
    create.xOssACL = @"public-read";
    create.location = @"oss-cn-hangzhou";
    
    OSSTask * createTask = [client createBucket:create];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)deleteBucket {
    OSSDeleteBucketRequest * delete = [OSSDeleteBucketRequest new];
    delete.bucketName = @"<bucketName>";
    
    OSSTask * deleteTask = [client deleteBucket:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete bucket success!");
        } else {
            NSLog(@"delete bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)listObjectsInBucket {
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = @"android-test";
    getBucket.delimiter = @"";
    getBucket.prefix = @"";
    
    
    OSSTask * getBucketTask = [client getBucket:getBucket];
    
    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSLog(@"list object: %@", objectInfo);
            }
        } else {
            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

// 异步上传
- (void)uploadObjectAsync {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = @"android-test";
    put.objectKey = @"file1m";
    NSString * docDir = [self getDocumentDirectory];
    put.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

- (void)uploadFileAsyncWithBucket:(NSString *)bucket
                         mimeType:(NSString *)mimeType
                          fileUrl:(NSURL *)url
                         progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress
                          success:(void (^)(NSString *absoluteUrlString))success
                          failure:(void (^)(NSString *msg))failure
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    //#warning 待完成
    //获取系统微秒时间戳
    //    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *encryptName;// = [[NSString stringWithFormat:@"%@%@%lld",[XJUserInfomanager sharedInstance].userInfo.user_id, [XJUserInfomanager sharedInstance].userInfo.username, recordTime] md5String];
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    NSString *objectKey = [NSString stringWithFormat:@"%@/%@/%@.%@",OSS_VOICE_DIR, locationString, encryptName,mimeType];
    put.bucketName = OSS_BUCKET;
    put.objectKey = objectKey;
    put.uploadingFileURL = url;
    put.contentType = mimeType;
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (progress) {
            progress(bytesSent, totalByteSent, totalBytesExpectedToSend);
        }
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
            if (success) {
                success([NSString stringWithFormat:@"%@/%@", OSS_DIMAO, objectKey]);
            }
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if (failure) {
                failure(@"上传失败");
            }
        }
        return nil;
    }];
    
}

- (void)uploadImageAsyncWithBucket:(NSString *)bucket
                          mimeType:(NSString *)mimeType
                              data:(NSData *)uploadData
                          progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress
                           success:(void (^)(NSString *absoluteUrlString))success
                           failure:(void (^)(NSString *msg))failure
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    //获取系统秒时间戳
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =  @"yyyy/MM/dd";
    NSString *formatterString = [formatter stringFromDate:date];
    
    int randomNum = random()%10000;
    
    NSString *suffix = [NSString stringWithFormat:@"u%@_%lld_%.4d",@"", recordTime, randomNum];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.%@",OSS_AVATAR_DIR,formatterString,suffix,mimeType];
    
    // 可以根据 bucket 判断上传的文件夹
    if ([bucket isEqualToString:@"video"]) {
        path = [NSString stringWithFormat:@"%@/%@/%@.%@",OSS_VIDEO_DIR,formatterString,suffix,mimeType];
    }
    
    
    put.bucketName = OSS_BUCKET;
    put.objectKey = path;
    put.uploadingData = uploadData;
    put.contentType = mimeType;
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (progress) {
            progress(bytesSent, totalByteSent, totalBytesExpectedToSend);
        }
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
            if (success) {
                success(path);
                //                success([NSString stringWithFormat:@"%@/%@", XJ_OSS_DIMAO, path]);
            }
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if (failure) {
                failure(@"上传失败");
            }
        }
        return nil;
    }];
}

// 同步上传
- (void)uploadObjectSync {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = @"android-test";
    put.objectKey = @"file1m";
    NSString * docDir = [self getDocumentDirectory];
    put.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
        NSLog(@"upload object success!");
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
    }
}
- (void)uploadImageSyncWithBucket:(NSString *)bucket
                         mimeType:(NSString *)mimeType
                             data:(NSData *)uploadData
                         progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress
                          success:(void (^)(NSString *absoluteUrlString))success
                          failure:(void (^)(NSString *msg))failure
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    //获取系统秒时间戳
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =  @"yyyy/MM/dd";
    NSString *formatterString = [formatter stringFromDate:date];
    
    int randomNum = random()%10000;
    
    NSString *suffix = [NSString stringWithFormat:@"u%@_%lld_%.4d",@"", recordTime, randomNum];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.%@",OSS_AVATAR_DIR,formatterString,suffix,mimeType];
    
    put.bucketName = OSS_BUCKET;
    put.objectKey = path;
    put.uploadingData = uploadData;
    put.contentType = mimeType;
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (progress) {
            progress(bytesSent, totalByteSent, totalBytesExpectedToSend);
        }
    };
    
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
        NSLog(@"upload object success!");
        if (success) {
            //            success(path);
            success([NSString stringWithFormat:@"%@/%@", OSS_DIMAO, path]);
        }
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
        if (failure) {
            failure(@"上传失败");
        }
    }
}


// 追加上传

- (void)appendObject {
    OSSAppendObjectRequest * append = [OSSAppendObjectRequest new];
    
    // 必填字段
    append.bucketName = @"android-test";
    append.objectKey = @"file1m";
    append.appendPosition = 0; // 指定从何处进行追加
    NSString * docDir = [self getDocumentDirectory];
    append.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // 可选字段
    append.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    // append.contentType = @"";
    // append.contentMd5 = @"";
    // append.contentEncoding = @"";
    // append.contentDisposition = @"";
    
    OSSTask * appendTask = [client appendObject:append];
    
    [appendTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", append.objectKey);
        if (!task.error) {
            NSLog(@"append object success!");
            //            OSSAppendObjectResult * result = task.result;
            //            NSString * etag = result.eTag;
            //            long nextPosition = result.xOssNextAppendPosition;
        } else {
            NSLog(@"append object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

// 异步下载
- (void)downloadObjectAsync {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = @"android-test";
    request.objectKey = @"file1m";
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

// 同步下载
- (void)downloadObjectSync {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = @"android-test";
    request.objectKey = @"file1m";
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask waitUntilFinished];
    
    if (!getTask.error) {
        OSSGetObjectResult * result = getTask.result;
        NSLog(@"download data length: %lu", [result.downloadedData length]);
    } else {
        NSLog(@"download data error: %@", getTask.error);
    }
}

// 获取meta
- (void)headObject {
    OSSHeadObjectRequest * head = [OSSHeadObjectRequest new];
    head.bucketName = @"android-test";
    head.objectKey = @"file1m";
    
    OSSTask * headTask = [client headObject:head];
    
    [headTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSHeadObjectResult * headResult = task.result;
            NSLog(@"all response header: %@", headResult.httpResponseHeaderFields);
            
            // some object properties include the 'x-oss-meta-*'s
            NSLog(@"head object result: %@", headResult.objectMeta);
        } else {
            NSLog(@"head object error: %@", task.error);
        }
        return nil;
    }];
}

// 删除Object
- (void)deleteObject {
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = @"android-test";
    delete.objectKey = @"file1m";
    
    OSSTask * deleteTask = [client deleteObject:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete success !");
        } else {
            NSLog(@"delete erorr, error: %@", task.error);
        }
        return nil;
    }];
}

// 复制Object
- (void)copyObjectAsync {
    OSSCopyObjectRequest * copy = [OSSCopyObjectRequest new];
    copy.bucketName = @"android-test"; // 复制到哪个bucket
    copy.objectKey = @"file_copy_to"; // 复制为哪个object
    copy.sourceCopyFrom = [NSString stringWithFormat:@"/%@/%@", @"android-test", @"file1m"]; // 从哪里复制
    
    OSSTask * copyTask = [client copyObject:copy];
    
    [copyTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"copy success!");
        } else {
            NSLog(@"copy error, error: %@", task.error);
        }
        return nil;
    }];
}

// 签名URL授予第三方访问
- (void)signAccessObjectURL {
    NSString * constrainURL = nil;
    NSString * publicURL = nil;
    
    // sign constrain url
    OSSTask * task = [client presignConstrainURLWithBucketName:@"<bucket name>"
                                                 withObjectKey:@"<object key>"
                                        withExpirationInterval:60 * 30];
    if (!task.error) {
        constrainURL = task.result;
    } else {
        NSLog(@"error: %@", task.error);
    }
    
    // sign public url
    task = [client presignPublicURLWithBucketName:@"<bucket name>"
                                    withObjectKey:@"<object key>"];
    if (!task.error) {
        publicURL = task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
    }
}

// 分块上传
- (void)multipartUpload {
    
    __block NSString * uploadId = nil;
    __block NSMutableArray * partInfos = [NSMutableArray new];
    
    NSString * uploadToBucket = @"android-test";
    NSString * uploadObjectkey = @"file3m";
    
    OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
    init.bucketName = uploadToBucket;
    init.objectKey = uploadObjectkey;
    init.contentType = @"application/octet-stream";
    init.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    
    OSSTask * initTask = [client multipartUploadInit:init];
    
    [initTask waitUntilFinished];
    
    if (!initTask.error) {
        OSSInitMultipartUploadResult * result = initTask.result;
        uploadId = result.uploadId;
        NSLog(@"init multipart upload success: %@", result.uploadId);
    } else {
        NSLog(@"multipart upload failed, error: %@", initTask.error);
        return;
    }
    
    for (int i = 1; i <= 3; i++) {
        OSSUploadPartRequest * uploadPart = [OSSUploadPartRequest new];
        uploadPart.bucketName = uploadToBucket;
        uploadPart.objectkey = uploadObjectkey;
        uploadPart.uploadId = uploadId;
        uploadPart.partNumber = i; // part number start from 1
        
        NSString * docDir = [self getDocumentDirectory];
        uploadPart.uploadPartFileURL = [NSURL URLWithString:[docDir stringByAppendingPathComponent:@"file1m"]];
        
        OSSTask * uploadPartTask = [client uploadPart:uploadPart];
        
        [uploadPartTask waitUntilFinished];
        
        if (!uploadPartTask.error) {
            OSSUploadPartResult * result = uploadPartTask.result;
            uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:uploadPart.uploadPartFileURL.absoluteString error:nil] fileSize];
            [partInfos addObject:[OSSPartInfo partInfoWithPartNum:i eTag:result.eTag size:fileSize]];
        } else {
            NSLog(@"upload part error: %@", uploadPartTask.error);
            return;
        }
    }
    
    OSSCompleteMultipartUploadRequest * complete = [OSSCompleteMultipartUploadRequest new];
    complete.bucketName = uploadToBucket;
    complete.objectKey = uploadObjectkey;
    complete.uploadId = uploadId;
    complete.partInfos = partInfos;
    
    OSSTask * completeTask = [client completeMultipartUpload:complete];
    
    [completeTask waitUntilFinished];
    
    if (!completeTask.error) {
        NSLog(@"multipart upload success!");
    } else {
        NSLog(@"multipart upload failed, error: %@", completeTask.error);
        return;
    }
}

// 罗列分块
- (void)listParts {
    OSSListPartsRequest * listParts = [OSSListPartsRequest new];
    listParts.bucketName = @"android-test";
    listParts.objectKey = @"file3m";
    listParts.uploadId = @"265B84D863B64C80BA552959B8B207F0";
    
    OSSTask * listPartTask = [client listParts:listParts];
    
    [listPartTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"list part result success!");
            OSSListPartsResult * listPartResult = task.result;
            for (NSDictionary * partInfo in listPartResult.parts) {
                NSLog(@"each part: %@", partInfo);
            }
        } else {
            NSLog(@"list part result error: %@", task.error);
        }
        return nil;
    }];
}

// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;
    
    NSString * docDir = [self getDocumentDirectory];
    NSString * filePath = [docDir stringByAppendingPathComponent:@"file1m"];
    NSString * bucketName = @"android-test";
    NSString * objectKey = @"uploadKey";
    
    
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:filePath], lastModified];
        // 通过记录键查看本地是否保存有未完成的UploadId
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
            initMultipart.bucketName = bucketName;
            initMultipart.objectKey = objectKey;
            initMultipart.contentType = @"application/octet-stream";
            return [client multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        NSString * uploadId = nil;
        
        if (task.error) {
            return task;
        }
        
        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
        } else {
            uploadId = task.result;
        }
        
        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeNilUploadid
                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        resumableUpload.bucketName = bucketName;
        resumableUpload.objectKey = objectKey;
        resumableUpload.uploadId = task.result;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        };
        return [client resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            }
        } else {
            NSLog(@"upload completed!");
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
}

#pragma mark work with compatible interface

- (void)oldGetObjectStyle {
    //    OSSTaskHandler * tk =
    [client downloadToDataFromBucket:@"android-test"
                           objectKey:@"file1m"
                         onCompleted:^(NSData * data, NSError * error) {
                             if (error) {
                                 NSLog(@"download object failed, erorr: %@", error);
                             } else {
                                 NSLog(@"download object success, data length: %ld", [data length]);
                             }
                         } onProgress:^(float progress) {
                             NSLog(@"progress: %f", progress);
                         }];
    
    // [tk cancel];
}

- (void)oldPutObjectStyle {
    
    NSString * doctDir = [self getDocumentDirectory];
    NSString * filePath = [doctDir stringByAppendingPathComponent:@"file10m"];
    
    NSDictionary * objectMeta = @{@"x-oss-meta-name1": @"value1"};
    
    //    OSSTaskHandler * tk =
    [client uploadFile:filePath
       withContentType:@"application/octet-stream"
        withObjectMeta:objectMeta
          toBucketName:@"android-test"
           toObjectKey:@"file10m"
           onCompleted:^(BOOL isSuccess, NSError * error) {
               if (error) {
                   NSLog(@"upload object failed, erorr: %@", error);
               } else {
                   NSLog(@"upload object success!");
               }
           } onProgress:^(float progress) {
               NSLog(@"progress: %f", progress);
           }];
    
}

- (void)oldResumableUploadStyle {
    
    NSString * doctDir = [self getDocumentDirectory];
    NSString * filePath = [doctDir stringByAppendingPathComponent:@"file10m"];
    
    OSSTaskHandler * tk = [client resumableUploadFile:filePath
                                      withContentType:@"application/octet-stream"
                                       withObjectMeta:nil
                                         toBucketName:@"android-test"
                                          toObjectKey:@"file10m"
                                          onCompleted:^(BOOL isSuccess, NSError * error) {
                                              if (error) {
                                                  NSLog(@"resumable upload object failed, erorr: %@", error);
                                              } else {
                                                  NSLog(@"resumable upload object success!");
                                              }
                                          } onProgress:^(float progress) {
                                              NSLog(@"progress: %f", progress);
                                          }];
    [tk cancel];
}

@end
