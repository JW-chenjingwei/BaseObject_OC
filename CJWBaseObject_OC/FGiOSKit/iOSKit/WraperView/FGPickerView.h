//
//  FGPickerView.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGPickerView : UIControl

@property (nonatomic, copy) void (^didSeclectedItem) (NSInteger index, NSString *title);
@property (nonatomic, strong) NSArray *dataSourceArr;

- (instancetype)initWithDataSourceArr:(NSArray *)dataSourceArr seletedRow:(NSInteger)index andtitle:(NSString *)title;
- (void)show;

@end
