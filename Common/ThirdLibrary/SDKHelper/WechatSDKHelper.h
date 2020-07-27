//
//  WechatSDKHelper.h
//  
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WechatSDKHelper : NSObject<WXApiDelegate>

+(instancetype) shareManager;
+(BOOL) isWXAppInstalled;

//支付
-(BOOL) payWithSignData:(NSDictionary*)data
            payCallback:(void (^)(int errCode,NSString *eMsg))payCallback;

//分享 会话(WXSceneSession)  朋友圈(WXSceneTimeline）
-(BOOL) sharedMsgTo:(int)type
              title:(NSString*)title
        description:(NSString*)description
              image:(UIImage*)image
                url:(NSString*)url
           callback:(void (^)(int code, NSString * eMsg))callback;

//分到小程序
-(BOOL) sharedToMiniProgramWithtitle:(NSString*)title
                                path:(NSString*)path
                               image:(UIImage*)image
                            callback:(void (^)(int, NSString *))callback;
    
//登录授权
-(BOOL)sendAuthReqCallBack:(void (^)(int errCode, NSString * eMsg,NSString * code))callback;

@end
