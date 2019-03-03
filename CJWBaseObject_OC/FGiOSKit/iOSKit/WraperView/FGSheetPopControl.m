//
//  FGSheetPopControl.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGSheetPopControl.h"
#import "FGiOSKit.h"

@interface FGSheetPopControl ()

@property (nonatomic, strong) UIView *wrapView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) BOOL isCompleteAnimation;

@end

@implementation FGSheetPopControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        _wrapView = [UIView new];
        _wrapView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_wrapView];
        
        [_wrapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromHex(0x5A6A8C) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = AdaptedFontSize(18);
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)show
{
    [kKeyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(kKeyWindow);
    }];
    
    // 提交固定layout
    [self layoutIfNeeded];
    
    WeakSelf
    [self.wrapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.right.bottom.equalTo(self);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        StrongSelf
        self.isCompleteAnimation = NO;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        StrongSelf
        self.isCompleteAnimation = YES;
    }];
}

- (void)dismiss
{
    if (!self.isCompleteAnimation) {
        return;
    }
    [self removeFromSuperview];
}

@end
