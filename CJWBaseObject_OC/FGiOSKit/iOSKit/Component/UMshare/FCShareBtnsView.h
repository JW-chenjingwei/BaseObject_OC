//
//  ICGroupBtnsView.h
//  ichezhidao
//
//  Created by 陈经纬 on 16/7/7.
//  Copyright © 2016年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseTouchView.h"
#import "FGiOSKit.h"

@interface FCShareBtnsView : FGBaseTouchView

@property (nonatomic, strong) UIColor *btnTitleColor;
@property (nonatomic, strong) UIColor *btnBackgroundColor;
@property (nonatomic, strong) UIFont *btnTitleFont;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, copy) void (^didSelectedIndex) (NSInteger index);
/**
 *  @param arr    图片+标题打包的字典数组
 *  @param column 列数
 */
- (instancetype)initWithTitleAndImgsArr:(NSArray *)arr column:(NSInteger)column isAddLine:(BOOL)isAdd;
@end
