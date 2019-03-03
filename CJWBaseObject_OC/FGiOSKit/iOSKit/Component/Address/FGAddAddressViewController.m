//
//  FGAddAddressViewController.m
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import "FGAddAddressViewController.h"
#import "FGCellStyleView.h"
#import "FGAreaPicker.h"
#import "FGAlertView.h"
#import "UIView+EdgeLine.h"
#import "FGPlaceholderTextView.h"
#import "FGAreaPicker.h"
#import "FGiOSKit.h"

@interface FGAddAddressViewController ()
@property (nonatomic, strong) NSMutableArray<FGCellStyleView *> *cellArray;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, copy)NSString *provinceId;
@property (nonatomic, copy)NSString *cityId;
@property (nonatomic, copy)NSString *districtId;

@property (nonatomic,strong) UIButton *defaultAddressBtn;
@property (nonatomic, copy) NSString *province;  ///< name
@property (nonatomic, copy) NSString *city;  ///< name
@property (nonatomic, copy) NSString *district;  ///< name
@property (nonatomic, copy) NSString *address;  ///< <#name#>
@property (nonatomic, copy) NSString *contact_name;  ///< <#name#>
@property (nonatomic, copy) NSString *contact_phone;  ///< <#name#>
@property (nonatomic,copy) NSString *areaValue;///<<#name#>
@end

@implementation FGAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.addrModel) {
        [self.navigationView setTitle:@"编辑地址"];
        
    }else{
        [self.navigationView setTitle:@"新增地址"];
    }
    [self.view endEditing:YES];
    
}

- (void)setupViews{
    self.bgScrollView.backgroundColor = UIColorFromHex(kColorBG);
    self.bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.cellArray = [NSMutableArray new];
    
    NSArray *leftArray = @[@"收货人        ",@"手机号码    ",@"省市区        ",@"详细地址    "];
    NSArray *placeHolders = @[@"请输入收货人的姓名",@"请输入收货人的手机号码",@"",@"请输入收货人的详细地址"];
    
    FGCellStyleView *tempView;
    for (int i = 0; i < leftArray.count; i++) {
        FGTextFeidViewModel *model = [FGTextFeidViewModel new];
        model.leftTitle = leftArray[i];
        model.leftTitleColor = UIColorFromHex(0x666666);
        model.leftImgPathMargin = AdaptedWidth(20);
        model.placeholder = placeHolders[i];
        if (i == 2) {
            model.rightImgPath = @"ic_arrow_right_dark_brown";
        }else if (i == 3){
            model.isTextView = YES;
        }
        FGCellStyleView *textView = [[FGCellStyleView alloc]initWithModel:model];
        textView.backgroundColor = [UIColor whiteColor];
        [textView addBottomLine];
        [self.bgScrollView addSubview:textView];
        textView.tag = i;
        if (i == 1) {
            textView.model.keyboardType = UIKeyboardTypeNumberPad;
            textView.model.limitNum = 11;
        }
        else if (i == 2) {
            [textView addTarget:self action:@selector(textViewClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i != 3) {
                make.height.mas_equalTo(AdaptedHeight(51));
            }
            make.left.right.offset(0);
            if (i == 0) {
                make.top.offset(0);
            }else{
                make.top.equalTo(tempView.mas_bottom);
            }
        }];
        tempView = textView;
        
        [self.cellArray addObject:textView];
    }
    
    
    self.defaultAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defaultAddressBtn setImage:UIImageWithName(@"ic_circle_gray_no_choose") forState:UIControlStateNormal];
    [self.defaultAddressBtn setImage:UIImageWithName(@"ic_circle_yellow_selected") forState:UIControlStateSelected];
    [self.defaultAddressBtn setTitle:@"   设为默认地址" forState:UIControlStateNormal];
    [self.defaultAddressBtn addTarget:self action:@selector(defaultAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    self.defaultAddressBtn.titleLabel.font = AdaptedFontSize(16);
    [self.defaultAddressBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [self.bgScrollView addSubview:self.defaultAddressBtn];
    [self.defaultAddressBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self.defaultAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AdaptedWidth(15));
        make.top.equalTo(self.cellArray.lastObject.mas_bottom);
        make.height.mas_equalTo(AdaptedWidth(51));
        make.bottom.right.offset(0);
    }];
    
    
    self.saveBtn = [UIButton fg_imageString:@"btn_confirm_yellow_2" imageStringSelected:@"btn_confirm_yellow_2"];
    
    [self.view addSubview:self.saveBtn];
    [self.saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.mas_equalTo(kScreenWidth * 0.7);
        make.height.mas_equalTo(AdaptedHeight(50));
        make.bottom.offset(AdaptedScreenBottom(-30));
    }];
    
    
    
    if (self.addrModel) {
        self.cellArray[0].model.content = self.addrModel.contact_name;
        self.cellArray[1].model.content = self.addrModel.contact_phone;
        self.cellArray[2].model.content = NSStringFormat(@"%@%@%@",self.addrModel.province,self.addrModel.city,self.addrModel.district);
        self.cellArray[3].model.content = self.addrModel.address;
        self.defaultAddressBtn.selected = self.addrModel.is_default;
        
        self.province = self.addrModel.province;
        self.city = self.addrModel.city;
        self.district = self.addrModel.district;
    }
    
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[self.cellArray[0].textFeild.rac_textSignal,self.cellArray[1].textFeild.rac_textSignal,RACObserve(self.cellArray[2], model.content),self.cellArray[3].textView.rac_textSignal] reduce:^NSNumber *_Nonnull(NSString *userName, NSString *mobile,NSString *locate, NSString *adress){
        NSNumber *result = @([mobile fg_isMobileNumber] && userName.length > 0 && locate.length > 0  && adress.length > 0 );
        return result;
    }];
    RAC(self.saveBtn,enabled) = combineSignal;
}



- (void)textViewClick:(FGCellStyleView *)textView{
    
    [self.view endEditing:YES];
    FGAreaPicker *areaPicker = [FGAreaPicker new];
    [areaPicker show];
    areaPicker.didSeclectedDone = ^(FGCityModel *province, FGCityModel *city, FGCityModel *town) {
        textView.model.content = NSStringFormat(@"%@%@%@",province.name,city.name,town.name);
        self.province = province.name;
        self.city = city.name;
        self.district = town.name;
    };
    
}

- (void)saveBtnAction:(UIButton *)sender{
    
    NSMutableDictionary *paramter = [NSMutableDictionary new];
    paramter[@"province"] = self.province;
    paramter[@"city"] = self.city;
    paramter[@"district"] = self.district;
    paramter[@"address"] = self.cellArray[3].model.content;
    paramter[@"contact_name"] = self.cellArray[0].model.content;
    paramter[@"contact_phone"] = self.cellArray[1].model.content;
    paramter[@"zip"] = @"000000";
    paramter[@"default"] = @(self.defaultAddressBtn.selected);
    
    //修改地址
    NSString *url;
    if (self.addrModel) {
//        url = NSStringFormat(@"api/users/%@/addresses/%@",kUserId,self.addrModel.ID);
//        [FGHttpManager patchWithPath:url parameters:paramter success:^(id responseObject) {
//
//            [self showCompletionHUDWithMessage:@"修改成功" completion:^{
//                if (self.saveSucess) {
//                    self.saveSucess();
//                }
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//        } failure:^(NSString *error) {
//            [self showTextHUDWithMessage:error];
//        }];
    }else{
//        url = [NSString stringWithFormat:@"api/users/%@/addresses",kUserId];
//        [FGHttpManager postWithPath:url parameters:paramter success:^(id responseObject) {
//
//            [self showCompletionHUDWithMessage:@"添加成功" completion:^{
//                if (self.saveSucess) {
//                    self.saveSucess();
//                }
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//
//        } failure:^(NSString *error) {
//            [self showTextHUDWithMessage:error];
//        }];
    }
}

- (void)defaultAddressAction:(UIButton *)btn {
    btn.selected = !btn.selected;
}
@end
