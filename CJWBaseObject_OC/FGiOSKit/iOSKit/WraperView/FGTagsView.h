//
//  FGTagsView.h
//  inman
//
//  Created by figo on 17/1/6.
//  Copyright © 2017年 Figo. All rights reserved.
//

#import "FGBaseTouchView.h"

typedef NS_ENUM(NSInteger ,FGTagsAlignment) {
    FGTagsAlignmentLeft,       //tag左对齐
    FGTagsAlignmentCenter,  //tag居中对齐
};

@interface FGTagModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@end

@interface FGTagItemView : FGBaseTouchView

- (void)configerTitleColor:(UIColor *)titleColor withBackgroundColor:(UIColor *)backgroundColor;

@end

@interface FGTagsView : FGBaseTouchView

/*
 tag是否需要圆角
 */
@property (nonatomic, assign) BOOL isRound;

/*
 tag的内边距
 */
@property (nonatomic, assign) UIEdgeInsets edge;

/*
 tag的水平和垂直间距
 */
@property (nonatomic, assign) CGFloat tagHorSpace;
@property (nonatomic, assign) CGFloat tagVerSpace;

/*
 width控件的宽度(必传)
 */
- (void)addTagsWithModels:(NSArray <FGTagModel *>*)models alignment:(FGTagsAlignment)alignment width:(CGFloat)width;

@property (nonatomic, strong) NSMutableArray <FGTagItemView *>*tagItems;

@property (nonatomic, copy) void(^clickedTagCallBack)(NSInteger index, NSString *title);
@end
