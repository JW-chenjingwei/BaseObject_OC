//
//  FGTagsView.m
//  inman
//
//  Created by figo on 17/1/6.
//  Copyright © 2017年 Figo. All rights reserved.
//

#import "FGTagsView.h"
#import <UIImageView+YYWebImage.h>
#import "FGiOSKit.h"

@implementation FGTagModel

@end


@interface FGTagItemView ()

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLable;
- (instancetype)initWithEdge:(UIEdgeInsets)edge isRound:(BOOL)isRound;

@end

@implementation FGTagItemView

- (instancetype)initWithEdge:(UIEdgeInsets)edge isRound:(BOOL)isRound
{
    if (self = [super init]) {
        self.backgroundColor = UIColorFromHex(0xf0f0f0);
        _iconImgView = [UIImageView new];
        [self addSubview:_iconImgView];
        
        _titleLable = [UILabel new];
        _titleLable.textColor = UIColorFromHex(0x333333);
        _titleLable.font =AdaptedFontSize(13);
        if (isRound) {
            self.layer.cornerRadius = (18.0 + edge.top + edge.bottom)/2;
//            self.layer.cornerRadius = AdaptedWidth(13);
            self.clipsToBounds = YES;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 1;
        }
        [self addSubview:_titleLable];
        [_titleLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(18);
            make.top.equalTo(self.mas_top).offset(edge.top);
            make.bottom.equalTo(self.mas_bottom).offset(-edge.bottom);
            make.left.equalTo(self.mas_left).offset(edge.left);
        }];
        
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset(0);
            make.right.equalTo(self.mas_right).offset(-edge.right);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return  self;
}


- (void)configerTitleColor:(UIColor *)titleColor withBackgroundColor:(UIColor *)backgroundColor
{
    _titleLable.textColor = titleColor;
    self.backgroundColor = backgroundColor;
}

@end


@interface FGTagsView ()

@property (nonatomic, strong) NSArray <FGTagModel *> *models;
@end

@implementation FGTagsView

- (instancetype)init
{
    if (self = [super init]) {
        
        _tagHorSpace = 10;
        _tagVerSpace = 10;
    }
    return self;
}

- (void)addTagsWithModels:(NSArray <FGTagModel *>*)models  alignment:(FGTagsAlignment)alignment width:(CGFloat)width
{
    _models = models;
    
    CGSize selfSize = CGSizeMake(width, 0);
    CGFloat rigthSpace = width;
    FGTagItemView *buffertagItem = nil;
    
    if (alignment == FGTagsAlignmentCenter) {
        UIView *containerView = [UIView new];
        containerView.tag = 0;
        [self addSubview:containerView];
        
        UIView *bufferContainerView = nil;
        
        for (int i = 0; i < self.models.count; i ++)
        {
            FGTagItemView *tagItem = [[FGTagItemView alloc] initWithEdge:self.edge isRound:self.isRound];
            tagItem.tag = i;
            [tagItem addTarget:self action:@selector(tagItemsAction:) forControlEvents:UIControlEventTouchUpInside];
            FGTagModel *model = self.models[i];
            [tagItem.iconImgView setImageURL:[NSURL URLWithString:model.image]];
            if (IsEmpty(model.image)) {
                [tagItem.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
                }];
            }
            tagItem.titleLable.text = model.name;
            
            
            //该计算size的方法耗时较长，考虑使用frame的方法
            CGSize itemSize =  [tagItem systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            
            if (rigthSpace  - itemSize.width - self.tagHorSpace < 0) {
                //改行放不下
                
                //上一个已经排满的contentView
                [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX);
                    if (containerView.tag == 0) {
                        make.top.equalTo(self.mas_top);
                    }else{
                        make.top.equalTo(bufferContainerView.mas_bottom).offset(self.tagVerSpace);
                    }
                    make.width.mas_equalTo(selfSize.width - rigthSpace - self.tagHorSpace);
                    make.height.mas_equalTo(itemSize.height);
                }];
                bufferContainerView = containerView;
                
                //下一个contentview
                containerView = [UIView new];
                containerView.tag = i;
                [self addSubview:containerView];
                rigthSpace = selfSize.width - itemSize.width - self.tagHorSpace;
            }else{
                //可以放下
                rigthSpace = rigthSpace - itemSize.width - self.tagHorSpace;
            }
            
            [containerView addSubview:tagItem];
            
            [tagItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView.mas_left).offset(selfSize.width - rigthSpace - itemSize.width - self.tagHorSpace);
                make.top.equalTo(containerView.mas_top);
            }];
            
            buffertagItem = tagItem;
        }
        
        [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (bufferContainerView) {
                make.top.equalTo(bufferContainerView.mas_bottom).offset(self.tagVerSpace);
            }else{
                make.top.equalTo(self.mas_top);
            }
            make.bottom.equalTo(self.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
            make.right.equalTo(buffertagItem.mas_right);
            make.height.equalTo(buffertagItem.mas_height);
        }];
        if (buffertagItem) {
            [self.tagItems addObject:buffertagItem];
        }
    }else{
        
        for (int i = 0; i < models.count; i ++)
        {
            FGTagItemView *tagItem = [[FGTagItemView alloc] initWithEdge:self.edge isRound:self.isRound];
            tagItem.tag = i;
            [tagItem addTarget:self action:@selector(tagItemsAction:) forControlEvents:UIControlEventTouchUpInside];
            FGTagModel *model = self.models[i];
            [tagItem.iconImgView setImageURL:[NSURL URLWithString:model.image]];
            tagItem.titleLable.text = model.name;
            if (IsEmpty(model.image)) {
                [tagItem.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
                }];
            }
            [self addSubview:tagItem];
            
            //该计算size的方法耗时较长，考虑使用frame的方法
            CGSize itemSize =  [tagItem systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            
            [tagItem mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (rigthSpace >= itemSize.width) {
                    if (i == 0) {
                        make.left.equalTo(self.mas_left);
                        make.top.equalTo(self.mas_top);
                    }else{
                        make.left.equalTo(buffertagItem.mas_right).offset(self.tagHorSpace);
                        make.centerY.equalTo(buffertagItem.mas_centerY);
                    }
                }else{
                    //当前行剩余的空白不足以放下当前item
                    make.left.equalTo(self.mas_left);
                    make.top.equalTo(buffertagItem.mas_bottom).offset(self.tagVerSpace);
                }
                
                if (i == models.count- 1) {
                    make.bottom.equalTo(self.mas_bottom);
                }
                
            }];
            
            if (rigthSpace < itemSize.width) {
                rigthSpace = selfSize.width - itemSize.width - self.tagHorSpace;
            }else{
                rigthSpace = rigthSpace - itemSize.width - self.tagHorSpace;
            }
            
            buffertagItem = tagItem;
            [self.tagItems addObject:buffertagItem];
        }
    }
}

- (NSMutableArray *)tagItems
{
    if (_tagItems == nil)
    {
        _tagItems = [NSMutableArray array];
    }
    return _tagItems;
}

- (void)tagItemsAction:(FGTagItemView *)tagItem
{
    FGTagModel *model = self.models[tagItem.tag];
    if (self.clickedTagCallBack) {
        self.clickedTagCallBack(tagItem.tag, model.name);
    }
}


@end
