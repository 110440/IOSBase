//
//  HttpErrShowViewController.m
//
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import "HttpErrShowViewController.h"
#import <WebKit/WebKit.h>

@interface HttpErrShowViewController ()

@property (nonatomic,strong) WKWebView * web;

@end

@implementation HttpErrShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务返回数据";
    
    _web = [WKWebView new];
    [self.view addSubview:_web];
    [_web loadHTMLString:self.html baseURL:nil];
    
    UIBarButtonItem * l = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onClose)];
    self.navigationItem.leftBarButtonItem = l;
}

-(void) onClose{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _web.frame = self.view.bounds;
}

+(void)showErrWithHtmlStr:(NSString *)html{
    HttpErrShowViewController * vc = [HttpErrShowViewController new];
    vc.html = html;
    UIViewController * root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [root presentViewController:nav animated:YES completion:nil];
}


@end
