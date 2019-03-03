//
//  FGCellStyleView.h
//  shopex
//
//  Created by 陈经纬 on 17/3/27.
//  Copyright © 2017年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseTouchView.h"
#import "FGPlaceholderTextView.h"
@interface FGTextFeidViewModel : NSObject

@property (nonatomic, copy) NSString *leftImgPath;//左边修饰的小图片的路径
@property (nonatomic, copy) NSString *leftTitle;//左边标题
@property (nonatomic, copy) NSAttributedString *leftAttributedTitle;  ///< 左侧富文本标题
@property (nonatomic, copy) NSString *rightImgPath;//右边箭头或者其他修饰的小图片的路径
@property (nonatomic, copy) NSString *content;//输入的内容
@property (nonatomic, copy) NSString *placeholder;//输入控件的placeholder，颜色和字体全部统一
@property (nonatomic) BOOL isNotEnable;//是否可点击，默认可点击
@property (nonatomic) BOOL isTextView;//是否开启textview，支持换行自增高
@property (nonatomic) BOOL secureTextEntry; //是否安全输入
@property (nonatomic) NSInteger limitNum;//字数限制

//textview最高和最低高度
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic)CGFloat minHeight;

@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic, strong) UIColor *leftTitleColor;//左标题颜色
@property (nonatomic, strong) UIColor *contentColor;//输入内容的颜色
@property (nonatomic, assign) CGFloat leftImgPathMargin;  ///< 左侧图片 边距 (默认为6)
@property (nonatomic, assign) CGFloat contentMargin;  ///< content 左边距 (默认为6)
@property (nonatomic, assign) CGFloat contentRightMargin;  ///< content 右边距 (默认为6)
@property (nonatomic, assign) CGFloat rightImgPathMargin;  ///< 右侧图片 边距 (默认为6)
@property (nonatomic, assign) CGFloat contentFont;  ///< content 字体大小 (默认为16)
@end

@interface FGCellStyleView : FGBaseTouchView
@property (nonatomic, strong) UITextField *textFeild;
@property (nonatomic, strong) FGPlaceholderTextView *textView;
@property (nonatomic, strong) FGTextFeidViewModel *model;

- (instancetype)initWithModel:(FGTextFeidViewModel *)model;

@end
