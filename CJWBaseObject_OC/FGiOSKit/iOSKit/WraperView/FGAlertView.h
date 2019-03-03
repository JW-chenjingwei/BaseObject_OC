//
//  FGAlertView.h
//  yanzhi
//
//  Created by 陈经纬 on 2017/11/10.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGAlertView : UIControl

- (void)show;
@property (nonatomic, copy) void (^didSelected) (BOOL isCancel);
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message btnNames:(NSArray *)btnNames;

@end
