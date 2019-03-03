//
//  PlaceholderTextView.h
//  Aiyuangong
//
//  Created by 陈经纬 on 15/5/8.
//  Copyright (c) 2015年 AYG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGPlaceholderTextView : UITextView

@property(nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;

@end
