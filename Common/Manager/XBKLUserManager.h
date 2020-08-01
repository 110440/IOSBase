//
//  XBKLUserManager.h
//  XueBaKuaiLai
//
//  Created by tanson on 2020/7/25.
//  Copyright © 2020 XueBaKuaiLai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBKLUser;

typedef void (^GetInfoBlock)(XBKLUser * _Nullable u,NSString* _Nullable msg);

NS_ASSUME_NONNULL_BEGIN

@interface XBKLUserManager : NSObject

@property (nonatomic,strong) XBKLUser * user;

+(instancetype)shareManger;

-(void)logout;

-(void)setToken:(NSString* _Nullable)token;
-(void)updateIdentity:(NSString* _Nullable)identity;
-(NSInteger)getIdentity;

-(BOOL)isLogined;

-(void)getUserInfoWithBlock:(GetInfoBlock)block;

@end

NS_ASSUME_NONNULL_END
