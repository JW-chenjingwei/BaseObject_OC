//
//  FGBillStyleView.h
//  xinchengjufu
//
//  Created by 陈经纬 on 16/10/19.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGBaseTouchView.h"
typedef enum {
    ItemNormal,//没有加线
    ItemLine,//加线

}BillItemStype;

@interface FGBillModel : NSObject

@property (nonatomic, copy) id title;
@property (nonatomic, copy) id content;

@end

@interface FGBillStyleView : FGBaseTouchView
- (instancetype)initWithType:(BillItemStype)type;

@property (nonatomic, strong) NSArray <FGBillModel *>* models;
@property (nonatomic, assign) CGFloat verticalSpace;

+ (NSAttributedString *)string:(NSString *)string fontSize:(CGFloat)fontSize color:(NSInteger)colorHex;

@end
