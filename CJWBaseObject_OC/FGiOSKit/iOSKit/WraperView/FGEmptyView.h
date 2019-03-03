//
//  FGEmptyView.h
//  hangyeshejiao
//
//  Created by 陈经纬 on 2018/4/19.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 占位图
 */
@interface FGEmptyView : UIView

@property (nonatomic, strong) UIImageView *emptyImg;  ///< 占位图片
@property (nonatomic, strong) UILabel *emptyLabel;  ///< 占位labal

@property (nonatomic, assign) CGFloat imageTopConstraint;  ///< 约束

/**
 创建占位图
 
 @param imageString 占位图片
 @param text 占位说明
 */
- (instancetype)initWithImageString:(NSString *)imageString text:(NSString *)text;

@end
