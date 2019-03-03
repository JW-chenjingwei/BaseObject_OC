//
//  FGWebView.h
//  dingdingxuefu
//
//  Created by 陈经纬 on 2018/8/15.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "FGiOSKit.h"

@interface FGWebView : UIView<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) NSString *url;  ///< 可以是 链接 或者 H5字符串

@property (nonatomic, assign) BOOL isHiddenProgress;  ///< 是否隐藏进度条 (默认不隐藏)

@property (nonatomic, strong) UIColor *progressColor; ///< 进度条颜色

@property (nonatomic, assign) BOOL isContentSizeFull;  ///< 是否按内容大小 满屏 (默认为NO) 常用于展示H5文本

@property (nonatomic, copy) void (^updateHeightBlock) (CGFloat height);  ///< 更新高度的回调


@end
