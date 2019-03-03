//
//  FGBillStyleView.m
//  xinchengjufu
//
//  Created by 陈经纬 on 16/10/19.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGBillStyleView.h"
#import "FGiOSKit.h"

@implementation FGBillModel


@end

//###########

@interface FGBillLable : UIView

- (instancetype)initWithModel:(FGBillModel *)model;

@end

@implementation FGBillLable

- (instancetype)initWithModel:(FGBillModel *)model
{
    if (self = [super init]) {
        
        UILabel *titleLable = [UILabel new];
        titleLable.font = AdaptedFontSize(14);
        titleLable.textColor = UIColorFromHex(0x000000);
        if ([model.title isKindOfClass:[NSAttributedString class]]) {
            titleLable.attributedText = model.title;
        }else{
            titleLable.text = model.title;
        }
        
        [self addSubview:titleLable];
        [titleLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        UILabel *contentLable = [UILabel new];
        contentLable.font = AdaptedFontSize(14);
        contentLable.textColor = UIColorFromHex(0x000000);
        contentLable.numberOfLines = 0;
        contentLable.textAlignment = NSTextAlignmentRight;
        if (IsEmpty(model.content)) {
            contentLable.text = @" ";
        }else{
            if ([model.content isKindOfClass:[NSAttributedString class]]) {
                contentLable.attributedText = model.content;
            }else{
                contentLable.text = model.content;
            }
        }
        [self addSubview:contentLable];
        
        
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
        }];
        
        [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLable.mas_right);
            make.top.equalTo(self.mas_top);
            make.right.mas_lessThanOrEqualTo(self.mas_right);
//            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

@end

//#############
@interface FGBillStyleView ()
@property (nonatomic, assign) BillItemStype stype;

@end

@implementation FGBillStyleView
- (instancetype)initWithType:(BillItemStype)type{
    if (self = [super init]) {
        self.stype = type;
    }
    return self;
}

- (void)setModels:(NSArray *)models
{
    if (self.verticalSpace <= 0) {
        self.verticalSpace = 8;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    FGBillLable *bufferLable;
    for (int i  = 0; i < models.count; i ++) {
        FGBillLable *lable = [[FGBillLable alloc] initWithModel:models[i]];
        [self addSubview:lable];
        
        UIView *line = [UIView new];
        if (self.stype == ItemLine && i < (models.count - 1)) {
            line.backgroundColor = UIColorFromHex(kColorLine);
            [self addSubview:line];
        }
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            if (bufferLable) {
                make.top.equalTo(bufferLable.mas_bottom).offset(self.verticalSpace);
            }else{
                make.top.equalTo(self.mas_top).offset(self.verticalSpace / 2.0);
            }
            if (i == models.count - 1) {
                make.bottom.equalTo(self.mas_bottom).offset(-(self.verticalSpace / 2.0));
            }
        }];
        
        
        if (self.stype == ItemLine && i < (models.count - 1)) {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(16);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(lable.mas_bottom).offset(self.verticalSpace / 2.0);
                make.height.mas_equalTo(kOnePixel);
            }];
            
        }else{
            [line removeFromSuperview];
            line = nil;
        }
        
        bufferLable = lable;
    }
}

+ (NSAttributedString *)string:(NSString *)string fontSize:(CGFloat)fontSize color:(NSInteger)colorHex
{
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : AdaptedFontSize(fontSize), NSForegroundColorAttributeName : UIColorFromHex(colorHex)}];}

@end
