//
//  CommonDef.h
//  XiangFeiShu
//
//  Created by tanson on 2020/4/2.
//  Copyright © 2020 XiangFeiShu. All rights reserved.
//

#ifndef CommonDef_h
#define CommonDef_h

//color
#define BackgroundColor ColorWithHex(0xF0F0F0)


//str const
#define KEY_TOKEN @"token_key"
#define K_AMAP_KEY  @"acd611c7b9346686b33e4e21b98b96a7"
#define K_WECHAT_APPID  @"wx10848d25305007fb"
#define KEY_FIRST_INSTALL @"keyFirstInstall"
#define K_IM_KEY @"nmd0cmvvchduna#test779#10001"

//ENV_TYPE  0 开发 1 生产
#define  ENV_TYPE 0

#if   ENV_TYPE == 0
    #define BASE_URL @"https://www.kangxinxiang.com"
#elif ENV_TYPE == 1
    #define BASE_URL @"https://www.kangxinxiang.com"
#else
    #define BASE_URL @"https://www.kangxinxiang.com"
#endif


//notyfi
#define kLoginSuccessNotificationName  @"kLoginSuccessNotificationName"
#define kUpdateUserInfoNotificationName  @"kUpdateUserInfoNotificationName"
#define kUpdateUserInfoDetailNotificationName  @"kUpdateUserInfoDetailNotificationName"
#define kCollectOrCancelNotificationName  @"kCollectOrCancelNotificationName"  //收藏或者取消收藏通知
#define kAddOrDelBankCardNotificationName  @"kAddOrDelBankCardNotificationName"  //添加或者删除银行卡通知
#define kWithdrawNotificationName  @"kWithdrawNotificationName"
#define kAddToShoppingCartName @"kAddToShoppingCartName"
#define kOrderNumChanged @"kOrderNumChanged"
#define kLogout @"kLogout"


#define data_limit  15

#endif /* CommonDef_h */
