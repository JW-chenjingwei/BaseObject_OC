//
//  FGAppStoreVersionManager.h
//  DaoShiBiao
//
//  Created by 陈经纬 on 2017/9/4.
//  Copyright © 2017年 陈经纬. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 获取 App Store 上版本的管理类 推荐使用 block 来判断
 使用时  需要更换 app id
 */
@interface FGAppStoreVersionManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) void (^compareBlock) (BOOL isNewVersion);  ///< 比较是否为最新版本

@property (nonatomic, copy) NSNumber *isNewAppstoreVersion;  ///< 是否为appstore最新版本


@end
