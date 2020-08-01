//
//  XBKLIMManager.m
//  tcIM
//
//  Created by Mac on 2020/7/28.
//  Copyright © 2020 XBKL. All rights reserved.
//

#import "XBKLIMManager.h"
#import "TUITextMessageCellData.h"

static NSData * gPushToken = nil;

@interface XBKLIMManager()

@property (nonatomic,strong) NSMutableArray * connectBlocks;

@end

@implementation XBKLIMManager


+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static XBKLIMManager * ins;
    dispatch_once(&onceToken, ^{
        ins = [XBKLIMManager new];
    });
    return ins;
}

-(instancetype)init{
    if([super init]){
        _connectBlocks = @[].mutableCopy;
    }
    return self;
}

-(void)setupConfig{
    V2TIMSDKConfig *config = [V2TIMSDKConfig new];
    config.logLevel = V2TIM_LOG_INFO;
    [[V2TIMManager sharedInstance] initSDK:K_IM_KEY config:config listener:self];
    [self configTXIMLook];
    [self configListener];
}

-(void)configTXIMLook{
    
    TUIKitConfig *config = [TUIKitConfig defaultConfig];
    config.defaultAvatarImage = [UIImage imageNamed:@"test1"];
    config.avatarType = TAvatarTypeRadiusCorner;
    config.avatarCornerRadius = 3;
    
    // 设置发送头像大小；设置接收的方法类似
    [TUIMessageCellLayout outgoingTextMessageLayout].avatarSize = CGSizeMake(37, 37);
    [TUIMessageCellLayout incommingTextMessageLayout].avatarSize = CGSizeMake(37, 37);
    // 设置发送位置；设置接收的方法类似
    [TUIMessageCellLayout outgoingTextMessageLayout].avatarInsets = UIEdgeInsetsMake(0,12,0,15);
    [TUIMessageCellLayout incommingTextMessageLayout].avatarInsets = UIEdgeInsetsMake(0,15,0,12);
    
    // 设置发送气泡，包括普通状态和选中状态；设置接收的方法类似
    [TUIBubbleMessageCellData setOutgoingBubble:[UIImage imageNamed:@"chat_out"]];
    [TUIBubbleMessageCellData setOutgoingHighlightedBubble:[UIImage imageNamed:@"chat_out"]];
    [TUIBubbleMessageCellData setIncommingBubble:[UIImage imageNamed:@"chat_in"]];
    [TUIBubbleMessageCellData setIncommingHighlightedBubble:[UIImage imageNamed:@"chat_in"]];
    
    // 设置发送气泡边距；设置接收的方法类似
    [TUIMessageCellLayout outgoingTextMessageLayout].bubbleInsets = UIEdgeInsetsMake(12,20,8,20);
    [TUIMessageCellLayout incommingTextMessageLayout].bubbleInsets = UIEdgeInsetsMake(12,20,8,20);
    
    // 设置发送文字消息的字体和颜色；设置接收的方法类似
    [TUITextMessageCellData setOutgoingTextFont:[UIFont systemFontOfSize:14]];
    [TUITextMessageCellData setOutgoingTextColor:[UIColor whiteColor]];
    [TUITextMessageCellData setIncommingTextFont:[UIFont systemFontOfSize:14]];
    [TUITextMessageCellData setIncommingTextColor:ColorWithHex(0x333333)];
    
}

//监听通知
-(void)configListener{
    [[V2TIMManager sharedInstance] setConversationListener:self];
}


-(void)loginWithUid:(NSString*)uid block:(IMConnectBlock)block{
    
    V2TIMLoginStatus status = [[V2TIMManager sharedInstance] getLoginStatus];
    
    if( status == V2TIM_STATUS_LOGINED){
        block(V2TIM_STATUS_LOGINED,nil);
        return;
    }
    
    block(V2TIM_STATUS_LOGINING,nil);
    [_connectBlocks addObject:block];
    if(status == TIM_STATUS_LOGINING) return;
    
    [HttpTool postWithPath:@"im/getUsersig"
                     param:@{@"imUsername":uid}
                      succ:^(id json) {
        NSString * userSig = json[@"userSig"];
        [self _loginTXIMWithUid:uid sig:userSig];
                      } fail:^(NSError * err) {
                          for(IMConnectBlock block in self.connectBlocks){
                              block(V2TIM_STATUS_LOGOUT,err.domain);
                          }
                          [self.connectBlocks removeAllObjects];
                      }];
}

-(void)_loginTXIMWithUid:(NSString*)uid sig:(NSString*)sig{
    
    [[V2TIMManager sharedInstance] login:uid userSig:sig succ:^{
        
        for(IMConnectBlock block in self.connectBlocks){
            block(V2TIM_STATUS_LOGINED,nil);
        }
        [self.connectBlocks removeAllObjects];
        
        //推送设置
        if(gPushToken){
            [self setAPNSToken:gPushToken p12Id:11111 completion:^(NSString *eMsg) {}];
        }

        [[V2TIMManager sharedInstance] getUsersInfo:@[uid] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
        } fail:^(int code, NSString *desc) {}];
        
    } fail:^(int code, NSString *desc) {
        for(IMConnectBlock block in self.connectBlocks){
            block(V2TIM_STATUS_LOGOUT,desc);
        }
        [self.connectBlocks removeAllObjects];
    }];
}


-(void)logout{
    [[V2TIMManager sharedInstance] logout:^{} fail:^(int code, NSString *msg) {}];
}


-(void)setAPNSToken:(NSData*)token{
    gPushToken = token;
}

-(void)setAPNSToken:(NSData*)token
              p12Id:(uint32_t)p12Id
         completion:(void(^)(NSString * eMsg))completion{
    V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
    // 企业证书 ID，上传证书到 IM 控制台后生成
    confg.businessID = p12Id;
    confg.token = token;
    [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
        completion(nil);
    } fail:^(int code, NSString *msg) {
         completion(msg);
    }];
}


-(void)getUnreadCompletion:(void(^)(NSInteger count))completion{
    __block NSInteger unReadCount = 0;
    [self getConversationsSucc:^(NSArray * _Nonnull list) {
        [list enumerateObjectsUsingBlock:^(V2TIMConversation* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            unReadCount += obj.unreadCount;
        }];
        completion(unReadCount);
    } fail:^(NSString * _Nonnull msg) {
    }];
}

-(void)getConversationsSucc:(void(^)(NSArray* list))succ fail:(void(^)(NSString* msg))fail{
    
    //假设不超过100个会话
    [[V2TIMManager sharedInstance] getConversationList:0 count:100
        succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
        // 重新按照会话 lastMessage 的 timestamp 对 UI 会话列表做排序
        //NSMutableArray * convList = list.mutableCopy;
        //[convList sortUsingComparator:^NSComparisonResult(V2TIMConversation *obj1, V2TIMConversation *obj2) {
        //    return [obj2.lastMessage.timestamp compare:obj1.lastMessage.timestamp];
        //}];
        succ(list);
    } fail:^(int code, NSString *msg) {
        fail(msg);
    }];
}

- (void)updateTabBarUnread{
    
}


#pragma mark-  V2TIMSDKListener 连接状态

/// SDK 正在连接到腾讯云服务器
- (void)onConnecting{
    
}

/// SDK 已经成功连接到腾讯云服务器
- (void)onConnectSuccess{
    
}

/// SDK 连接腾讯云服务器失败
- (void)onConnectFailed:(int)code err:(NSString*)err{
    
}

/// 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。
- (void)onKickedOffline{
    //可以通过 UI 提示用户“您已经在其他端登录了当前账号，是否重新登录？” 如果用户选择“是”，就可以进行重新登录。
}

/// 在线时票据过期：此时您需要生成新的 userSig 并再次调用 V2TIMManager 的 login() 函数重新登录。
- (void)onUserSigExpired{
    //重新登陆
}

/// 当前用户的资料发生了更新
- (void)onSelfInfoUpdated:(V2TIMUserFullInfo *)Info{
    
}


#pragma mark- V2TIMConversationListener 会话通知

/**
 * 同步服务器会话开始，SDK 会在登录成功或者断网重连后自动同步服务器会话，您可以监听这个事件做一些 UI 进度展示操作。
 */
- (void)onSyncServerStart{
    
}

/**
 * 同步服务器会话完成，如果会话有变更，会通过 onNewConversation | onConversationChanged 回调告知客户
 */
- (void)onSyncServerFinish{
    
}

/**
 * 同步服务器会话失败
 */
- (void)onSyncServerFailed{
    
}

/**
 * 有新的会话（比如收到一个新同事发来的单聊消息、或者被拉入了一个新的群组中），可以根据会话的 lastMessage -> timestamp 重新对会话列表做排序。
 */
- (void)onNewConversation:(NSArray<V2TIMConversation*> *) conversationList{
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_MSG_CONVERSATION_UPDATE object:nil];
    [self updateTabBarUnread];
}

/**
 * 某些会话的关键信息发生变化（未读计数发生变化、最后一条消息被更新等等），可以根据会话的 lastMessage -> timestamp 重新对会话列表做排序。
 */
- (void)onConversationChanged:(NSArray<V2TIMConversation*> *) conversationList{
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_MSG_CONVERSATION_UPDATE object:nil];
    [self updateTabBarUnread];
}


@end
