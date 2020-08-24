//
//  WKWebViewController.m
//  YOY-iOS
//
//  Created by tanson on 2017/3/31.
//  Copyright © 2017年 YOY. All rights reserved.
//

#import "TTWKWebViewController.h"
#import "WeakScriptMessageDelegate.h"
#import <WebKit/WebKit.h>
#import "JKWKWebViewHandler.h"

@interface TTWKWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) WeakScriptMessageDelegate * scriptDelegte;
@property (nonatomic,strong) NSMutableArray * actions;

@end

@implementation TTWKWebViewController{
    NSString * _curURLStr;
    id <UIGestureRecognizerDelegate>  _oldInteractivePopGestureRecognizerDelegate;
}

-(instancetype)initWithUrlString:(NSString *)urlStr title:(NSString *)title{
    if([super init]){
        _scriptDelegte = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
        _actions = @[].mutableCopy;
        _rootUrlStr = urlStr;
        //_curURLStr  = urlStr;
        _curURLStr  = nil;
        self.title  = title;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];

    //观察进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self reloadWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _oldInteractivePopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = _oldInteractivePopGestureRecognizerDelegate;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        frame.origin.y = self.view.safeAreaInsets.top;
        frame.size.height -= frame.origin.y;
    } else {
        frame.origin.y = 20;
        frame.size.height -= frame.origin.y;
    }
    self.webView.frame = frame;
    
    frame.size.height = 2;
    self.progressView.frame = frame;
}

-(void) addScriptMessageHandlerWithName:(NSString*)handleName{
    [self.actions addObject:handleName];
    [_webView.configuration.userContentController addScriptMessageHandler:_scriptDelegte name:handleName];
}

-(void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    [self.actions enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:obj];
    }];
    
    [_webView evaluateJavaScript:@"JKEventHandler.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];//删除所有 JKEvenHandler 的回调事件
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView stopLoading];
}

-(WKWebView *)webView{
    if(!_webView){
        
        WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[JKEventHandler shareInstance].handlerJS injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.userContentController   = [WKUserContentController new];
        [config.userContentController addUserScript:usrScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.allowsBackForwardNavigationGestures = YES;
        
        [JKEventHandler getInject:_webView];
        
        [self addCommonScriptMessageHandler];
    }
    return _webView;
}

-(UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [UIProgressView new];
        _progressView.tintColor = [UIColor redColor];
        _progressView.progress = 0.0;
    }
    return _progressView;
}

-(void)updateTitle{
    NSString *title = [self.webView title]? : self.title;
    self.navigationItem.title = title.length >0? title:@"未知title";
    self.titleChangeBlock? self.titleChangeBlock(title):nil;
}

-(void)addCommonScriptMessageHandler{
    
    [self addScriptMessageHandlerWithName:@"pushNewViewController"];
    [self addScriptMessageHandlerWithName:@"popViewController"];
    
    [self addScriptMessageHandlerWithName:JKEventHandlerName];
    
}

-(void)showNetErrStatusView{
    [Utils showErrMsg:@"加载错误"];
}

-(void)hideStatusView{
    UIView * v = [self.view viewWithTag:123456];
    [v removeFromSuperview];
}

-(void)reloadWebView{
    NSURL * url = [NSURL URLWithString:_curURLStr ? :_rootUrlStr];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //[req addValue:@"skey=skeyValue" forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:req];
}

#pragma mark- webView delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
//    NSLog(@"%@",navigationAction.request.URL);
//    if([[navigationAction.request.URL absoluteString] containsString:BASE_URL]){
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }else{
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.title = self.webView.title;
    self.titleChangeBlock? self.titleChangeBlock(self.webView.title):nil;
    [self hideStatusView];
    
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self showNetErrStatusView];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self showNetErrStatusView];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(); }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}


#pragma mark - 监听加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        [self updateTitle];
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark- WKScriptMessageHandler

//window.webkit.messageHandlers.closeMe.postMessage(null);

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
  
    if([message.name isEqualToString:@"pushNewViewController"]){
        NSString * urlStr = message.body;
        TTWKWebViewController * vc = [[TTWKWebViewController alloc] initWithUrlString:urlStr title:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if([message.name isEqualToString:@"popViewController"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([message.name isEqualToString:JKEventHandlerName]){
        [[JKEventHandler shareInstance] userContentController:userContentController didReceiveScriptMessage:message];
    }
}



@end
