//
//  FGAdvertiseVedioView.m
//  yiquanqiu
//
//  Created by blaceman on 2017/8/8.
//  Copyright © 2017年 陈经纬. All rights reserved.
//

#import "FGAdvertiseVedioView.h"
#import <AVFoundation/AVFoundation.h>
#import "FGiOSKit.h"


@interface FGAdvertiseVedioView()
@property (nonatomic, strong) AVPlayer *player;  ///< 播放层;
@property (nonatomic, strong) UIButton *countBtn;

@end

@implementation FGAdvertiseVedioView

-(instancetype)initWithFrame:(CGRect)frame fileVedioPath:(NSString *)fileVedioPath{
    self = [super initWithFrame:frame];
    if (self) {
        NSURL *vedioUrl = [[NSURL alloc]initFileURLWithPath:fileVedioPath];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:vedioUrl];
        // 3.创建AVPlayer
        self.player = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.frame = CGRectMake(0, frame.size.height / 2 - (kScreenHeight * 9 / 16) / 2, kScreenWidth, kScreenHeight * 9 / 16);
        self.backgroundColor = UIColorFromHex(0x000000);
        [self.layer addSublayer:layer];
        
        // 2.跳过按钮
        CGFloat btnW = AdaptedWidth(50);
        CGFloat btnH = AdaptedWidth(50);
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - btnW - 24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过"] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_countBtn setTitleColor:UIColorFromHex(0x000000) forState:UIControlStateNormal];
        _countBtn.backgroundColor = UIColorFromRGB(128, 136, 147);
        _countBtn.alpha = 0.6;
        _countBtn.layer.cornerRadius = AdaptedWidth(25);

        [self addSubview:_countBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}
-(void)play{
    [self.player play];
}
- (void)dismiss{
    [self removeFromSuperview];
}
@end
