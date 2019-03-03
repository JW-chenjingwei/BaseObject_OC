//
//  FGWebView.m
//  dingdingxuefu
//
//  Created by 陈经纬 on 2018/8/15.
//

#import "FGWebView.h"

static void *icWebBrowserContext = &icWebBrowserContext;

@interface FGWebView ()

@property (nonatomic, strong) UIProgressView *progressView; ///< 进度条

@end

@implementation FGWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.wkWebView = [[WKWebView alloc] init];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:icWebBrowserContext];
    [self addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000];
    
    [self.wkWebView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(AdaptedWidth(3));
    }];
}

#pragma mark - Private Methods(私有方法)

#pragma mark - Public Methods(公有方法)

#pragma mark - Observer(监听事件)
#pragma mark Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView)
    {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 [self.progressView setAlpha:0.0f];
             } completion:^(BOOL finished)
             {
                 [self.progressView setProgress:0.0f animated:NO];
             }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - Delegate(代理)

#pragma mark - Setter & Getter

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    if (IsEmpty(url)) {
        return;
    }
    
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else{
        [self.wkWebView loadHTMLString:url baseURL:nil];
    }
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.progressView.progressTintColor = progressColor;
}

- (void)setIsHiddenProgress:(BOOL)isHiddenProgress
{
    _isHiddenProgress = isHiddenProgress;
    self.progressView.hidden = isHiddenProgress;
}

- (void)setIsContentSizeFull:(BOOL)isContentSizeFull
{
    _isContentSizeFull = isContentSizeFull;
    
    if (isContentSizeFull) {
        WeakSelf
        __block CGFloat h = 0; // 使用此方法 对比高度 防止重复的高度 重复约束 和 回调
        [RACObserve(self.wkWebView.scrollView, contentSize) subscribeNext:^(NSValue *_Nullable x) {
            StrongSelf
            CGFloat height = x.CGSizeValue.height;
            if (height > h) { // 使用此方法 对比高度 防止重复的高度 重复约束 和 回调
                
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(x.CGSizeValue.height);
                }];
                [self layoutIfNeeded];
                
                if (self.updateHeightBlock) {
                    self.updateHeightBlock(height);
                }
                h = height;
            }
        }];
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}


@end
