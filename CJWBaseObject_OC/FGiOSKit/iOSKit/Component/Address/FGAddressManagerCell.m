//
//  FGAddressManagerCell.m
//  yulala
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 陈经纬. All rights reserved.
//

#import "FGAddressManagerCell.h"
#import "FGAddressModel.h"
#import "FGiOSKit.h"

@interface FGAddressManagerCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *defaultAddressBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation FGAddressManagerCell

- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.nameLabel = [UILabel fg_text:nil fontSize:16 colorHex:0x333333];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.phoneLabel = [UILabel fg_text:nil fontSize:16 colorHex:0x333333];
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.phoneLabel];
    
    self.addressLabel = [UILabel fg_text:nil fontSize:15 colorHex:0x999999];
    self.addressLabel.numberOfLines = 0;
    [self.contentView addSubview:self.addressLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = UIColorFromHex(kColorLine);
    [self.contentView addSubview:self.line];
    
    self.defaultAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defaultAddressBtn setImage:UIImageWithName(@"ic_circle_gray_no_choose_middle") forState:UIControlStateNormal];
    [self.defaultAddressBtn setImage:UIImageWithName(@"ic_circle_yellow_selected_middle") forState:UIControlStateSelected];
    [self.defaultAddressBtn setTitle:@"   默认地址" forState:UIControlStateNormal];
    self.defaultAddressBtn.titleLabel.font = AdaptedFontSize(16);
    [self.defaultAddressBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [self.contentView addSubview:self.defaultAddressBtn];
    [self.defaultAddressBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.defaultAddressBtn addTarget:self action:@selector(defaultAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setImage:UIImageWithName(@"ic_edit_gray") forState:UIControlStateNormal];
    [self.editBtn setTitle:@"   编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = AdaptedFontSize(16);
    [self.editBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [self.contentView addSubview:self.editBtn];
    [self.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:UIImageWithName(@"ic_delete_gray") forState:UIControlStateNormal];
    [self.deleteBtn setTitle:@"   删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = AdaptedFontSize(16);
    [self.deleteBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setupLayout{
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AdaptedHeight(15)).priorityHigh();
        make.left.offset(AdaptedWidth(17));
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.right.offset(-AdaptedWidth(17));
        make.left.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(AdaptedHeight(10));
        make.right.offset(-AdaptedWidth(17));
        make.left.offset(AdaptedWidth(17));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.offset(0);
        make.height.mas_equalTo(kOnePixel);
    }];
    
    [self.defaultAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AdaptedHeight(12));
        make.left.offset(AdaptedWidth(15));
        make.height.mas_equalTo(AdaptedHeight(25));
        make.width.mas_equalTo(AdaptedWidth(130));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.defaultAddressBtn.mas_centerY);
        make.right.offset(-AdaptedWidth(13));
        make.height.mas_equalTo(AdaptedHeight(25));
        make.width.mas_equalTo(AdaptedWidth(100));
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.defaultAddressBtn.mas_centerY);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-AdaptedWidth(10));
        make.height.mas_equalTo(AdaptedHeight(25));
        make.width.mas_equalTo(AdaptedWidth(100));
    }];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorFromHex(kColorBG);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultAddressBtn.mas_bottom).offset(AdaptedWidth(15));
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(AdaptedWidth(15));
    }];
    
}

- (void)defaultAddressBtnAction:(UIButton *)sender{
    //    sender.selected = !sender.selected;
    if (self.defaultAddressBtnClick) {
        self.defaultAddressBtnClick(sender);
    }
}

- (void)editBtnAction:(UIButton *)sender{
    if (self.editBtnClick) {
        self.editBtnClick();
    }
    
}

- (void)deleteBtnAction:(UIButton *)sender{
    if (self.deleteBtnClick) {
        self.deleteBtnClick();
    }
    
}

- (void)configWithModel:(id)model
{
    FGAddressModel *dataModel = model;
    
    self.nameLabel.text = dataModel.contact_name ;
    self.addressLabel.text = NSStringFormat(@"%@%@%@ %@",dataModel.province,dataModel.city,dataModel.district,dataModel.address);
    self.phoneLabel.text = dataModel.contact_phone;
    self.defaultAddressBtn.selected = dataModel.is_default;

}

@end
