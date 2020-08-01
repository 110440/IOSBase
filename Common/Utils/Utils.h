//
//  Utils.h
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utils : NSObject

+(void)showLoading;
+(void)showLoadingWithMsg:(NSString*)msg;
+(void)hideLoading;
+(void)showSuccMsg:(NSString*)msg;
+(void)showErrMsg:(NSString*)msg;
+(void)showInfoMsg:(NSString*)msg;

//当前顶部vc
+ (UIViewController *)topViewController;


+ (void)showAlertWithTitle:(NSString*)title
                      btn1:(NSString*)btn1
                      btn2:(NSString*)btn2
                 btn1Block:(void(^)(void))btn1Block
                 btn2Block:(void(^)(void))btn2Block;

+ (void)showAlertWithTitle:(NSString*)title
                       msg:(NSString*)msg
                      btn1:(NSString*)btn1
                      btn2:(NSString*)btn2
                 btn1Block:(void(^)(void))btn1Block
                 btn2Block:(void(^)(void))btn2Block;

+(NSString*)timeStrFromInterval:(NSTimeInterval)interval;

+(NSString *)friendlyDateString:(NSTimeInterval)timeInterval
                forConversation:(BOOL)isShort;

+(BOOL)isFirstInstallApp;


@end
