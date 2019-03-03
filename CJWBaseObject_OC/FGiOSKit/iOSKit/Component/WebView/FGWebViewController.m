//
//  FGWebViewController.m
//  dingdingxuefu
//
//  Created by 陈经纬 on 2018/8/15.
//

#import "FGWebViewController.h"

@interface FGWebViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic, copy) NSString *cookieValue;  ///< cookie value

@end

@implementation FGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*************** 可以在子类中重写 获取到cookie ***************/
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in cookieJar.cookies) {
//        if ([cookie.name isEqualToString:@"name"]) {
//            self.cookieValue = cookie.value;
//        }
//    }
    
    /*************** 可以在子类中重写 此处设置JS方法名 ***************/
//    self.JSMethodString = @"success";
 
    self.webView.url = self.url;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.webView.wkWebView.configuration.userContentController addScriptMessageHandler:self name:self.JSMethodString];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 因此这里要记得移除handlers
    [self.webView.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:self.JSMethodString];
}


#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    /*************** 可以在子类中重写 给浏览器 添加 cookie  ***************/
//    NSString *string = [NSString stringWithFormat:@"document.cookie = 'rememberMe=%@';",self.cookieValue];
//    [webView evaluateJavaScript:string completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self.webView.wkWebView stopLoading];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    /*************** 可以在子类中重写 在这里处理 JS 返回的数据 ***************/
    NSString *data = message.body;
    
//    FGResponseModel *response = [FGResponseModel modelWithJSON:data];
//    if (response.result == 1) {
//        
//    }else{
//        [self showWarningHUDWithMessage:response.msg completion:nil];
//    }
}

//初始化
- (void)setupViews
{
    if (self.navTitle) {
        [self.navigationView setTitle:self.navTitle];
    }
    
    self.webView = [FGWebView new];
    self.webView.wkWebView.UIDelegate = self;
    self.webView.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
}
//约束
- (void)setupLayout
{
    
}

#pragma mark - Setter & Getter


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
