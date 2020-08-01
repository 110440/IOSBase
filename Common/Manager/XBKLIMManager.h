//
//  XBKLIMManager.h
//  tcIM
//
//  Created by Mac on 2020/7/28.
//  Copyright © 2020 XBKL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIKit.h"

#define IM_MSG_CONVERSATION_UPDATE @"im_msg_conversation_update"

//V2TIM_STATUS_LOGINED                   = 1,  ///< 已登录
//V2TIM_STATUS_LOGINING                  = 2,  ///< 登录中
//V2TIM_STATUS_LOGOUT                    = 3,  ///< 无登录

typedef void(^IMConnectBlock) (V2TIMLoginStatus cStatus ,NSString * _Nullable msg);

NS_ASSUME_NONNULL_BEGIN

@interface XBKLIMManager : NSObject<V2TIMConversationListener,V2TIMSDKListener>


+(instancetype)sharedManager;

-(void)setupConfig;
-(void)loginWithUid:(NSString*)uid block:(IMConnectBlock)block;
-(void)logout;

-(void)getConversationsSucc:(void(^)(NSArray* list))succ fail:(void(^)(NSString* msg))fail;
-(void)getUnreadCompletion:(void(^)(NSInteger count))completion;

-(void)setAPNSToken:(NSData*)token;

-(void)updateTabBarUnread;

@end

NS_ASSUME_NONNULL_END
