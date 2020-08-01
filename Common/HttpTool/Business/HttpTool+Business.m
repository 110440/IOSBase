//
//  HttpTool+Business.m
//  YiPingAudio
//
//  Created by tanson on 2018/3/19.
//  Copyright © 2018年 kuaima. All rights reserved.
//

#import "HttpTool+Business.h"
#import "AppDelegate.h"


@implementation HttpTool(Business)

+(NSDictionary *)commonHttpHeads{
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    return token.length>0? @{@"Authorization":token}:@{};
}

+(NSDictionary *)commonParams{
    //brandingCode
    //NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:USERID_KEY];
    //return userid.length>0? @{@"userId":userid}:@{};
    return @{};
}

+(void)recvePostResponseWithTask:(NSURLSessionTask *)task{
    // 保存 cookiet
    /*
    NSString * urlStr = [task.response.URL absoluteString];
    if ([urlStr rangeOfString:@"index.php/Service/Login/login"].location != NSNotFound) {
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
        NSDictionary *fields = [HTTPResponse allHeaderFields];
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:BASE_URL]];
        NSDictionary* requestFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        
        [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"cookie"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }*/
}


/***
 返回格式 : 成功返回 data 数据段，失败返回 NSError
*/

+(id) prepareBusinessJson1:(NSDictionary *)jsonObj path:(NSString*)path{
    
    NSInteger code = [jsonObj[@"code"] integerValue];
    if(code == 0){
        return jsonObj[@"data"];
    }
    else if(code == 10002){
        [(AppDelegate*)[UIApplication sharedApplication].delegate showLoginView];
        [[XBKLUserManager shareManger] logout];
        [Utils showErrMsg:@"登录失效，请重新登录"];
        NSError * e = [NSError errorWithDomain:@"登录失效，请重新登录" code:0 userInfo:nil];
        return e;
    }
    else {
        NSError * e = [NSError errorWithDomain:jsonObj[@"msg"] code:code userInfo:nil];
        return e;
    }
}

@end
