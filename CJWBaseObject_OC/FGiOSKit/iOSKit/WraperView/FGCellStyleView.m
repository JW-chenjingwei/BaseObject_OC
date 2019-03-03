//
//  FGCellStyleView.m
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import "FGCellStyleView.h"
#import "FGiOSKit.h"

@implementation FGTextFeidViewModel

@end

@interface FGCellStyleView ()

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UILabel *titleLable;



@end

@implementation FGCellStyleView

- (instancetype)initWithModel:(FGTextFeidViewModel *)model
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _model = model;
        [self setupViews];
        [self setupLayout];
    }
    return self;
}

- (void)setupViews
{
    WeakSelf
    
    self.userInteractionEnabled = !_model.isNotEnable;
    
    _leftImgView = [UIImageView new];
    [_leftImgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    if (!IsEmpty(_model.leftImgPath)) {
        _leftImgView.image = UIImageWithName(_model.leftImgPath);
    }
    [self addSubview:_leftImgView];
    
    _titleLable = [UILabel new];
    [_titleLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _titleLable.text = _model.leftTitle;
    if (_model.leftAttributedTitle) {
        _titleLable.attributedText = _model.leftAttributedTitle;
    }
    _titleLable.font = AdaptedFontSize(self.model.contentFont ? self.model.contentFont : 16);
    if (_model.leftTitleColor) {
        _titleLable.textColor = _model.leftTitleColor;
    }else{
        _titleLable.textColor = UIColorFromHex(0x010101);
    }
    [self addSubview:_titleLable];
    
    RACChannelTo(self.titleLable, text) = RACChannelTo(self.model, leftTitle);
    if (_model.leftAttributedTitle) {
        RACChannelTo(self.titleLable, attributedText) = RACChannelTo(self.model, leftAttributedTitle);
    }
    
    if (_model.isTextView) {
        _textView = [FGPlaceholderTextView new];
        if (_model.placeholder) {
            _textView.placeholder = _model.placeholder;
        }else{
            _textView.placeholder = @" ";//暂时解决FGPlaceholderTextView的bug！！！！！
        }
        _textView.placeholderColor = UIColorFromHex(0xcccccc);
        if (_model.contentColor) {
            _textView.textColor = _model.contentColor;
        }else{
            _textView.textColor = UIColorFromHex(0x333333);
        }
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = AdaptedFontSize(self.model.contentFont ? self.model.contentFont : 16);
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView.layer.masksToBounds = YES;
        _textView.textAlignment = _model.alignment;
        [self addSubview:_textView];
        
        _textView.text = _model.content;//修复第一次给content赋值后，_textView经过后续的rac把content置空的bug
        
        RACChannelTerminal *modelTerminal = RACChannelTo(self.model, content);
        RACChannelTerminal *textChannel = RACChannelTo(self.textView, text);
        
        WeakSelf
        [[self.textView.rac_textSignal map:^id(NSString *value) {
            StrongSelf
            
            //z字数限制
            if (value.length > self.model.limitNum && self.model.limitNum > 0) {
                NSString *subString = [self.textView.text substringToIndex: self.model.limitNum];
                self.textView.text = subString;
                return subString;
            }
            return value;
        }] subscribe:modelTerminal];
        
        [modelTerminal subscribe:textChannel];
        
    }else{
        _textFeild = [UITextField new];
        _textFeild.backgroundColor = [UIColor clearColor];
        if (_model.placeholder) {
            _textFeild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_model.placeholder attributes:@{NSFontAttributeName : AdaptedFontSize(self.model.contentFont ? self.model.contentFont : 16), NSForegroundColorAttributeName : UIColorFromHex(0x999999)}];
        }
        if (_model.contentColor) {
            _textFeild.textColor = _model.contentColor;
        }else{
            _textFeild.textColor = UIColorFromHex(0x010101);
        }
        _textFeild.font = AdaptedFontSize(self.model.contentFont ? self.model.contentFont : 16);
        _textFeild.keyboardType = _model.keyboardType;
        _textFeild.textAlignment = _model.alignment;
        _textFeild.enablesReturnKeyAutomatically = YES;
        _textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_textFeild];
        
        [_textFeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        RACChannelTo(self.textFeild, text) = RACChannelTo(self.model, content);
        RACChannelTo(self.textFeild, placeholder) = RACChannelTo(self.model, placeholder);
        
    }
    
    _rightImgView = [UIImageView new];
    [_rightImgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    if (!IsEmpty(_model.rightImgPath)) {
        _rightImgView.image = UIImageWithName(_model.rightImgPath);
    }
    [self addSubview:_rightImgView];
    
    //右边箭头双边
    RACChannelTerminal *channelA = RACChannelTo(self.rightImgView, image);
    RACChannelTerminal *channelB = RACChannelTo(self.model, rightImgPath);
    [[channelB map:^id(NSString *value) {
        if (IsEmpty(value)) {
            return nil;
        }
        return UIImageWithName(value);
    }] subscribe:channelA];
    [channelA subscribe:channelB];
    
    //是否可交互
    [RACObserve(self.model, isNotEnable) subscribeNext:^(NSNumber *isEnable) {
        StrongSelf
        self.userInteractionEnabled = !isEnable.boolValue;
    }];
    
    [RACObserve(self.model, secureTextEntry) subscribeNext:^(NSNumber *isEnable) {
        StrongSelf
        self.textFeild.secureTextEntry = isEnable.boolValue;
    }];
    
    
    if (!IsEmpty(_model.rightImgPath)) {
        _textFeild.enabled = NO;
        _textView.userInteractionEnabled = NO;
    }
    
    //[self addBottomLine];
    
    
    CGFloat minHeight;
    CGFloat maxHeight;
    if (_model.minHeight > 0) {
        minHeight = _model.minHeight;
    }else{
        minHeight = 33;//默认(textview与self的上下边距为8， 33+8*2=49)
    }
    if (_model.maxHeight > 0) {
        maxHeight = _model.maxHeight;
    }else{
        maxHeight = 160;//默认
    }
    
    
    [RACObserve(_textView, contentSize) subscribeNext:^(id x) {
        StrongSelf
        CGFloat h = self.textView.contentSize.height;
        if (h <= minHeight)
        {
            h = minHeight;
        }
        
        if (h > maxHeight) {
            h = maxHeight;
        }
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h);
        }];
    }];
}

- (void)setupLayout
{
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AdaptedWidth(self.model.leftImgPathMargin?self.model.leftImgPathMargin:6));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(IsEmpty(_leftImgView.image)?0:_leftImgView.image.size.width);
        make.height.mas_equalTo(IsEmpty(_leftImgView.image)?0:_leftImgView.image.size.height);
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImgView.mas_right).offset(IsEmpty(self.model.leftImgPath)?0:15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    if (self.model.isTextView) {
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLable.mas_right).offset(self.model.contentMargin?self.model.contentMargin:15);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }else{
        [_textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLable.mas_right).offset(self.model.contentMargin?self.model.contentMargin:15);
            make.top.bottom.equalTo(self);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-AdaptedWidth(self.model.rightImgPathMargin ? self.model.rightImgPathMargin : 15));
        make.centerY.equalTo(self.mas_centerY);
        if (self.model.isTextView) {
            make.left.equalTo(_textView.mas_right).offset(15);
        }else{
            make.left.equalTo(_textFeild.mas_right).offset(AdaptedWidth(self.model.contentRightMargin ? self.model.contentRightMargin : 15));
        }
        make.width.mas_equalTo(IsEmpty(_rightImgView.image)?0:_rightImgView.image.size.width);
        make.height.mas_equalTo(IsEmpty(_rightImgView.image)?0:_rightImgView.image.size.height);
    }];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_model.limitNum == 0) {
        return;
    }
    if (textField.text.length >  _model.limitNum) {
        textField.text = [textField.text substringToIndex: _model.limitNum];
    }
}


@end
