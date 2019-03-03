//
//  FGWebViewController.h
//  dingdingxuefu
//
//  Created by 陈经纬 on 2018/8/15.
//

#import "FGBaseViewController.h"
#import "FGWebView.h"
/*
 H5 写法示例
 window.webkit.messageHandlers.<方法名>.postMessage(<数据>)
 
 if (/iphone|ipad|ipod/.test(ua)) {
 window.webkit.messageHandlers.success.postMessage(window['jsonData'].toString())
 } else if (/android/.test(ua)) {
 lianlian.share(window['jsonData'].toString());
 }
 */

@interface FGWebViewController : FGBaseViewController

@property (nonatomic, strong) FGWebView *webView;  ///< <#Description#>

@property (nonatomic, copy) NSString *url;  ///< 可以是 链接 或者 H5字符串

@property (nonatomic, copy) NSString *navTitle;  ///< 导航栏标题

@property (nonatomic, copy) NSString *JSMethodString;  ///< JS 交互的方法名

@end
