//
//  FGPickerView.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGPickerView.h"
#import "FGiOSKit.h"

@interface FGPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, assign) BOOL isCompleteAnimation;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *middleTitle;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UIView *middleLine;

@end

@implementation FGPickerView
- (instancetype)initWithDataSourceArr:(NSArray *)dataSourceArr seletedRow:(NSInteger)index andtitle:(NSString *)title
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _dataSourceArr = dataSourceArr;
        _selectedIndex = index;
        _middleTitle = title;
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
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    self.cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.cancelBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.cancelBtn];
    
    self.certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.certainBtn setTitle:@"完成" forState:UIControlStateNormal];
    //    self.certainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.certainBtn setTitleColor:UIColorFromHex(0xCBA567) forState:UIControlStateNormal];
    self.certainBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.certainBtn addTarget:self action:@selector(certainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.certainBtn];
    
    if (!IsEmpty(self.middleTitle)) {
        self.middleLabel = [UILabel new];
        self.middleLabel.text = self.middleTitle;
        self.middleLabel.textAlignment = NSTextAlignmentCenter;
        self.middleLabel.textColor = UIColorFromHex(0x4D4D4D);
        self.middleLabel.font = [UIFont systemFontOfSize:18];
        [self.containerView addSubview:self.middleLabel];
    }
    
    self.middleLine = [UIView new];
    self.middleLine.backgroundColor = UIColorFromHex(kColorLine);
    [self.containerView addSubview:self.middleLine];
    
    self.pickerView = [UIPickerView new];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self .containerView addSubview:self.pickerView];
    [self.pickerView selectRow:self.selectedIndex inComponent:0 animated:YES];
    
}

- (void)setupLayout
{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.width.mas_equalTo(60);
        make.top.equalTo(self.containerView).offset(10);
    }];
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView);
        make.width.mas_equalTo(60);
        make.top.equalTo(self.containerView).offset(10);
    }];
    
    if (!IsEmpty(self.middleTitle)) {
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView.mas_centerX);
            make.centerY.equalTo(self.certainBtn.mas_centerY);
            
        }];
    }
    
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kOnePixel);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom);
        make.bottom.left.right.equalTo(self.containerView);
    }];
}

- (void)certainAction
{
    if (self.dataSourceArr.count == 0) {
        [self dismiss];
        return;
    }
    if (self.didSeclectedItem) {
        self.didSeclectedItem(self.selectedIndex, self.dataSourceArr[self.selectedIndex]);
    }
    [self dismiss];
}

- (void)show
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [kKeyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(kKeyWindow);
    }];
    
    // 提交固定layout
    [self layoutIfNeeded];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.isCompleteAnimation = NO;
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
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

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSourceArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataSourceArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}


@end
