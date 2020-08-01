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
#define KEY_IDENTITY @"identity_key"    //identity; //身身份：1-客户；2-导师；3-教务；4-助教；5-客服

#define K_WECHAT_APPID  @"wx10848d25305007fb"
#define KEY_FIRST_INSTALL @"keyFirstInstall"
#define K_IM_KEY 1400402578
#define VERIFY_TIME 60

//ENV_TYPE  0 开发 1 生产
#define  ENV_TYPE 0

#if   ENV_TYPE == 0
    #define BASE_URL @"http://39.96.62.114:13000"
#elif ENV_TYPE == 1
    #define BASE_URL @"http://39.96.62.114:13000"
#else
    #define BASE_URL @"http://39.96.62.114:13000"
#endif


//notyfi

//注册成功
#define NOTIFY_REGISTER_SUCC @"notify_register_succ"


#define data_limit  15

#endif /* CommonDef_h */
