//
//  ICGroupBtnsView.m
//  ichezhidao
//
//  Created by 陈经纬 on 16/7/7.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FCShareBtnsView.h"
#import <UIImageView+WebCache.h>

@interface FCCustomBtn : FGBaseTouchView

@property (nonatomic, copy) NSString *title;
- (instancetype)initWithTitle:(NSString *)title imgName:(NSString *)imgName;

@end

@implementation FCCustomBtn

- (instancetype)initWithTitle:(NSString *)title imgName:(NSString *)imgName
{
    if (self = [super init]) {
        
        _title = title;
        
//        self.isHighlight = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        if ([imgName hasPrefix:@"http"]) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgName]];
        }else{
            imgView.image = UIImageWithName(imgName);
        }
   
        UILabel *tiitleLable = [UILabel new];
        tiitleLable.font = AdaptedFontSize(14);
        tiitleLable.textColor = UIColorFromHex(0x444444);
        tiitleLable.textAlignment = NSTextAlignmentCenter;
        if (IsEmpty(title)) {
            tiitleLable.text = nil;
        }else{
            tiitleLable.text = title;
        }
        
        [self addSubview:imgView];
        [self addSubview:tiitleLable];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(IsEmpty(title)?0:10);
            make.centerX.equalTo(self);
//            make.bottom.equalTo(self.mas_centerY);
        }];
        
        [tiitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(IsEmpty(title)?0:AdaptedHeight(10));
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(IsEmpty(title)?0:-AdaptedHeight(10));
        }];
    }
    return self;
}

@end


@interface FCShareBtnsView ()

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, strong) NSArray *titleAndImgsArr;
@property (nonatomic) BOOL isAdd;

@end

@implementation FCShareBtnsView

- (instancetype)initWithTitleAndImgsArr:(NSArray *)arr column:(NSInteger)column isAddLine:(BOOL)isAdd
{
    if (self = [super init]) {
        
        _titleAndImgsArr = arr;
        _column = column;
        _isAdd = isAdd;
        [self setupViews];
    }
    return self;
}

- (void)setBtnTitleFont:(UIFont *)btnTitleFont
{
    _btnTitleFont = btnTitleFont;
    for (FCCustomBtn *objView in self.subviews) {
        if ([objView isKindOfClass:[FCCustomBtn class]]) {
            for (UIView *objLable in objView.subviews) {
                if ([objLable isKindOfClass:[UILabel class]]) {
                    UILabel *lable = (UILabel *)objLable;
                    lable.font = btnTitleFont;
                }
            }
        }
    }
}

- (void)setBtnTitleColor:(UIColor *)btnTitleColor
{
    _btnTitleColor = btnTitleColor;
    for (FCCustomBtn *objView in self.subviews) {
        if ([objView isKindOfClass:[FCCustomBtn class]]) {
            for (UIView *objLable in objView.subviews) {
                if ([objLable isKindOfClass:[UILabel class]]) {
                    UILabel *lable = (UILabel *)objLable;
                    lable.textColor = btnTitleColor;
                }
            }
        }
    }
}

- (void)setBtnBackgroundColor:(UIColor *)btnBackgroundColor
{
    _btnBackgroundColor = btnBackgroundColor;
    for (FCCustomBtn *objView in self.subviews) {
        if ([objView isKindOfClass:[FCCustomBtn class]]) {
           objView.backgroundColor = _btnBackgroundColor;
        }
    }
}

- (void)setIsClicked:(BOOL)isClicked
{
    _isClicked = isClicked;
    for (FCCustomBtn *objView in self.subviews) {
        if ([objView isKindOfClass:[FCCustomBtn class]]) {
//            objView.isHighlight = isClicked;
        }
    }
}


- (void)setupViews
{
    CGFloat spacing = 0;
    FCCustomBtn *bufferBtn = nil;
    for (int i = 0; i < _titleAndImgsArr.count ; i++ ) {
    
        FCCustomBtn *btn = [[FCCustomBtn alloc] initWithTitle:_titleAndImgsArr[i][@"title"] imgName:_titleAndImgsArr[i][@"image"]];
        btn.tag = i;
        
        if (self.isAdd) {
            [btn addBottomLine];
            [btn addRightLine];
        }
        
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(btn.mas_height);
            make.width.mas_equalTo((kScreenWidth - (_column + 1) * spacing)/_column);
            if (i > 0) {
                make.width.equalTo(bufferBtn.mas_width);
            }
            if (i %_column == 0) {
                make.left.equalTo(self.mas_left).offset(IsEmpty(btn.title)?10:spacing);
                if (i == 0) {
                    make.top.equalTo(self.mas_top);
                }else{
                    make.top.equalTo(bufferBtn.mas_bottom).offset(spacing);
                }
            }else{
                make.left.equalTo(bufferBtn.mas_right).offset(IsEmpty(btn.title)?10:spacing);
                make.top.equalTo(bufferBtn.mas_top);
            }
            
            if ((i % _column == (_column - 1))) {
                make.right.equalTo(self.mas_right).offset(-(IsEmpty(btn.title)?10:spacing));
            }
            
            if (i == (_titleAndImgsArr.count - 1)) {
                make.bottom.equalTo(self.mas_bottom);
            }
            
            //特殊情况，只有一行的时候所有btn水平居中，ICGroupBtnsView的高度可被修改
            if (_titleAndImgsArr.count == _column) {
                make.centerY.equalTo(self.mas_centerY);
            }
            
        }];
        
        bufferBtn = btn;
    }
}

- (void)tapAction:(FCCustomBtn *)sender
{
    if (self.didSelectedIndex) {
        self.didSelectedIndex(sender.tag);
    }
}

@end
