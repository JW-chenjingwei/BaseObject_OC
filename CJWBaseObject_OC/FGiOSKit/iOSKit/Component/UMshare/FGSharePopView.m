//
//  ICSharePopView.m
//  ichezhidao
//
//  Created by 陈经纬 on 16/7/8.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGSharePopView.h"
#import "FCShareBtnsView.h"

@implementation FGShareModel

@end

@interface FGSharePopView ()

@property (nonatomic, strong) FCShareBtnsView *btnsView;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSDictionary *dataSourceDict;

@end

@implementation FGSharePopView

- (NSArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = @[
                             @{@"type":FGShareToWechatTimeline,
                               @"data":@{@"image":@"ic_circle_friendship",
                                         @"title":@"朋友圈"}
                               },
                             @{@"type":FGShareToWechatSession,
                               @"data":@{@"image":@"ic_circle_wechat",
                                         @"title":@"微信好友"}
                               },
                              @{@"type":FGShareToSina,
                                @"data":@{@"image":@"ic_circle_weibo",
                                          @"title":@"微博"}
                                },
                             @{@"type":FGShareToQQ,
                               @"data":@{@"image":@"umsocial_qq",
                                         @"title":@"QQ"}
                               },
                             @{@"type":FGShareToFacebook,
                               @"data":@{@"image":@"umsocial_facebook",
                                         @"title":@"Facebook"}
                               },
       
                             ];
    }
    return _dataSourceArray;
}

- (instancetype)initWithTypes:(NSArray <NSString *> *)typeArray shareModel:(FGShareModel *)sModel{
    
    if (self = [super init]) {
        
        [self addButtonsViewWithTypes:typeArray shareModel:sModel];

        [self.wrapView addSubview:self.cancelBtn];
        self.cancelBtn.hidden = YES;
      
        UILabel *shareLabel = [UILabel fg_text:@"分享到" fontSize:15 colorHex:0x999999];
        [self.btnsView addSubview:shareLabel];
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btnsView);
            make.top.equalTo(self.wrapView).offset(AdaptedHeight(20));
        }];
        
        [_btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.wrapView);
            make.top.equalTo(self.wrapView.mas_top).offset(50);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btnsView.mas_bottom).offset(8);
            make.left.right.equalTo(self.wrapView);
            make.height.equalTo(@(0));
            make.bottom.equalTo(self.wrapView.mas_bottom).offset(-0);
        }];
    }
    return self;
}

//添加分享按钮的 View
- (void)addButtonsViewWithTypes:(NSArray <NSString *> *)typeArray shareModel:(FGShareModel *)sModel
{
    //取 图片 和 title 字典
    NSMutableArray *array = [NSMutableArray array];
    [typeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSourceArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([str isEqualToString:obj[@"type"]]) {
                [array addObject:obj[@"data"]];
                return ;
            }
        }];
    }];
    
    NSUInteger column;
    if (array.count < 5) {
        column = array.count;
    }else {
        column = 4;
    }
    
    _btnsView = [[FCShareBtnsView alloc] initWithTitleAndImgsArr:array column:column isAddLine:NO];
    [self.wrapView addSubview:_btnsView];
    
    WeakSelf
    [_btnsView setDidSelectedIndex:^(NSInteger index) {
        StrongSelf
        
        if (index < typeArray.count) {
            [self dismiss];
            NSString *typeString = typeArray[index];
            
            if (self.didSelectedIndex) {
                self.didSelectedIndex(index);
                return ;
            }
            
            [[FGShareManager sharedInstance] setShareType:typeString shareModel:sModel];
        }
    }];
}

@end
