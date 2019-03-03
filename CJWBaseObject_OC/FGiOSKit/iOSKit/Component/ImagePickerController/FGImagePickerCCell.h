//
//  FGImagePickerCCell.h
//  yiquanqiu
//
//  Created by 陈经纬 on 2017/7/24.
//  Copyright © 2017年 陈经纬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGiOSKit.h"

@interface FGImagePickerCCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end
