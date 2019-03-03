//
//  FGEmptyView.m
//  hangyeshejiao
//
//  Created by 陈经纬 on 2018/4/19.
//  Copyright © 2018年 陈经纬. All rights reserved.
//

#import "FGEmptyView.h"
#import "FGiOSKit.h"

@implementation FGEmptyView

- (instancetype)initWithImageString:(NSString *)imageString text:(NSString *)text
{
    self = [super init];
    if (self) {
        
        UIImageView *imageView = [UIImageView fg_imageString:imageString];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AdaptedWidth(60));
            make.centerX.equalTo(self);
        }];
        
        text = IsEmpty(text) ? @"" : text;
        UILabel *label = [UILabel fg_text:text fontSize:17 colorHex:0x666666];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(AdaptedWidth(25));
            make.bottom.equalTo(self);
        }];
        
        _emptyImg = imageView;
        _emptyLabel = label;
        
    }
    return self;
}

- (void)setImageTopConstraint:(CGFloat)imageTopConstraint
{
    _imageTopConstraint = imageTopConstraint;
    [self.emptyImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(imageTopConstraint);
    }];
}

@end
