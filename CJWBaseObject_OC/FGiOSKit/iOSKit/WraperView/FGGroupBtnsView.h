//
//  ICGroupBtnsView.h
//  ichezhidao
//
//  Created by 陈经纬 on 16/7/7.
//  Copyright © 2016年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseTouchView.h"

/* Demo 可直接复制使用
 
NSArray *images = @[@"ic_selected_bottom_print_gray",@"ic_selected_bottom_del_gray",@"ic_selected_bottom_future_generations_gray",@"ic_selected_bottom_share_gray"];
NSArray *titles = @[@"打印",@"删除",@"全选",@"分享"];
NSMutableArray *models = [NSMutableArray new];
for (NSInteger i = 0; i < images.count; i ++) {
    FGGroupBtnsModel *model = [FGGroupBtnsModel new];
    model.titleString = titles[i];
    model.btnTitleFont = 11;
    model.btnTitleColor = UIColorFromHex(0x999999);
    model.imageString = images[i];
    model.btnTop = 6;
    model.btnSpace = 6;
    model.btnBottom = 6;
    [models addObject:model];
}
self.btnView = [[FGGroupBtnsView alloc] initWithModel:models width:kScreenWidth column:4];
[self addSubview:self.btnView];

 */

@interface FGGroupBtnsModel : NSObject

@property (nonatomic, copy) NSString *titleString;  ///< 标题
@property (nonatomic, copy) NSString *imageString;  ///< 图片
@property (nonatomic, strong) UIColor *btnTitleColor;  ///< 标题颜色
@property (nonatomic, assign) CGFloat btnTitleFont;  ///< 标题大小 (默认为14)

@property (nonatomic, assign) CGFloat btnTop;  ///< 距离顶部边距 (默认为8)
@property (nonatomic, assign) CGFloat btnBottom;  ///< 距离顶部边距 (默认为8)
@property (nonatomic, assign) CGFloat btnSpace;  ///< 中间距离 (默认为8)

@end



@interface FGGroupBtnsView : FGBaseTouchView

@property (nonatomic, copy) void (^didSelectedIndex) (NSInteger index, NSString *title);

/**
 @param models 数据源
 @param width 宽度
 @param column 列数
 */
- (instancetype)initWithModel:(NSArray<FGGroupBtnsModel*> *)models width:(CGFloat)width column:(NSInteger)column;

@end
