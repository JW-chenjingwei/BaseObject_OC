//
//  ICShareManager.h
//  ichezhidao
//
//  Created by 陈经纬 on 16/8/29.
//  Copyright © 2016年 figo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import "FGiOSKit.h"

/**
 *  分享 Model
 */
@interface FGShareModel : NSObject

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *url;

@end

/**微信好友 */
static NSString *const FGShareToWechatSession = @"FGShareToWechatSession";

/**微信朋友圈*/
static NSString *const FGShareToWechatTimeline = @"FGShareToWechatTimeline";

/** 新浪微博 */
static NSString *const FGShareToSina = @"FGShareToSina";

/** QQ */
static NSString *const FGShareToQQ = @"FGShareToQQ";

/** Facebook */
static NSString *const FGShareToFacebook = @"FGShareToFacebook";


@interface FGShareManager : NSObject

+ (instancetype)sharedInstance;

//分享到指定平台
- (void)setShareType:(NSString *)typeString shareModel:(FGShareModel *)sModel;



@end
