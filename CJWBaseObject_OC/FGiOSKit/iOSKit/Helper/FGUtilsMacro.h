//
//  FGUtilsMacro.h
//  XiangJianApp
//
//  Created by 陈经纬 on 16/1/14.
//  Copyright © 2016年 陈经纬. All rights reserved.
//

#ifndef FGUtilsMacro_h
#define FGUtilsMacro_h

#pragma mark - log

#ifdef DEBUG
#define DString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DLog(...) printf("\n************\n%s 第%d行: %s\n************\n", [DString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#endif

#pragma mark - 用户资料

#define kIsInhouse [kBundleId hasSuffix:@"inhouse"]
#define kIsNewVersion [FGAppStoreVersionManager sharedInstance].isNewAppstoreVersion.boolValue

#pragma mark - filepath

//Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark - normal

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kKeyWindow ((UIWindow *)[UIApplication sharedApplication].keyWindow)
#define UIImageWithName(imageName) [UIImage imageNamed:imageName]
#define kBundleVersion ((NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define kBundleId [[NSBundle mainBundle] bundleIdentifier]

#pragma mark - device

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#pragma mark - screen

#define iPhone4Or4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5Or5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREEN_Ratio_W ([UIScreen mainScreen].bounds.size.width/414)
#define SCREEN_Ratio_H ([UIScreen mainScreen].bounds.size.height/736)

#pragma mark - system
//iOS版本号
#define iOS11OrLater ([[[UIDevice currentDevice] systemVersion]doubleValue]>=11.0f)
#define iOS10OrLater ([[[UIDevice currentDevice] systemVersion]doubleValue]>=10.0f)
#define iOS9OrLater ([[[UIDevice currentDevice] systemVersion]doubleValue]>=9.0f)
#define iOS8OrLater ([[[UIDevice currentDevice] systemVersion]doubleValue]>=8.0f)
#define iOS7OrLater ([[[UIDevice currentDevice] systemVersion]doubleValue]>=7.0f)

#pragma mark - color
//颜色相关
#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)
#define UIColorFromRandom                   [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0];

#pragma mark - indexPath

#define INDEX_PATH(a,b) [NSIndexPath indexPathWithIndexes:(NSUInteger[]){a,b} length:2]

#pragma mark - transforms

#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180

#pragma mark - other

#define kOnePixel 0.5

/*
弱引用/强引用  可配对引用在外面用WeakSelf(self)，block用StrongSelf(self)
也可以单独引用在外面用ICWeakSelf(self) block里面用weakself
 */
#define Weakify(type)  __weak typeof(type) weak##type = type;
#define Strongify(type)  __strong typeof(type) type = weak##type;

#define WeakSelf  Weakify(self);
#define StrongSelf  Strongify(self);

#define kScreenScale ([UIScreen mainScreen].scale)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

//字体适配(目前统一使用系统默认字体)
#define AdaptedFontSize(R)     [UIFont systemFontOfSize:AdaptedWidth(R)]
#define AdaptedBoldFontSize(R)  [UIFont boldSystemFontOfSize:AdaptedWidth(R)]

//不同屏幕尺寸适配（414，736是因为效果图为iPhone6plus如果不是则根据实际情况修改）
#define kScreenWidthRatio  (kScreenWidth / 414.0)
#define kScreenHeightRatio (kScreenHeight / 736.0)
#define AdaptedWidth(x)  ceilf((x) * (IS_IPAD ? 1 : kScreenWidthRatio))
#define AdaptedHeight(x) ceilf((x) * (IS_IPAD ? 1:kScreenHeightRatio))

//网络请求api方法简写
#define Api(method, class) - (void)method##WithParameter:(NSMutableDictionary *)parameter success:(void (^)(class result))success failure:(void (^)(NSString *msg))failure


#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kNavBarHeight (kStatusBarHeight + 44)

#pragma mark - static method

#define isDictionary(object)  [object isKindOfClass:[NSDictionary class]]                       ///< 判断是否为字典
#define isArray(object) [object  isKindOfClass:[NSArray class]]                                 ///< 判断是否为数组
#define isEqualString(str1,str2)   [str1 isEqualToString:str2]                                  ///< 判断是否为字符串
#define isKindClass(class1,class2)  [class1 isKindOfClass:NSClassFromString(class2)]            ///< 判断是否为同一个类
#define noNillString(object)  IsEmpty(object) ? @"" : object                                    ///< 返回一个不为Null的字符串
#define ifElse(class1,class2)  IsEmpty(class1) ? class2 : class1                                ///< 简便的双目运算符
#define NSStringFormat(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]
#define StringEncoding(string) [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ///<去除含中文的url
#define URLString(string) [NSURL URLWithString:StringEncoding(string)]

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define UIColorTheme UIColorFromHex(kColorTheme)
#define AdaptedScreenBottom(x) iPhoneX ? ceilf((x - 34) * kScreenWidthRatio) : ceilf((x) * kScreenWidthRatio)

static inline BOOL IsEmpty(id thing) {
    
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

static inline id objectForKey(NSDictionary *dict, NSString *key)
{
    if (!([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]])) {
        return nil;
    }
    if (dict.count == 0 || !dict)
    {
        return nil;
    }
    if (!key) {
        return nil;
    }
    id object = [dict objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;
}

static inline id objectAtArrayIndex(NSArray *array, NSUInteger index)
{
    if (!([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]])) {
        return nil;
    }
    if (array && array.count > index) {
        return array[index];
    } else {
        return nil;
    }
}

static inline void onMainThreadAsync(void (^block)(void))
{
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

#endif /* FGUtilsMacro_h */
