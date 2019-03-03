//
//  FGTimePicker.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGTimePicker.h"
#import "FGiOSKit.h"

@interface FGTimePicker ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) BOOL isCompleteAnimation;

@end

@implementation FGTimePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    self.titleLable = [UILabel new];
    self.titleLable.text = @"出生日期";
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.textColor = UIColorFromHex(0x4D4D4D);
    self.titleLable.font = [UIFont systemFontOfSize:18];
    [self.containerView addSubview:self.titleLable];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.cancelBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.cancelBtn];
    
    self.certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.certainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.certainBtn setTitleColor:UIColorFromHex(0xCBA567) forState:UIControlStateNormal];
    self.certainBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.certainBtn addTarget:self action:@selector(certainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.certainBtn];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = UIColorFromHex(kColorLine);
    [self.containerView addSubview:self.lineView];
    
    self.datePicker = [UIDatePicker new];
    //只能选择当前时间开始30天以内的时间
    //    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //    self.datePicker.maximumDate = [NSDate dateWithTimeInterval:30 * 24 * 60 * 60 sinceDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.containerView addSubview:self.datePicker];
    
    self.dateFormatter = @"yyyy.MM.dd HH:mm";
}

- (void)setupLayout
{
    WeakSelf
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.containerView).offset(20);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(self.containerView).offset(20);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(self.titleLable);
    }];
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.right.equalTo(self.containerView).offset(-20);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(self.titleLable);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(self.titleLable.mas_bottom).offset(20);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kOnePixel);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.left.right.equalTo(self.containerView);
    }];
}

- (void)setDefaultDate:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    [self.datePicker setDate:date animated:NO];
}

- (void)setTitleString:(NSString *)title
{
    self.titleLable.text = title;
}

- (void)certainAction
{
    if (self.didSeclectedTime) {
        self.didSeclectedTime([self timeStamp], [self timeFormat]);
    }
    [self dismiss];
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
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self);
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

//获取当前选择的格式日期
- (NSString *)timeFormat
{
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.dateFormatter];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

//获取当前选择的时间戳，精确毫秒
- (NSString *)timeStamp
{
    
    NSDate *selected = [self.datePicker date];
    NSTimeInterval time = [selected timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",(time * 1000)];
    return timeString;
}

@end
