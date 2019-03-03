//
//  FGSheetPopControl.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGSheetPopControl : UIControl

@property (nonatomic, strong, readonly) UIView *wrapView;
@property (nonatomic, strong, readonly) UIButton *cancelBtn;
@property (nonatomic, copy) void (^didSelectedIndex) (NSInteger index);

- (void)show;
- (void)dismiss;

@end
