//
//  WechatSDKHelper.m
//  
//
//

#import "WechatSDKHelper.h"


@interface WechatSDKHelper()

@property (nonatomic,copy) void (^payCallBack)(int errCode,NSString *eMsg);

@property (nonatomic,copy) void (^msgCallBack)(int errCode,NSString *eMsg);

@property (nonatomic,copy) void (^authCallBack)(int errCode,NSString *eMsg,NSString * code);

@end

@implementation WechatSDKHelper

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    static WechatSDKHelper * ins;
    dispatch_once(&onceToken, ^{
        ins = [WechatSDKHelper new];
    });
    return ins;
}

+(BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

-(BOOL)payWithSignData:(NSDictionary *)data payCallback:(void (^)(int, NSString *))payCallback{
    _payCallBack = payCallback;
    
    PayReq *req = [[PayReq alloc] init];
    req.partnerId  = data[@"partnerid"];
    req.prepayId   = data[@"prepayid"];
    req.package    = data[@"package"];
    req.nonceStr   = data[@"noncestr"];
    req.timeStamp  = [data[@"timestamp"] unsignedIntValue];
    req.sign       = data[@"sign"];
    
    [WXApi sendReq:req completion:^(BOOL success){}];
    return YES;
}

-(BOOL) sharedMsgTo:(int)type
              title:(NSString*)title
        description:(NSString*)description
              image:(UIImage*)image
                url:(NSString*)url
           callback:(void (^)(int, NSString *))callback{
    
    _msgCallBack = callback;
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = title;
    msg.description = description;
    //image = [image imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
    [msg setThumbImage:image];

    WXWebpageObject * webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    msg.mediaObject = webObj;
    
    SendMessageToWXReq * req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = msg;
    req.scene = type;
//    return [WXApi sendReq:req];
    return YES;
}


-(BOOL) sharedToMiniProgramWithtitle:(NSString*)title
                                path:(NSString*)path
                               image:(UIImage*)image
                            callback:(void (^)(int, NSString *))callback{
    
    _msgCallBack = callback;
    
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = BASE_URL;
    object.userName = @"gh_7b1518a7d383";
    object.path = path; 
    object.hdImageData = UIImagePNGRepresentation(image);
    object.withShareTicket = YES;
    object.miniProgramType = WXMiniProgramTypeRelease;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = @"小程序描述";
    message.thumbData = nil;
    message.mediaObject = object;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    [WXApi sendReq:req completion:^(BOOL success) {
    }];

    return YES;
}


-(BOOL)sendAuthReqCallBack:(void (^)(int errCode, NSString * eMsg,NSString * code))callback{
    _authCallBack = callback;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"com.kuaima.xiangfeishu";
    [WXApi sendReq:req completion:^(BOOL success) {}];
    return YES;
}


#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //分享到微信和朋友圈
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        if(response.errCode == WXSuccess){
            self.msgCallBack(0,nil);
        }else{
            self.msgCallBack(response.errCode, response.errStr);
        }
        self.msgCallBack = nil;
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {// 微信授权
        SendAuthResp *authResp = (SendAuthResp*)resp;
        if (authResp.errCode == WXSuccess) {
            self.authCallBack(0,nil,authResp.code);
        }else{
            self.authCallBack(authResp.errCode, authResp.errStr,nil);
        }
        self.authCallBack = nil;
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
    } else if([resp isKindOfClass:[PayResp class]]){
        
        PayResp * response = (PayResp*)resp;
        if(response.errCode == WXSuccess){ //服务器端查询支付通知或查询API返回的结果再提示成功
            self.payCallBack(0,nil);
        }else{
            if(self.payCallBack){
                self.payCallBack(resp.errCode, [NSString stringWithFormat:@"支付失败"]);
            }
        }
        self.payCallBack = nil;
    }
}

- (void)onReq:(BaseReq *)req {
    
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
    }
}

@end
