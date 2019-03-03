//
//  ICGroupBtnsView.m
//  ichezhidao
//
//  Created by 陈经纬 on 16/7/7.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGGroupBtnsView.h"
#import "FGiOSKit.h"
#import <UIImageView+YYWebImage.h>

@implementation FGGroupBtnsModel

- (NSString *)titleString
{
    if (!_titleString) {
        _titleString = @"";
    }
    return _titleString;
}

- (CGFloat)btnTitleFont
{
    if (!_btnTitleFont) {
        _btnTitleFont = 14;
    }
    return _btnTitleFont;
}

- (UIColor *)btnTitleColor
{
    if (!_btnTitleColor) {
        _btnTitleColor = UIColorFromHex(0x444444);
    }
    return _btnTitleColor;
}

- (CGFloat)btnTop
{
    if (!_btnTop) {
        _btnTop = 8;
    }
    return _btnTop;
}

- (CGFloat)btnBottom
{
    if (!_btnBottom) {
        _btnBottom = 8;
    }
    return _btnBottom;
}

- (CGFloat)btnSpace
{
    if (!_btnSpace) {
        _btnSpace = 8;
    }
    return _btnSpace;
}

@end

@interface FGCustomBtn : FGBaseTouchView

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithModel:(FGGroupBtnsModel *)model;

@end

@implementation FGCustomBtn

- (instancetype)initWithModel:(FGGroupBtnsModel *)model
{
    if (self = [super init]) {
        
        _title = model.titleString;
        
//        self.isHighlight = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        if ([model.imageString hasPrefix:@"http"]) {
            [imgView setImageURL:[NSURL URLWithString:model.imageString]];
        }else{
            imgView.image = UIImageWithName(model.imageString);
        }
   
        UILabel *tiitleLable = [UILabel new];
        tiitleLable.font = AdaptedFontSize(model.btnTitleFont);
        tiitleLable.textColor = model.btnTitleColor;
        tiitleLable.textAlignment = NSTextAlignmentCenter;
        tiitleLable.text = model.titleString;
        
        [self addSubview:imgView];
        [self addSubview:tiitleLable];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AdaptedWidth(model.btnTop));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [tiitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(imgView.mas_bottom).offset(AdaptedWidth(model.btnSpace));
            make.bottom.equalTo(self).offset(AdaptedWidth(-model.btnBottom));
        }];
    }
    return self;
}

@end


@interface FGGroupBtnsView ()

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGFloat width;

@end

@implementation FGGroupBtnsView

- (instancetype)initWithModel:(NSArray<FGGroupBtnsModel *> *)models width:(CGFloat)width column:(NSInteger)column
{
    if (self = [super init]) {
        _column = column;
        _width = width;
        [self setupViewsWithModel:models];
    }
    return self;
}



- (void)setupViewsWithModel:(NSArray<FGGroupBtnsModel*> *)models
{
    CGFloat spacing = 0;
    FGCustomBtn *bufferBtn = nil;
    
    if (self.width <= 0) {
        self.width = kScreenWidth;
    }
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < models.count ; i++ ) {
    
        FGCustomBtn *btn = [[FGCustomBtn alloc] initWithModel:objectAtArrayIndex(models, i)];
        btn.tag = i;
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.width.mas_equalTo((self.width - (self.column + 1) * spacing)/self.column);
            if (i > 0) {
                make.width.equalTo(bufferBtn.mas_width);
            }
            if (i % self.column == 0) {
                make.left.equalTo(self.mas_left).offset(IsEmpty(btn.title)?10:spacing);
                if (i == 0) {
                    make.top.equalTo(self.mas_top).offset(spacing);
                }else{
                    make.top.equalTo(bufferBtn.mas_bottom).offset(spacing);
                }
            }else{
                make.left.equalTo(bufferBtn.mas_right).offset(IsEmpty(btn.title)?10:spacing);
                make.top.equalTo(bufferBtn.mas_top).offset(spacing);
            }
            
//            if ((i % _column == (_column - 1))) {
//                make.right.equalTo(self.mas_right).offset(-(IsEmpty(btn.title)?10:spacing)).priorityHigh();
//            }
            
            if (i == (models.count - 1)) {
                make.bottom.equalTo(self.mas_bottom).offset(AdaptedWidth(0));
            }
            
//            //特殊情况，只有一行的时候所有btn水平居中，ICGroupBtnsView的高度可被修改
//            if (models.count == _column) {
//                make.centerY.equalTo(self.mas_centerY);
//            }
            
        }];
        
        bufferBtn = btn;
    }
}

- (void)tapAction:(FGCustomBtn *)sender
{
    if (self.didSelectedIndex) {
        self.didSelectedIndex(sender.tag,sender.title);
    }
}

@end
