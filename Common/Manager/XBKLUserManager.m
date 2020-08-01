//
//  XBKLUserManager.m
//  XueBaKuaiLai
//
//  Created by tanson on 2020/7/25.
//  Copyright © 2020 XueBaKuaiLai. All rights reserved.
//

#import "XBKLUserManager.h"
#import "XBKLIMManager.h"

@interface XBKLUserManager()

@property (nonatomic,strong) NSMutableArray * getInfoBlock;

@end

@implementation XBKLUserManager

+(instancetype)shareManger{
    static dispatch_once_t onceToken;
    static XBKLUserManager * ins;
    dispatch_once(&onceToken, ^{
        ins = [XBKLUserManager new];
    });
    return ins;
}

-(instancetype)init{
    if([super init]){
        _getInfoBlock = @[].mutableCopy;
    }
    return self;
}

-(void)logout{
    [self setToken:nil];
    [self updateIdentity:nil];
    [[XBKLIMManager sharedManager] logout];
}

-(void)setToken:(NSString*)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateIdentity:(NSString* _Nullable)identity{
    [[NSUserDefaults standardUserDefaults] setObject:identity forKey:KEY_IDENTITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)getIdentity{
    NSString * idt = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IDENTITY];
    return idt.integerValue;
}

-(BOOL)isLogined{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN] != nil;
}

-(void)getUserInfoWithBlock:(GetInfoBlock)block{

    if(self.user){
        block(self.user,nil);
        return;
    }
    
    [_getInfoBlock addObject:block];
    if(_getInfoBlock.count > 1){
        return;
    }
    

    [HttpTool getWithPath:@"customer/getUserInfo"
                    param:@{}
                     succ:^(id json) {
        
        XBKLUser * u = [XBKLUser yy_modelWithJSON:json];
        [self updateIdentity:u.identity];
        self.user = u;
        [self.getInfoBlock enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            GetInfoBlock cb = obj;
            cb(u,nil);
        }];
        [self.getInfoBlock removeAllObjects];
    } fail:^(NSError * err) {
        [self.getInfoBlock enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            GetInfoBlock cb = obj;
            cb(nil,err.domain);
        }];
        [self.getInfoBlock removeAllObjects];
    }];
    
}

@end
