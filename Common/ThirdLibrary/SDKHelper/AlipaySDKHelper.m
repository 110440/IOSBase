//
//  AlipaySDKHelper.m
//  DuoBao
//
//  Created by tanson on 2018/2/1.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import "AlipaySDKHelper.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AlipaySDKHelper()
@property (nonatomic,copy) void (^payCallBack)(int errCode,NSString *eMsg);
@end

@implementation AlipaySDKHelper

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    static AlipaySDKHelper * ins;
    dispatch_once(&onceToken, ^{
        ins = [AlipaySDKHelper new];
    });
    return ins;
}


-(BOOL)handleOpenURL:(NSURL *)url{
    
    if (![url.host isEqualToString:@"safepay"]) {
        return NO;
    }
    
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
        if(resultCode == 9000){
            self.payCallBack? self.payCallBack(0,nil):nil;
        }else{
            NSLog(@"支付失败:%@",resultDic);
            self.payCallBack? self.payCallBack(0,@"支付失败"):nil;
        }
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {

        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
    
    return YES;
}

-(void) payWithSign:(NSString*)sign
             Scheme:(NSString*)scheme
        payCallback:(void (^)(int errCode,NSString *eMsg))payCallback{
    self.payCallBack = payCallback;
    
    [[AlipaySDK defaultService] payOrder:sign fromScheme:scheme callback:^(NSDictionary *resultDic) {
        NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
        if(resultCode == 9000){
            self.payCallBack? self.payCallBack(0,nil):nil;
        }else{
            NSLog(@"支付失败:%@",resultDic);
            self.payCallBack? self.payCallBack(0,@"支付失败"):nil;
        }
    }];
}

@end
