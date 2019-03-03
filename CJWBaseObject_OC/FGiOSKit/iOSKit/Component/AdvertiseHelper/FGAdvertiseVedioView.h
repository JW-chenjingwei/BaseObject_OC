//
//  FGAdvertiseVedioView.h
//  yiquanqiu
//
//  Created by blaceman on 2017/8/8.
//  Copyright © 2017年 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGAdvertiseVedioView : UIView
-(instancetype)initWithFrame:(CGRect)frame fileVedioPath:(NSString *)fileVedioPath;
-(void)play;
@end
