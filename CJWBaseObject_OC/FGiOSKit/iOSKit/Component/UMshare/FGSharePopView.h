//
//  ICSharePopView.h
//  ichezhidao
//
//  Created by 陈经纬 on 16/7/8.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGSheetPopControl.h"
#import "FGShareManager.h"
#import "FGBaseTouchView.h"

@interface FGSharePopView : FGSheetPopControl

- (instancetype)initWithTypes:(NSArray <NSString *>*)typeArray shareModel:(FGShareModel *)sModel;


@end




