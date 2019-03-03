//
//  FGAreaPicker.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGAreaPicker.h"
#import <NSObject+YYModel.h>
#import "FGiOSKit.h"

@implementation FGCityModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{
//             @"addressId":@"region_id",
//             @"parentid":@"p_region_id",
//             @"name":@"local_name",
//             };
//}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
             @"addressId":@"region_id",
             @"parentid":@"p_region_id",
             @"name":@"local_name",
             };
}
@end

@interface FGAreaPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, assign) BOOL isCompleteAnimation;
@property (nonatomic, strong) UIPickerView *pickerView;

//@property (nonatomic, copy) NSString *middleTitle;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UIView *middleLine;


@property (nonatomic, strong) NSArray<FGCityModel*> *dataSourceArr;

@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;

@property (nonatomic, strong) FGCityModel *selctedProvince;
@property (nonatomic, strong) FGCityModel *selectedCity;
@property (nonatomic, strong) FGCityModel *selctedTown;

@end

@implementation FGAreaPicker

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fg_area.json" ofType:nil];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
        self.dataSourceArr = [NSArray modelArrayWithClass:[FGCityModel class] json:jsonData];
        //初始化数据源
        self.provinceArray = [self getOneLevelCityWithId:nil];
        
        FGCityModel *model1 = self.provinceArray.firstObject;
        self.cityArray = [self getOneLevelCityWithId:model1.addressId];
        
        FGCityModel *model2 = self.cityArray.firstObject;
        self.townArray = [self getOneLevelCityWithId:model2.addressId];
        
        self.selctedProvince = self.provinceArray[0];
        if (self.cityArray.count > 0) {
            self.selectedCity = self.cityArray[0];
        }else{
            self.selectedCity = nil;
        }
        if (self.townArray.count > 0) {
            self.selctedTown = self.townArray[0];
        }else{
            self.selctedTown = nil;
        }
        
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
    self.cancelBtn.titleLabel.font = AdaptedFontSize(18);
    [self.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.cancelBtn];
    
    self.certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    //    self.certainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.certainBtn setTitleColor:UIColorFromHex(0xCBA567) forState:UIControlStateNormal];
    self.certainBtn.titleLabel.font = AdaptedFontSize(18);
    [self.certainBtn addTarget:self action:@selector(certainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.certainBtn];
    
    self.middleLabel = [UILabel new];
    self.middleLabel.text = @"所在地区";
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel.textColor = UIColorFromHex(0x4D4D4D);
    self.middleLabel.font = AdaptedFontSize(18);
    [self.containerView addSubview:self.middleLabel];
    
    self.middleLine = [UIView new];
    self.middleLine.backgroundColor = UIColorFromHex(kColorLine);
    [self.containerView addSubview:self.middleLine];
    
    self.pickerView = [UIPickerView new];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.containerView addSubview:self.pickerView];
    
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
        make.centerY.equalTo(self.middleLabel);
    }];
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(self.middleLabel);
    }];
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.containerView).offset(12);
    }];
    
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kOnePixel);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleLine.mas_bottom);
        make.bottom.left.right.equalTo(self.containerView);
    }];
}

- (void)certainAction
{
    if (self.didSeclectedDone) {
        self.didSeclectedDone(self.selctedProvince, self.selectedCity, self.selctedTown);
    }
    [self dismiss];
}

- (void)show
{
    WeakSelf
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

/**
 *  获取具有相同父id的地址的集合
 *
 *  @param parentid 父id
 */
- (NSArray *)getOneLevelCityWithId:(NSNumber *)parentid
{
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"parentid == %@", parentid];
    NSArray *arr = [self.dataSourceArr filteredArrayUsingPredicate:predict];
    return arr;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 80;
    } else if (component == 1) {
        return (kScreenWidth - 80)/2;
    } else {
        return (kScreenWidth - 80)/2;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }else if(component == 1){
        return self.cityArray.count;
    }else if(component == 2){
        return self.townArray.count;
    }
    return 0;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lalTitle=(UILabel *)view;
    if (!lalTitle) {
        lalTitle=[[UILabel alloc] init];
        lalTitle.adjustsFontSizeToFitWidth=YES;//设置字体大小是否适应lalbel宽度
        lalTitle.textAlignment=NSTextAlignmentCenter;//文字居中显示
        [lalTitle setTextColor:[UIColor blackColor]];
        [lalTitle setFont:AdaptedFontSize(18)];
    }
    FGCityModel *model;
    if (component == 0) {
        model = self.provinceArray[row];
    }else if(component == 1){
        model = self.cityArray[row];
    }else if(component == 2){
        model = self.townArray[row];
    }
    lalTitle.text= model.name;
    return lalTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        FGCityModel *model = self.provinceArray[row];
        self.cityArray = [self getOneLevelCityWithId:model.addressId];
        
        if (self.cityArray.count > 0) {
            FGCityModel *model1 = self.cityArray[0];
            self.townArray = [self getOneLevelCityWithId:model1.addressId];
        }else{
            self.townArray = nil;
        }
        
        [pickerView reloadComponent:1];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.selctedProvince = self.provinceArray[row];
        if (self.cityArray.count > 0) {
            self.selectedCity = self.cityArray[0];
        }else{
            self.selectedCity = nil;
        }
        if (self.townArray.count > 0) {
            self.selctedTown = self.townArray[0];
        }else{
            self.selctedTown = nil;
        }
        
    }else if(component == 1){
        
        FGCityModel *model = self.cityArray[row];
        self.townArray = [self getOneLevelCityWithId:model.addressId];
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        if (self.cityArray.count > 0) {
            self.selectedCity = self.cityArray[row];
        }else{
            self.selectedCity = nil;
        }
        if (self.townArray.count > 0) {
            self.selctedTown = self.townArray[0];
        }else{
            self.selctedTown = nil;
        }
        
    }else if(component == 2){
        if (self.townArray.count > 0) {
            self.selctedTown = self.townArray[row];
        }else{
            self.selctedTown = nil;
        }
    }
    [pickerView reloadComponent:2];
}

@end

