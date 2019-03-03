//
//  FGImageGroupView.h
//  yulala
//
//  Created by Minimac on 2018/10/17.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "FGBaseView.h"

@interface FGImageGroupView : FGBaseView
@property (nonatomic, assign) NSInteger columnCout;  ///< 每行列数,默认为3
@property (nonatomic, assign) CGFloat space;  ///< 间隔,默认5
@property (nonatomic, assign) UIEdgeInsets edgeInsets;  ///< 上下左右间隔,默认10
@property (nonatomic, copy) NSArray <NSString *>*dataSource;  ///< 图片 url 字符串

@property (nonatomic, copy) void ((^didSelectItem)(NSIndexPath *indexPath));  ///<

@property (nonatomic, assign) CGFloat fg_height;  ///< <#name#>
@end
