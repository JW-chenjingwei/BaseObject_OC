//
//  FGTools.m
//  dingdingxuefu
//
//  Created by 陈经纬 on 2018/8/8.
//

#import "FGTools.h"
#import <NSString+JKScore.h>
#import <NSString+JKPinyin.h>
#import <NSString+JKContains.h>
#import <NSString+JKTrims.h>

@implementation FGTools

//启动图
+ (UIImage *)getLaunchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOr = @"Portrait";//垂直
    NSString *launchImage = nil;
    NSArray *launchImages =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in launchImages) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(viewSize, imageSize) && [viewOr isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
    
}

//APPicon
+ (UIImage *)appIcon
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:icon];
    return image;
}

+ (NSMutableAttributedString *)attributedWithString:(NSString *)string appendString:(NSString *)appendString attributes:(NSDictionary *)attributes
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:appendString attributes:attributes]];
    return str;
}

+ (NSMutableArray *)mergeWithArray:(NSArray *)array other:(NSArray *)other key:(NSString *)key
{
    //创建一个新的数组
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    
    for (id item in other) {
        // 取到数组元素中 指定的属性值
        id value = [item valueForKey:key];
        
        __block BOOL isExist = NO;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id valueOther = [obj valueForKey:key];
            if ([value isKindOfClass:[NSNumber class]]) {
                if ([value isEqualToNumber:valueOther]) {
                    isExist = YES;
                }
            }else if ([value isKindOfClass:[NSString class]]) {
                if ([value isEqualToString:valueOther]) {
                    isExist = YES;
                }
            }else{
                NSLog(@"选择的对比属性类型有误!请查看注释");
            }
        }];
        if (!isExist) {
            [newArray addObject:item];
        }
    }
    
    return newArray;
}

+ (BOOL)blurrySearchWithSource:(NSString *)source search:(NSString *)search
{
    //全部转小写
    search = [search lowercaseStringWithLocale:[NSLocale currentLocale]];
    //去除空格
    [search jk_trimmingWhitespace];
    
    //输入的内容包含汉字 搜索的内容不包含汉字
    if ([search jk_isContainChinese] || ![source jk_isContainChinese]) {
        if ([source containsString:search]) {
            return YES;
        }
    }else{
        //把汉字转为拼音
        NSString *pinyin = [source jk_pinyin];
        if ([pinyin jk_scoreAgainst:search] > 0) {
            return YES;
        }
    }
    return NO;
}
@end
