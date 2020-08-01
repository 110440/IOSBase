//
//  HttpToolErrHandler.m
//  ZYYShop
//
//  Created by tanson on 2019/8/3.
//  Copyright © 2019 ZYYShop. All rights reserved.
//

#import "HttpToolErrHandler.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HttpErrShowViewController.h"

@implementation HttpToolErrHandler


+(instancetype)shareHandler{
    static dispatch_once_t onceToken;
    static HttpToolErrHandler * ins;
    dispatch_once(&onceToken, ^{
        ins = [HttpToolErrHandler new];
    });
    return ins;
}

-(instancetype)init{
    if([super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelCompletion:) name:AFNetworkingTaskDidCompleteNotification object:nil];
    }
    return self;
}

-(void)handelCompletion:(NSNotification*)n{
    NSDictionary * info = n.userInfo;
    NSError * err = info[AFNetworkingTaskDidCompleteErrorKey];
    if(err && err.code == 3840){
        NSData * data = info[AFNetworkingTaskDidCompleteResponseDataKey];
        [self showErrMsg:data];
    }
}

-(void)showErrMsg:(NSData*)data{
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
#ifdef DEBUG
    
    UIViewController * root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController * a = [UIAlertController alertControllerWithTitle:@"服务器返回非json" message:@"是否要查看返回数据?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpErrShowViewController showErrWithHtmlStr:str];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [a addAction:action1];
    [a addAction:action2];
    [root presentViewController:a animated:YES completion:nil];
    
#endif
    NSLog(@"%@",str);
}

@end
